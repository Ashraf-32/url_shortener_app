import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:url_shortener_app/services/SecureStorage.dart';
import 'package:url_shortener_app/pages/MyHomePage.dart';
import 'package:url_shortener_app/pages/SignupPage.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key key}) : super(key: key);

  final storage;
  LoginPage({this.storage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _loginUrl = Uri.parse("https://ashortl.herokuapp.com/api/login/");
  Map _response = Map();
  bool _isloading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void login() async {
    if (nameController.text != "" && passwordController.text != "") {
      setState(() {
        _isloading = true;
      });
      var response = await http.post(_loginUrl,
        body: '{"username": "${nameController.text}", "password": "${passwordController.text}"}',
        headers: {"Content-Type": 'application/json'}
      );
      _response = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await widget.storage.writeSecureData("token", _response['token']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(storage: widget.storage)));

      } else {
        setState(() {
          _isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_response['non_field_errors']}',
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
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
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
                  SizedBox(
                    height:20.0
                  ),
                  Container(
                    height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Login'),
                        onPressed: login,
                      )),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Signup',
                            style: TextStyle(fontSize: 15),
                          ),
                          splashColor: Colors.grey,
                          onPressed: () {
                            //signup screen
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage(storage: widget.storage)));
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