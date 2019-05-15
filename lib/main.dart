import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'shifts.dart';
import 'profile.dart';
import 'login.dart';
import 'signup.dart';
import 'social.dart';
import 'chat.dart';
import 'notifications.dart';
import 'stats.dart';
import 'settings.dart';

void main() => { runApp(App()) };

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'AMC'),
      home: Main(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context) => App(),
        '/signup': (BuildContext context) => SignupPage(),
        '/homepage': (BuildContext context) => Header(),
      }
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class Header extends StatelessWidget {
  final _tabPages = <Widget>[
    HomePage(),
    ShiftsPage(),
    SocialPage(),
    ProfilePage(),
  ];
  final _tabs = <Tab>[
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.schedule), text: 'Shifts'),
    Tab(icon: Icon(Icons.mood), text: 'Social'),
    Tab(icon: Icon(Icons.person), text: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                child: Text('Employee'),
              ),
            ],
          ),
          backgroundColor: Colors.black87,
        ),
        endDrawer: SideDrawer(),
        body: TabBarView(
          children: _tabPages,
        ),
        bottomNavigationBar: TabBar(
          tabs: _tabs,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black26,
          indicatorColor: const Color.fromRGBO(206, 38, 64, 1.0),
        ),
      ),
    );
  }
}


class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      color: Colors.black45,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.contacts,
                color: Colors.white,
              ),
              title: Text(
                'My Stats',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatsPage())
                );
              }
            ),
            ListTile(
              leading: Icon(
                Icons.textsms,
                color: Colors.white,
              ),
              title: Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage())
                );
              }
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotifsPage())
                );
              }
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage())
                );
              }
            ),
            ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut()
                    .then((value) {
                      Navigator.of(context).pushReplacementNamed('/landingpage'); })
                    .catchError((e) {
                      print(e);});
                }
            ),
          ],
        ),
      ),
    );
  }
}