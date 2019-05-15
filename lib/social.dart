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
      child: ListView(
        children: <Widget>[
          Container(
            child: TabBar(
              tabs: _tabs,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black26,
              indicatorColor: Colors.redAccent,
            ),
          ),
          SizedBox(height: 500.0),
          Container(
            child: Center(
                child: Text('News')
            ),
          ),
        ],
      )
    );
  }
}

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('News'),
      ),
    );
  }
}

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Vote'),
      ),
    );
  }
}

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Events'),
      ),
    );
  }
}