import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class SocialPage extends StatelessWidget {
  final _tabPages = <Widget>[
    Crew(),
    News(),
    Events(),
  ];
  final _tabs = <Tab>[
    Tab(text: 'CREW'),
    Tab(text: 'NEWS'),
    Tab(text: 'EVENTS'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent.withOpacity(0.0),
            flexibleSpace: Column(
              children: <Widget>[
                Material(
                  color: Colors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
                  child: TabBar(
                    tabs: _tabs,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
                    unselectedLabelColor: Colors.white30,
                    indicatorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget> [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage('assets/background.png'),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
                ),
              ),
            ),

            TabBarView(
              //physics: NeverScrollableScrollPhysics(),
              children: _tabPages,
            ),
          ],
        ),
      ),
    );
  }
}

class Crew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          '',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
      ),
    );
  }
}

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}