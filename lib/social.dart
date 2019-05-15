import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class SocialPage extends StatelessWidget {
  final _tabPages = <Widget>[
    News(),
    Vote(),
    Events(),
  ];
  final _tabs = <Tab>[
    Tab(text: 'News'),
    Tab(text: 'Vote'),
    Tab(text: 'Events'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent.withOpacity(0.0),
          flexibleSpace: Column(
            children: <Widget>[
              TabBar(
                tabs: _tabs,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black26,
                indicatorColor: const Color.fromRGBO(206, 38, 64, 1.0),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _tabPages,
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
          'News',
          style: TextStyle(
            fontSize: 30,
          ),
      ),
    );
  }
}

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Vote',
        style: TextStyle(
          fontSize: 30,
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
        'Events',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}