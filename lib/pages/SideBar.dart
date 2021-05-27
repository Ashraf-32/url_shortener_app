import 'package:flutter/material.dart';
import 'package:url_shortener_app/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:url_shortener_app/pages/MyHomePage.dart';
import 'package:url_shortener_app/pages/ProfilePage.dart';

class SideBar extends StatelessWidget {
  // const SideBar({Key key}) : super(key: key);
  final storage;
  SideBar({this.storage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'AShortL',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage(storage: storage,)), (route) => false)},
          ),
          ListTile(
            leading: Icon(Icons.account_circle_sharp),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(storage: storage,)))
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              var token = await storage.readSecureData("token");
              await http.post(Uri.parse("https://ashortl.herokuapp.com/api/logout/"),
                headers: {"Authorization": "Token $token"}
              );
              await storage.deleteSecureData("token");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(storage: storage)));
            },
          ),
        ],
      ),
    );
  }
}