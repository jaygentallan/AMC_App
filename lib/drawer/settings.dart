import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Image.asset(
                  'assets/amc_logo.png',
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: SideDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Icon(
            IconData(0xe810,fontFamily: 'line_icons'),
            size: 64.0,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(
          Icons.arrow_back,
        ),
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
    );
  }
}