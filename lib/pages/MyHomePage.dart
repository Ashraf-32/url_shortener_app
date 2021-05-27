import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_shortener_app/pages/SideBar.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key}) : super(key: key);
  final storage;
  MyHomePage({this.storage});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _requestUrl = Uri.parse("https://ashortl.herokuapp.com/api/");
  Map _response = Map();
  // String _inputUrl = '';
  String _shortUrl = '';
  bool _visible = false;
  bool _showProgressbar = false;

  final inputUrlController = TextEditingController();
  final shortUrlController = TextEditingController();

  void submit() async {
    FocusScope.of(context).unfocus();
    if (inputUrlController.text != "") {
      setState(() => _showProgressbar = true);
      var token = await widget.storage.readSecureData("token");
      var response = await http.post(_requestUrl,
        body: '{"url": "${inputUrlController.text}"}',
        headers: {"Content-Type": 'application/json', "Authorization": "Token $token"}
      );
      if (response.statusCode >= 200 && response.statusCode <= 400) {
        setState(() {
          _showProgressbar = false;
          _response = jsonDecode(response.body);
          _shortUrl = _response['short'];
          shortUrlController.text = _shortUrl;

          _visible = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An error occured!',
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
          'Enter an Url!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blueGrey,
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
    }
  }


  void copy() {
    ClipboardData data = ClipboardData(text: _shortUrl);
    Clipboard.setData(data);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Link Copied to Clipboard!'),
        backgroundColor: Colors.blueGrey,
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(storage: widget.storage),
      appBar: AppBar(
        title: Text("AShortL"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.link),
                labelText: "Enter the link...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: submit,
                  splashColor: Colors.blue,
                  tooltip: "Shorten",
                )
              ),
              controller: inputUrlController,
              onChanged: (val) {
                setState(() {
                  _visible = false;
                });
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Opacity(
            opacity: !_visible && _showProgressbar ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  labelText: "Short Link",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: copy,
                    splashColor: Colors.blue,
                    tooltip: "Copy",
                  )
                ),
                controller: shortUrlController,
              ),
            ),
          )
        ],
      ),
    );
  }
}