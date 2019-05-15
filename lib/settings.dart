import 'package:flutter/material.dart';
import 'package:amc/main.dart';

import 'main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/amc_logo.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Settings'),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
      ),
      endDrawer: SideDrawer(),
      body: Center(
        child: Icon(
          Icons.settings,
          size: 64.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(
          Icons.arrow_back,
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }
}