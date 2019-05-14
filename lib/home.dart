import 'package:flutter/material.dart';

import 'package:amc/main.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Header(),
        preferredSize: Size(0,50),),
      body: Center(
          child: Text(
              'Home',
              style: TextStyle(fontSize: 50.0),
              ),
          ),
      bottomNavigationBar: Footer(),
    );
  }
}