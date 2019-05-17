import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

import 'animations/loginAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  var statusClick = 0;
  String _email;
  String _password;

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
      resizeToAvoidBottomPadding: false,
      body: Stack(
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
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
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

                          SizedBox(height: 80.0), // Used to add padding

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
                                      "amazing",
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

                          TextField( // Email text box
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 15.0, top: 5.0, bottom: 5.0),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color.fromRGBO(206, 38, 64, 1.0)
                                ),
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Colors.white, fontSize: 15),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.white24),
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              }
                              );
                            },
                          ),

                          SizedBox(height: 10.0), // Used as padding

                          TextField( // Password text box
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 15.0, top: 5.0, bottom: 5.0),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color.fromRGBO(
                                        206, 38, 64, 1.0)),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.white, fontSize: 15),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.white24),
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              }
                              );
                            },
                            obscureText: true,
                          ),

                          SizedBox(height: 40.0), // Used as padding
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            ),

            Container(
              width: _width,
              height: _height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  SignupButton(),

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
                          FirebaseAuth.instance // Firebase authorization
                              .signInWithEmailAndPassword(
                            email: _email,
                            password: _password,)
                              .then((FirebaseUser user) {
                            Navigator.of(context).pushReplacementNamed('/homepage');
                          }) // If authorized, sends to homepage
                              .catchError((e) {
                            Navigator.of(context).pushReplacementNamed('/login');
                            print(e);
                          }
                          );
                        },
                        child: LoginButton()
                      )
                    )
                    : StartAnimation(
                        buttonController: animationControllerButton.view,),

                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 220.0,
          height: 50.0,
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
            "Log In",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlatButton(
          child: Text(
            "Don't have an account? Sign up here",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.3,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/signup');
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