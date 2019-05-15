import 'package:flutter/material.dart';
import 'package:amc/main.dart';

class ShiftsPage extends StatelessWidget {
  final _tabPages = <Widget>[
    Schedule(),
    Swap(),
    TimeOff(),
  ];
  final _tabs = <Tab>[
    Tab(text: 'My Schedule'),
    Tab(text: 'Swap Shifts'),
    Tab(text: 'Time Off'),
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

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'My Schedule',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}

class Swap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Swap Shifts',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}

class TimeOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Time Off',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}