import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amc/social/crew.dart';
import 'package:amc/services/crud.dart';
import 'package:amc/services/usermanagement.dart';
import 'package:amc/singletons/userdata.dart';

import 'package:intl/intl.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {

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

// CREW PAGE
class Crew extends StatefulWidget {
  @override
  _CrewState createState() => _CrewState();
}

class _CrewState extends State<Crew> {

  UserManagement userManagement = UserManagement();
  CrudMethods crud = CrudMethods();

  List<DocumentSnapshot> posts = userData.posts.documents;

  Future<void> _refresh() async
  {
    print('Refreshing');
    _update();
    Crew();
  }

  Future<bool> deleteDialog(BuildContext context, String documentID, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text('Warning!',
                style: TextStyle(
                  color: const Color.fromRGBO(212,175,55, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 50.0,
              child: Text('Are you sure you want to delete?'),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(212,175,55, 1.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: const Color.fromRGBO(212,175,55, 1.0),
                  ),
                ),
                onPressed: () {
                  // Delete crew post
                  crud.deleteCrewPost(documentID);

                  /* // Updates posts
                  FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            // Get posts from firebase and put it on singleton
                            crud.getCrewPosts().then((results) {
                              userData.posts = results;
                            });

                          }
                        }
                        return Container(height: 0.0, width: 0.0);
                      }
                  ); */

                  setState(() {
                    posts.removeAt(index);
                  });
                  _update();
                  _refresh();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  Future<bool> postDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text('Posting...',
                style: TextStyle(
                  color: const Color.fromRGBO(212,175,55, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 50.0,
              child: Text('Are you sure you want to post?'),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(212,175,55, 1.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: const Color.fromRGBO(212,175,55, 1.0),
                  ),
                ),
                onPressed: () {
                  var now = DateTime.now();
                  userData.date = DateFormat.yMMMMd('en_US').format(now);

                  List<String> data = [
                    userData.firstName,
                    userData.lastName,
                    userData.profilePic,
                    userData.post,
                    userData.uid,
                    userData.date,
                  ];

                  userManagement.storeNewPost(data, context);

                  FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            crud.getCrewPost(snapshot.data).then((result) {
                              setState(() {
                                posts.add(result);
                              });
                            });
                          }
                          return Container(height: 0.0, width: 0.0);
                        }
                      }
                  );


                  _update();
                  _refresh();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  /*
  @override
  void initState() {
    crud.getCrewPosts().then((results) {
      setState(() {
        posts = results;
      });
    });
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    //double _height = MediaQuery.of(context).size.height;

    if (userData.posts != null) {
      return RefreshIndicator(
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
        color: Colors.white,
        onRefresh: _refresh,
        child: ListView(
          children: <Widget> [

            _update(),

            SizedBox(height: 10.0),

            // Meet Your Crew Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 100.0),
              height: 40.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(132, 26, 42, 1.0),
                      offset: Offset(0.0, 5.0),
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
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15.0),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 3,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(46, 5, 13, 1.0),
                borderRadius: BorderRadius.all(const Radius.circular(30.0)),
              ),
            ),

            SizedBox(height: 10.0),

            // Current User Post Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(132, 26, 42, 1.0),
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                  color: const Color.fromRGBO(206, 38, 64, 1.0),
                  borderRadius: BorderRadius.all(const Radius.circular(10.0))),
              child: Container(
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0),
                      child: Row(
                        children: <Widget>[

                          CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              userData.profilePic,
                            ),
                          ),

                          SizedBox(width: 10.0),

                          Container(
                            //margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            width: _width * 0.65,
                            padding: const EdgeInsets.all(10.0),
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0))
                            ),
                            child: TextField( // Email text box
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration.collapsed(
                                fillColor: Colors.transparent,
                                hintText: 'What do you want to post?',
                                hintStyle: TextStyle(color: Colors.black54),
                                filled: true,
                              ),
                              cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                              onChanged: (value) {
                                setState(() {
                                  userData.post = value;
                                });
                              },
                            ),
                          ),


                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 10.0, top: 10.0, bottom: 15.0),
                        height: 30.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(132, 26, 42, 1.0),
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          color: const Color.fromRGBO(206, 38, 64, 1.0),
                          borderRadius: BorderRadius.all(
                              const Radius.circular(30.0)),
                        ),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            postDialog(context, userData.postIndex);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 10.0),

            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount:posts.length,
              padding: const EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                userData.postIndex = posts.length;
                return Column(
                  children: <Widget>[

                    SizedBox(height: 15.0),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: FractionalOffset.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: <Widget>[

                          Container(
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(
                                        132, 26, 42, 1.0),
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ],
                                color: const Color.fromRGBO(206, 38, 64, 1.0),
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0))),
                            child: Stack(
                              children: <Widget>[

                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    children: <Widget>[

                                      ListTile(
                                        // USER PROFILE PIC
                                        leading: GestureDetector(
                                          onTap: () {
                                            print('Pressed');
                                          },
                                          child: CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                              posts[posts.length - i - 1]
                                                  .data['profilePic'],
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: <Widget>[

                                            GestureDetector(
                                              onTap: () {
                                                print('Pressed');
                                              },
                                              child: Text(
                                                "${posts[posts.length - i - 1]
                                                    .data['firstName']} ${posts[posts
                                                    .length - i - 1]
                                                    .data['lastName']} ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "posted on ${posts[posts.length - i - 1]
                                              .data['date']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),

                                      // Post content
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0, top: 10.0),
                                        alignment: FractionalOffset.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0))
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${posts[posts.length - i - 1]
                                                .data['post']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 30.0),

                                    ],
                                  ),
                                ),

                                // Checks if user owns post, then shows delete button
                                userData.uid ==
                                    posts[posts.length - i - 1].data['uid']
                                    ? Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDialog(context,  posts[posts.length - i - 1].documentID, posts.length - i - 1);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0, right: 10.0),
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                132, 26, 42, 1.0),
                                            offset: Offset(0.0, 5.0),
                                          ),
                                        ],
                                        color: const Color.fromRGBO(
                                            206, 38, 64, 1.0),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(30.0)),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          IconData(
                                            0xe811,
                                            fontFamily: 'delete',
                                          ),
                                          color: Colors.white,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : Container(height: 0.0, width: 0.0),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 15.0),

                  ],
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }
  }

  Widget _update() {
    return
        FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                // Get posts from firebase and put it on singleton
                crud.getCrewPosts().then((results) {
                  userData.posts = results;
                });
              }
            }
            return Container(height: 0.0, width: 0.0);
          }
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