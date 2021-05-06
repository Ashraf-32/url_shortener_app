import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AShortL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

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

  final controller = TextEditingController();
  final controllerval = TextEditingController();

  void submit() async {
    if (controller.text != "") {
      setState(() => _showProgressbar = true);
      var response = await http.post(_requestUrl,
        body: '{"url": "${controller.text}"}',
        headers: {"Content-Type": 'application/json'}
      );
      if (response.statusCode >= 200 && response.statusCode <= 400) {
        setState(() {
          _showProgressbar = false;
          _response = jsonDecode(response.body);
          _shortUrl = _response['short'];
          controllerval.text = _shortUrl;

          _visible = true;
        });
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
              controller: controller,
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
                controller: controllerval,
              ),
            ),
          )
        ],
      ),
    );
  }
}