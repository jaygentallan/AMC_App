import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';
import 'package:amc/social/crew.dart';
import 'package:amc/services/crud.dart';
import 'package:amc/singletons/userdata.dart';

class SocialPage extends StatelessWidget {

  CrudMethods crud = CrudMethods();

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

            // Refresh data
            FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      crud.getData().then((results) {
                        userData.users = results;
                      });
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  } else {
                    return Container(width: 0.0, height: 0.0);
                  }
                }
            ),

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

  Future<void> _refresh() async
  {
    print('Refreshing');
    Crew();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
      color: Colors.white,
      onRefresh: _refresh,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            width: 0.0,
            height: 40.0,
            alignment: FractionalOffset.center,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(132, 26, 42, 1.0),
                    offset: Offset(0.0,6.0),
                  ),
                ],
              color: const Color.fromRGBO(206, 38, 64, 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(32.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CrewList())
                );
              },
              child: Center(
                child: Text(
                  'Meet Your Crew',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                  ),
                ),
              )
            )
          )
        ],
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