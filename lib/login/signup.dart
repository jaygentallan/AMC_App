import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:amc/home/home.dart';
import 'package:amc/animations/signupAnimation.dart';

import 'package:amc/services/usermanagement.dart';
import 'package:amc/services/crud.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin{
  var statusClick = 0;
  String _firstName;
  String _lastName;
  String _employeeID;
  String _email;
  String _password;
  //String _docID;

  CrudMethods crud = CrudMethods();

  AnimationController animationControllerButton;
  Animation animationScreen;

  void initState() {
    super.initState();

    animationControllerButton = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerButton.dispose();
  }

  Future<Null> _playAnimation() async {
    await animationControllerButton.forward();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget> [
        SizedBox(height: 50.0),

        Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/amc_newark.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5,sigmaY: 2.5),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
              ),
            ),
          ),

        Container(
          child: Stack(
            children: <Widget>[

              Positioned.fill(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[

                        SizedBox(height: 50.0), // Used to add padding

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(132, 26, 42, 1.0),
                                offset: Offset(0.0,7.5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[

                              Container(
                                child: Image.asset( // AMC Logo
                                  'assets/amc_logo.png',
                                  width: 225.0,
                                  height: 225.0,
                                ),
                              ),

                              Container(
                                width: 225,
                                height: 225,
                                child: Align (
                                  alignment: Alignment(0.0,0.55),
                                  child: Text(
                                    "crew",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.5,
                                      fontFamily: 'AMC2',
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 50.0),

                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black26,
                            contentPadding: const EdgeInsets.only(left: 15.0,top: 5.0,bottom: 5.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                            ),
                            labelText: 'First Name',
                            labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                            hintText: 'Enter your first name',
                            hintStyle: TextStyle(color: Colors.white24),
                            filled: true,
                          ),
                          cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                          onChanged: (value) {
                            setState(() {
                              _firstName = value; }
                            );},
                        ),

                        SizedBox(height: 10.0),

                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black26,
                            contentPadding: const EdgeInsets.only(left: 15.0,top: 5.0,bottom: 5.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                            ),
                            labelText: 'Last Name',
                            labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                            hintText: 'Enter your last name',
                            hintStyle: TextStyle(color: Colors.white24),
                            filled: true,
                          ),
                          cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                          onChanged: (value) {
                            setState(() {
                              _lastName = value; }
                            );},
                        ),

                        SizedBox(height: 10.0),

                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black26,
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
                          cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                          onChanged: (value) {
                            setState(() {
                            _email = value; }
                          );},
                        ),

                        SizedBox(height: 10.0),

                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black26,
                            contentPadding: const EdgeInsets.only(left: 15.0,top: 5.0,bottom: 5.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                            ),
                            labelText: 'Employee ID',
                            labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                            hintText: 'Enter your employee ID',
                            hintStyle: TextStyle(color: Colors.white24),
                            filled: true,
                          ),
                          cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                          onChanged: (value) {
                            setState(() {
                              _employeeID = value; }
                            );
                          },
                        ),

                        SizedBox(height: 10.0),

                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black26,
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
                          cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                          onChanged: (value) {
                            setState(() {
                              _password = value; }
                            );
                          },
                          obscureText: true,
                        ),

                        SizedBox(height: 120.0), // Used as padding

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            CancelButton(),

                            statusClick == 0 // Condition statement if button is clicked
                                ? Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      statusClick = 1;
                                    });
                                    _playAnimation(); // Plays the button animation

                                    await Future.delayed(const Duration(seconds: 2));

                                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: _email,
                                      password: _password,
                                    ).then((signedInUser) {
                                      //_docID = Firestore.instance.document().documentID;

                                      List<String> data = [
                                        this._firstName,
                                        this._lastName,
                                        this._employeeID,
                                        //this._docID,
                                      ];

                                      UserManagement().storeNewUser(signedInUser, data, context);

                                      Navigator.of(context).popAndPushNamed('/login');
                                    })
                                        .catchError((e) {
                                      print(e);
                                    }
                                    );
                                  },// If authorized, sends to homepage
                                  child: SignupButton(),
                                )
                            )
                                : StartAnimation(
                              buttonController: animationControllerButton.view,),

                            SizedBox(height: 10.0),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        ],
      ),
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


class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 220.0,
          height: 40.0,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(132, 26, 42, 1.0),
                offset: Offset(0.0,6.0),
              ),
            ],
            color: const Color.fromRGBO(206, 38, 64, 1.0),
            borderRadius: BorderRadius.all(const Radius.circular(30.0)),
          ),
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlatButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ],
    );
  }
}

class AnimationScreen extends AnimatedWidget {
  AnimationScreen({Key key,Animation<double> animation}):super(key :key, listenable : animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      color: const Color.fromRGBO(206, 38, 64, 1.0),
    );
  }
}