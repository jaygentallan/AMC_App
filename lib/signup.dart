import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

import 'services/usermanagement.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Background(),
            Center(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Image.asset(
                        'assets/amc_logo.png',
                        width: 200.0,
                        height: 200.0,
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        'Employee Signup',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25.0),

                      TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15.0,top: 5.0,bottom: 5.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.white24),
                          filled: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value; }
                          );
                        },
                      ),

                      SizedBox(height: 10.0),

                      TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15.0,top: 5.0,bottom: 5.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.white24),
                          filled: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value; }
                          );
                        },
                        obscureText: true,
                      ),

                      SizedBox(height: 20.0),

                      Stack(
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 40.0,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(206, 38, 64, 1.0),
                              borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                            ),
                            child: FlatButton(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _email,
                                    password: _password,
                                  ).then((signedInUser) {
                                    UserManagement().storeNewUser(signedInUser,context);
                                  }).catchError((e) {
                                    print(e);
                                  }
                                  );
                                }
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.0),

                      Stack(
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 40.0,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(206, 38, 64, 1.0),
                              borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                            ),
                            child: FlatButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              onPressed: () {
                                Navigator.of(context).popAndPushNamed('/landingpage');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ),
          ],
        ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}