import 'package:flutter/material.dart';

class ShiftsPage extends StatelessWidget {
  final _tabPages = <Widget>[
    Schedule(),
    Swap(),
    TimeOff(),
  ];
  final _tabs = <Tab>[
    Tab(text: 'SCHEDULE'),
    Tab(text: 'SWAP'),
    Tab(text: 'TIME OFF'),
  ];

  @override
  Widget build(BuildContext context) {
    //double _width = MediaQuery.of(context).size.width;
    //double _height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.black,
            flexibleSpace: Column(
              children: <Widget>[
                Material(
                  color: Colors.black,
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
          children: <Widget>[

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

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          '',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
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
        '',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
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
        '',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}