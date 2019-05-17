import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:ui';
import 'dart:async';

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

import 'services/crud.dart';

void main() => { runApp(App()) };

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'AMC'),
      home: Main(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => App(),
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

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {

  AnimationController animationControllerScreen;
  Animation animationScreen;

  QuerySnapshot profileData;
  crudMethods crud = crudMethods();

  String _name = '';

  @override
  void initState() {
    super.initState();

    animationControllerScreen = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animationScreen = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(animationControllerScreen);

    animationControllerScreen.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      child: Stack(
        children: <Widget> [

          FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  crud.getProfileData(snapshot.data).then((results) {
                    setState(() {
                      profileData = results;
                      _name = profileData.documents[0].data['firstName'] != null
                          ? profileData.documents[0].data['firstName'].replaceAll("\'", "")
                          : '';
                    });
                  });
                }
                else {
                  return null;
            }
          },
        ),

        Scaffold(
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

            labelColor: Colors.black87.withOpacity(1.0),
            unselectedLabelColor: Colors.black87.withOpacity(0.3),
            indicatorColor: const Color.fromRGBO(206, 38, 64, 1.0),
          ),
        ),

        SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                HomeAnimation(animation: animationScreen, name :_name),
              ],
            )
        ),
      ],
      ),
    );
  }
}


class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      color: const Color.fromRGBO(206, 38, 64, 1.0).withOpacity(0.8),
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
                      Navigator.of(context).pushReplacementNamed('/login'); })
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

class HomeAnimation extends AnimatedWidget {
  final String name;

  HomeAnimation({Key key, Animation<double> animation, this.name})
      :super(key :key, listenable :animation);

  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    final Animation<double> animation = listenable;
    return animation.value != 0.0
    ? Container(
      width: _width,
      height: _height,
      color:
        animation.value > 0.4
        ? const Color.fromRGBO(206, 38, 64, 1.0)
        : const Color.fromRGBO(206, 38, 64, 1.0).withOpacity(animation.value * 2.5),
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Text("Hello, ${name}!",
            style: TextStyle(fontSize: 25,color:
                animation.value > 0.8
                ? Colors.white.withOpacity(0.0)
                : animation.value > 0.4
                  ? Colors.white
                  : Colors.white.withOpacity(animation.value * 2.5),
            ),
          ),
        ),
      ),
    )
    : Container(width: 0.0, height: 0.0);
  }
}