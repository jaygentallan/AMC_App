import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amc/social/crew.dart';
import 'package:amc/services/crud.dart';
import 'package:amc/singletons/userdata.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

// Class for the page, is called by the main script through tabs
class _SocialPageState extends State<SocialPage> {

  CrudMethods crud = CrudMethods();

  // List of the subgroups of the social page
  final _tabPages = <Widget>[
    Crew(),
    News(),
    Events(),
  ];

  // Labels for the tabs
  final _tabs = <Tab>[
    Tab(text: 'CREW'),
    Tab(text: 'NEWS'),
    Tab(text: 'EVENTS'),
  ];

  @override
  Widget build(BuildContext context) {
    // Returns Tab Controller for the tabs
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
                    labelColor: const Color.fromRGBO(250,205,85, 0.75),
                    labelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
                    unselectedLabelColor: Colors.white,
                    indicatorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget> [

            // Future builder for refreshing data in the singleton
            FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      crud.getUsers().then((results) {
                        userData.users = results;
                      });
                      // Get posts from firebase and put it on singleton
                      crud.getCrewPosts().then((results) {
                        userData.posts = results;
                      });

                    }
                  }
                  return Container(height: 0.0, width: 0.0);
                }
            ),

            // Background of the page
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // The body pages
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _tabPages,
            ),

          ],
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