import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_shortener_app/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:url_shortener_app/pages/MyHomePage.dart';

class SignupPage extends StatefulWidget {
  // SignupPage({Key key}) : super(key: key);
  
  final storage;
  SignupPage({this.storage});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _signupUrl = Uri.parse("https://ashortl.herokuapp.com/api/register/");
  bool _isloading = false;
  Map _response = Map();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  void signup() async {
    if (usernameController.text != "" && emailController.text != "" && passwordController.text != "" && confirmpasswordController.text != "") {
      if (passwordController.text == confirmpasswordController.text) {
        setState(() {
          _isloading = true;
        });
        var response = await http.post(_signupUrl,
          body: '{"username": "${usernameController.text}", "email": "${emailController.text}", "password": "${passwordController.text}", "password2": "${confirmpasswordController.text}"}',
          headers: {"Content-Type": 'application/json'}
        );
        _response = jsonDecode(response.body);
        if (response.statusCode == 201) {
          await widget.storage.writeSecureData("token", _response['token']);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(storage: widget.storage)));

        } else {
          setState(() {
            _isloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_response['details']}',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blueGrey,
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Password does not match',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blueGrey,
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Fill in the blank fields',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blueGrey,
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading ? Center(child: CircularProgressIndicator()) : SafeArea(
          child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Sample App'),
          // ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'AShortL',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: confirmpasswordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height:20.0
                  ),
                  Container(
                    height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Sign Up'),
                        onPressed: signup,
                      )),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('Have account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 15),
                          ),
                          splashColor: Colors.grey,
                          onPressed: () {
                            //login screen
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(storage: widget.storage,)));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                  ))
                ],
              ))),
    );
  }
}