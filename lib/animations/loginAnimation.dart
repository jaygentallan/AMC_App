import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../home.dart';

class StartAnimation extends StatefulWidget {
  StartAnimation({Key key, this.buttonController, this.user, this.pass})
  : shrinkButtonAnimation = Tween(
    begin: 220.0,
    end: 65.0,
  ).animate(CurvedAnimation(
    parent: buttonController,
    curve: Interval(
      0.0,
      0.150,
      ),
    ),
  ),

    zoomAnimation = Tween(
        begin: 65.0,
        end: 1000.0,
    ).animate(CurvedAnimation(
        parent: buttonController,
        curve: Interval(
          0.550,
          0.999,
          curve: Curves.bounceInOut,
        ),
    ),
  ),

  super(key:key);

  final AnimationController buttonController;
  final Animation shrinkButtonAnimation;
  final Animation zoomAnimation;

  final String user;
  final String pass;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        zoomAnimation.value <= 200 ?
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Container(
            width: shrinkButtonAnimation.value,
            height: 50.0,
            alignment: FractionalOffset.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(206, 38, 64, 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(60.0)),
            ),
            child: FlatButton(
              onPressed: () {},
                child: shrinkButtonAnimation.value > 77 ? // Conditional statement to change to loading indicator
                Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                  ),
                )
              : SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ),
          )
        )
          : Container(
            width: zoomAnimation.value,
            height: zoomAnimation.value,

            decoration: BoxDecoration(
              shape: zoomAnimation.value < 400 ?
                BoxShape.circle :
                BoxShape.rectangle,
              color: const Color.fromRGBO(206, 38, 64, 1.0),
            ),
          )
      ],
    );
  }
  @override
  _StartAnimationState createState() => _StartAnimationState();
}

class _StartAnimationState extends State<StartAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: widget._buildAnimation,
      animation: widget.buttonController,
    );
  }
}