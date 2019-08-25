import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:ui';

import 'package:amc/home/home.dart';
import 'package:amc/shifts/shifts.dart';
import 'package:amc/profile/profile.dart';
import 'package:amc/login/login.dart';
import 'package:amc/login/signup.dart';
import 'package:amc/social/social.dart';
import 'package:amc/drawer/chat.dart';
import 'package:amc/drawer/notifications.dart';
import 'package:amc/drawer/stats.dart';
import 'package:amc/drawer/settings.dart';
import 'package:intl/intl.dart';

import 'services/crud.dart';

import 'singletons/userdata.dart';

void main() => { runApp(App()) };

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
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
  CrudMethods crud = CrudMethods();

  bool init = true;
  int _currentIndex = 0;
  var time;

  @override
  void initState() {
    super.initState();

    init = true;

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final _children = <Widget>[
    HomePage(),
    ShiftsPage(),
    SocialPage(),
    ProfilePage(),
  ];

  final _pages = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe800,fontFamily: 'line_icons')),
        title: Text(
          'HOME',
          style: TextStyle(fontWeight: FontWeight.w400),)),
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe836,fontFamily: 'line_icons')),
        title: Text(
            'SHIFTS',
            style: TextStyle(fontWeight: FontWeight.w400))),
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe82b,fontFamily: 'line_icons')),
        title: Text(
            'SOCIAL',
            style: TextStyle(fontWeight: FontWeight.w400))),
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe82a,fontFamily: 'line_icons')),
        title: Text(
            'PROFILE',
            style: TextStyle(fontWeight: FontWeight.w400))),
  ];

  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> _loginFormKey =
    //new GlobalKey<FormState>(debugLabel: '_loginFormKey');
    return Stack(
      children: <Widget>[

        // Gets the user data and puts it into a singleton
        init == true
            ? FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                crud.getProfileData(snapshot.data).then((results) {
                  setState(() {
                    profileData = results;

                    // Store firebase data to singleton firstName
                    userData.firstName =
                    profileData.documents[0].data['firstName'] != null
                        ? profileData.documents[0].data['firstName']
                        .replaceAll("\'", "")
                        : '';

                    // Store firebase data to singleton lastName
                    userData.lastName =
                    profileData.documents[0].data['lastName'] != null
                        ? profileData.documents[0].data['lastName']
                        .replaceAll("\'", "")
                        : '';

                    // Store firebase data to singleton UID
                    userData.uid =
                    profileData.documents[0].data['uid'] != null
                        ? profileData.documents[0].data['uid']
                        .replaceAll("\'", "")
                        : '';

                    // Store firebase data to singleton profileID
                    userData.profilePic =
                    profileData.documents[0].data['profilePic'] != null
                        ? profileData.documents[0].data['profilePic']
                        .replaceAll("\'", "")
                        : '';

                    // Store firebase data to singleton favMovie
                    userData.favMovie =
                    profileData.documents[0].data['favMovie'] != null
                        ? profileData.documents[0].data['favMovie']
                        .replaceAll("\'", "")
                        : '';

                    // Store firebase data to singleton favMovie
                    userData.bio =
                    profileData.documents[0].data['bio'] != null
                        ? profileData.documents[0].data['bio']
                        .replaceAll("\'", "")
                        : '';

                    // Turns off initialization
                    init = false;

                  });
                  // Get document reference and put to singleton
                  crud.getUsers().then((results) {
                    userData.users = results;
                  });

                  // Get posts reference and put to singleton
                  crud.getCrewPosts().then((results) {
                    userData.posts = results;
                  });

                });

              }
            }
            return Container(height: 0.0, width: 0.0);
          },
        )
            : Container(width: 0.0, height: 0.0),

        // UI Scaffold
        Scaffold(
          //key: _loginFormKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              automaticallyImplyLeading: false,
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
                      child:
                      // Changes header depending on page
                      _currentIndex == 0
                          ? Text(
                          'Home',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            ),
                          )
                          : _currentIndex == 1
                          ? Text(
                          'Shifts',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          )
                          : _currentIndex == 2
                          ? Text(
                          'Social',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          )
                          : _currentIndex == 3
                          ? Text(
                          'Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          )
                          : Container(width: 0.0,height: 0.0)
                  ),
                ],
              ),
              backgroundColor: Colors.black,
            ),
          ),
          endDrawer: SideDrawer(),
          body: _children[_currentIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.black,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: const Color.fromRGBO(206, 38, 64, 1.0),
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(
                    caption: TextStyle(color: Colors.white,))),
            // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              elevation: 0,
              selectedFontSize: 10,
              unselectedFontSize: 9,
              selectedItemColor: const Color.fromRGBO(250,205,85, 0.75),
              unselectedItemColor: Colors.white,
              iconSize: 22.5,
              onTap: onTabTapped,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: _pages,
            ),
          ),
        ),

        SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                HomeAnimation(animation: animationScreen, name: userData.firstName),
              ],
            )
        ),

      ],
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
                  IconData(0xe843,fontFamily: 'line_icons'),
                  color: Colors.white,
                ),
                title: Text(
                  'Stats',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatsPage())
                  );
                }
            ),
            ListTile(
                leading: Icon(
                  IconData(0xe83f,fontFamily: 'line_icons'),
                  color: Colors.white,
                ),
                title: Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage())
                  );
                }
            ),
            ListTile(
                leading: Icon(
                  IconData(0xe858,fontFamily: 'line_icons'),
                  color: Colors.white,
                ),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotifsPage())
                  );
                }
            ),
            ListTile(
                leading: Icon(
                  IconData(0xe810,fontFamily: 'line_icons'),
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage())
                  );
                }
            ),
            ListTile(
                leading: Icon(
                  IconData(0xe820,fontFamily: 'line_icons'),
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
  var time;

  HomeAnimation({Key key, Animation<double> animation, this.name})
      :super(key :key, listenable :animation);

  Widget build(BuildContext context) {

    time = DateTime.now();
    time = int.parse(DateFormat.H().format(time));

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    final Animation<double> animation = listenable;
    return animation.value != 0.0
        ? Opacity(
      opacity: animation.value > 0.4
          ? 1.0
          : animation.value * 2.5,
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            // Checks current time and displays appropriate
            // greeting message to the user.
            child: Text(time > 6 && time <= 11
                ? "Good morning, ${name}!"
                : time > 11 && time <= 19
                  ? "Good afternoon, ${name}!"
                  : time > 19 || time <= 6
                    ? "Good evening, ${name}!"
                    : "",
              style: TextStyle(
                fontSize: 23,
                color: animation.value > 0.8
                    ? Colors.white.withOpacity(0.0)
                    : animation.value > 0.4
                      ? Colors.white
                      : Colors.white.withOpacity(animation.value * 2.5),
              ),
            ),
          ),
        ),
      ),
    )
        : Container(width: 0.0, height: 0.0);
  }
}