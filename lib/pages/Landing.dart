import 'package:flutter/material.dart';
import 'package:url_shortener_app/pages/MyHomePage.dart';
import 'package:url_shortener_app/pages/LoginPage.dart';
import 'package:url_shortener_app/services/SecureStorage.dart';

final _storage = SecureStorage();

class Landing extends StatefulWidget {
  Landing({Key key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  bool _isLoading = true;
  bool _signedin = false;

  void _selectedScreen() async {
    String check = await _storage.readSecureData('token');
    if (check == null || check == "") {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _signedin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    else if (_signedin) return MyHomePage(storage: _storage);
    else return LoginPage(storage: _storage);
  }
}