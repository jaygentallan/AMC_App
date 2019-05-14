import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Header(),
        preferredSize: Size(0,50),),
      body: Center(
          child: Text(
              'Profile',
              style: TextStyle(fontSize: 50.0),
          ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}