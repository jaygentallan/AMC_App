import 'package:amc/services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amc/services/crud.dart';
import 'package:amc/singletons/userdata.dart';
import 'package:amc/profile/viewprofile.dart';
import 'package:intl/intl.dart';

// CREW SUB PAGE
class Crew extends StatefulWidget {
  @override
  _CrewState createState() => _CrewState();
}

class _CrewState extends State<Crew> {
  UserManagement userManagement = UserManagement();
  CrudMethods crud = CrudMethods();

  final TextEditingController eCtrl = TextEditingController();
  Stream posts;

  Future<void> _refresh() async
  {
    print('Refreshing');
    _update();
    Crew();
  }

  // Delete dialog for  deleting a post
  Future<bool> deleteDialog(BuildContext context, String documentID) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text('Deleting',
                style: TextStyle(
                  color: const Color.fromRGBO(212, 175, 55, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 20.0,
              child: Text('Are you sure you want to delete?'),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(212, 175, 55, 1.0),
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
                    color: const Color.fromRGBO(212, 175, 55, 1.0),
                  ),
                ),
                onPressed: () {

                  // Delete crew post in firebase database
                  crud.deleteCrewPost(documentID);
                  _refresh();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  // Dialog for posting a status
  Future<bool> postDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text('Posting',
                style: TextStyle(
                  color: const Color.fromRGBO(212, 175, 55, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 20.0,
              child: Text('Are you sure you want to post?'),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(212, 175, 55, 1.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              // When users click Confirm, the firestore database is then updated with the user post
              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: const Color.fromRGBO(212, 175, 55, 1.0),
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

                  eCtrl.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  // Initializes the posts Stream
  @override
  void initState() {
    super.initState();
    crud.getCrewPosts().then((results) {
      setState(() {
        posts = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    if (posts != null) {
      return RefreshIndicator(
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
        color: Colors.white,
        onRefresh: _refresh,
        child: ListView(
          children: <Widget>[

            // Makes sure singleton is up-to-date
            _update(),

            // Used as padding
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

            SizedBox(height: 25.0),

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
                              controller: eCtrl,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration.collapsed(
                                fillColor: Colors.transparent,
                                hintText: 'What do you want to post?',
                                hintStyle: TextStyle(color: Colors.black54),
                                filled: true,
                              ),
                              cursorColor: const Color.fromRGBO(
                                  206, 38, 64, 1.0),
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
                              const Radius.circular(10.0)),
                        ),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            postDialog(context);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 10.0),

            _postList(),
          ],
        ),
      );
    } else { return Container(height: 0.0,width: 0.0); }
  }

  Widget _update() {
    return FutureBuilder(
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

  Widget _postList() {
    double _width = MediaQuery.of(context).size.width;
    if (posts != null) {
      return StreamBuilder(
        stream: posts,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            // Loads each post from the firebase database
            return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
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
                                color: const Color.fromRGBO(
                                    206, 38, 64, 1.0),
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  )),
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
                                            backgroundColor: Colors
                                                .transparent,
                                            backgroundImage: NetworkImage(
                                              snapshot.data.documents[snapshot
                                                  .data.documents.length - i - 1]
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
                                                "${snapshot.data
                                                    .documents[snapshot.data
                                                    .documents.length - i -
                                                    1]
                                                    .data['firstName']} ${snapshot
                                                    .data.documents[snapshot
                                                    .data.documents
                                                    .length - i - 1]
                                                    .data['lastName']} ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "posted on ${snapshot.data
                                              .documents[snapshot.data.documents
                                              .length -
                                              i -
                                              1]
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
                                            left: 15.0,
                                            right: 15.0,
                                            top: 10.0),
                                        alignment: FractionalOffset.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0))
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data.documents[snapshot
                                                .data.documents.length - i - 1]
                                                .data['post']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 5.0),

                                      // Row for like buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget> [

                                          // Button for Popcorn button
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              height: 40.0,
                                              width: 40.0,
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
                                                    const Radius.circular(10.0)),
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.all(9),
                                                child: Image.asset(
                                                  'assets/icons/popcorn.png',
                                                  color: Colors.white,
                                                )
                                              )
                                            ),
                                          ),

                                          // Button for Heart button
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                margin: const EdgeInsets.only(left: 50.0),
                                                height: 40.0,
                                                width: 40.0,
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
                                                      const Radius.circular(10.0)),
                                                ),
                                                child: Container(
                                                    margin: const EdgeInsets.all(9),
                                                    child: Image.asset(
                                                      'assets/icons/heart.png',
                                                      color: Colors.white,
                                                    )
                                                )
                                            ),
                                          ),

                                          // Button for Laughing button
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 50.0),
                                              height: 40.0,
                                              width: 40.0,
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
                                                    const Radius.circular(10.0)),
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.all(9),
                                                child: Image.asset(
                                                  'assets/icons/laugh.png',
                                                  color: Colors.white,
                                                )
                                              )
                                            ),
                                          ),

                                          // Button for Crying button
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 50.0),
                                              height: 40.0,
                                              width: 40.0,
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
                                                    const Radius.circular(10.0)),
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.all(9),
                                                child: Image.asset(
                                                  'assets/icons/crying.png',
                                                  color: Colors.white,
                                                )
                                              )
                                            ),
                                          ),

                                        ],
                                      ),

                                      // Used for padding
                                      SizedBox(height: 15.0),

                                    ],
                                  ),
                                ),

                                // Checks if current user owns post, then shows delete button
                                userData.uid ==
                                    snapshot.data.documents[snapshot.data
                                        .documents.length - i - 1].data['uid']
                                    ? Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDialog(context,
                                          snapshot.data.documents[snapshot.data
                                              .documents.length - i - 1]
                                              .documentID);
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
                                            const Radius.circular(10.0)),
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

                          // Comment Section
                          Container(
                            margin: const EdgeInsets.only(left: 50.0,),
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
                                borderRadius: BorderRadius.vertical(
                                    bottom: const Radius.circular(10.0),
                                )),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
                              child: ListView(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget> [

                                  Row(
                                    children: <Widget>[

                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        userData.profilePic,
                                      ),
                                    ),

                                    // Used as padding
                                    SizedBox(width: 10.0),

                                    // Current user comment box
                                    Container(
                                      width: _width * 0.596,
                                      height: 36.0,
                                      padding: const EdgeInsets.all(10.0),
                                      alignment: FractionalOffset.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(10.0))
                                      ),
                                      child: TextField( // Email text box
                                        keyboardType: TextInputType.text,
                                        maxLines: null,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration.collapsed(
                                          fillColor: Colors.transparent,
                                          hintText: 'Write a comment',
                                          hintStyle: TextStyle(color: Colors.black54),
                                          filled: true,
                                        ),
                                        cursorColor: const Color.fromRGBO(
                                            206, 38, 64, 1.0),
                                        onSubmitted: (value) {
                                          print('Commented!');
                                        },
                                      ),
                                    ),

                                  ],
                                ),

                                  // Used as padding
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ),

                          // Used as padding
                          SizedBox(height: 15.0),

                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else { return Container(height: 0.0,width: 0.0); }
        },
      );
    }
    else { return Container(height: 0.0,width: 0.0); }
  }
}


class CrewList extends StatefulWidget {
  @override
  _CrewListState createState() => _CrewListState();
}

class _CrewListState extends State<CrewList> {
  String picture;
  String firstName;
  String lastName;

  QuerySnapshot users;
  CrudMethods crud = CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget> [


          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
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
                      child: Text(
                        'Meet Your Crew',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: _crewList(),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Icon(
                Icons.arrow_back,
              ),
              backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
            ),
          ),
        ]
    );
  }

  Widget _crewList() {

    Future<void> _refresh() async
    {
      print('Refreshing');
      _crewList();
    }

    if (userData.users != null) {
      return RefreshIndicator(
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
        color: Colors.white,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: userData.users.documents.length,
          padding: const EdgeInsets.all(5.0),
          itemBuilder: (context, i) {
            return Column(
              children: <Widget> [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
                  height: 55.0,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    //borderRadius: BorderRadius.all(const Radius.circular(32.0))
                  ),
                  child: FlatButton(
                      onPressed: () {
                        userData.viewUser = userData.users.documents[i];
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewProfilePage()));
                      },
                      child: ListTile(
                        // USER PROFILE PIC
                        leading: CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            userData.users.documents[i].data['profilePic'],
                          ),
                        ),
                        // USER FULL NAME
                        title: Text(
                          "${userData.users.documents[i].data['firstName']} ${userData.users.documents[i].data['lastName']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // ARROW BUTTON
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      )
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(46, 5, 13, 1.0),
                    borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                  ),
                ),

              ],
            );
          },
        ),
      );
    } else { return Container(height: 0.0,width: 0.0); }
  }
}