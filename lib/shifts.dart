import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class Shifts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Header(),
        preferredSize: Size(0,50),),
      body: Center(child: Text('Shifts')),
      endDrawer: SideDrawer(),
      bottomNavigationBar: Footer(),
    );
  }
}