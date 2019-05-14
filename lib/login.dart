import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';

import 'home.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  String _email = '';
  String _password = '';

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }
  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _emailFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/amc_newark.jpg'),
                fit: BoxFit.cover,
              )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5,sigmaY: 2.5),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
              )
            )
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 120.0),
                    Image.asset(
                        'assets/amc_logo.png',
                        width: 200.0,
                        height: 200.0,
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                      ),
                      obscureText: true,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () {
                          },
                        ),
                        FlatButton(
                          child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage())
                            );
                          }
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}