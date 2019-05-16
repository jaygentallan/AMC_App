import 'package:flutter/material.dart';

import 'package:amc/main.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {


  Widget build(BuildContext context) {
    return Center(
      child: Icon(
          Icons.home,
          size: 64.0
      ),
    );
  }
}