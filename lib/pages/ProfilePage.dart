import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  // const ProfilePage({Key key}) : super(key: key);
  final storage;
  ProfilePage({this.storage});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isloading = true;
  dynamic _response;

  void fetchProfile() async {
    var token = await widget.storage.readSecureData("token");
    var response = await http.get(Uri.parse('https://ashortl.herokuapp.com/api/profile/'),
      headers: {"Authorization": "Token $token"}
    );
    _response = jsonDecode(response.body);
    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AShortL"),
        centerTitle: true,
      ),
      body: _isloading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _response.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${_response[0]['username']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${_response[0]['email']}',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  )
                ),
              ],
            );
          } else {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                  ),
                  controller: TextEditingController(text: _response[index]['url']),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: _response[index]['short']),
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.copy),
                      splashColor: Colors.blue,
                      tooltip: "Copy",
                      onPressed: () {
                        ClipboardData data = ClipboardData(text: _response[index]['short']);
                        Clipboard.setData(data);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Link Copied to Clipboard!'),
                            backgroundColor: Colors.blueGrey,
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
                      },
                    )
                  ),
                  // controller: _response[index]['short'],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10
                )
              ],
            );
          }
        },
        // separatorBuilder: (BuildContext context, int index) {
        //   return const Divider();
        // },
      ),
    );
  }
}