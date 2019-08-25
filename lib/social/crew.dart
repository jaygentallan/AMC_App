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

  // Changes the post category depending on number
  int currPostCategory = 0;

  Future<void> _refresh() async
  {
    print('Refreshing');
    _update();
    Crew();
  }

  // Delete dialog for  deleting a post
  Future<bool> deletePostDialog(BuildContext context, String documentID) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text(
                'Deleting Post',
                style: TextStyle(
                  color: const Color.fromRGBO(250,205,85, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 20.0,
              child: Text(
                'Are you sure you want to delete?',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(250,205,85, 1.0),
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
                    color: const Color.fromRGBO(250,205,85, 1.0),
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
                  color: const Color.fromRGBO(250,205,85, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 20.0,
              child: Text(
                'Are you sure you want to post?',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(250,205,85, 1.0),
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
                    color: const Color.fromRGBO(250,205,85, 1.0),
                  ),
                ),
                onPressed: () {

                  // Gets the current date and time to put on the post
                  var now = DateTime.now();
                  userData.date = DateFormat.yMMMMd('en_US').format(now);
                  userData.date = "${userData.date}" " ${DateFormat.jm().format(now)}";

                  List<String> data = [
                    userData.firstName,
                    userData.lastName,
                    userData.profilePic,
                    userData.post,
                    userData.uid,
                    userData.date,
                  ];

                  crud.addCrewPost(data, context);

                  eCtrl.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  // Delete dialog for  deleting a post
  Future<bool> deleteCommentDialog(BuildContext context, String postDocID, String commentDocID) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text('Deleting Comment',
                style: TextStyle(
                  color: const Color.fromRGBO(250,205,85, 1.0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Container(
              height: 20.0,
              child: Text(
                  'Are you sure you want to delete?',
                  style: TextStyle(
                      color: Colors.black54,
                  )
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(250,205,85, 1.0),
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
                    color: const Color.fromRGBO(250,205,85, 1.0),
                  ),
                ),
                onPressed: () {

                  // Delete crew comment in firebase database
                  crud.deleteCrewComment(postDocID, commentDocID);
                  _refresh();
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

    setState(() {
      currPostCategory = 0;
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
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 35.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(206, 38, 64, 1.0),
                border: Border.all(
                  color: const Color.fromRGBO(132, 26, 42, 1.0),
                  width: 1.0,
                ),
              ),
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
                      letterSpacing: 0.75,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.0),

            // Current User Post Container
            Container(
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(206, 38, 64, 1.0),
                border: Border(
                  top: BorderSide(
                    color: const Color.fromRGBO(132, 26, 42, 1.0),
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: const Color.fromRGBO(132, 26, 42, 1.0),
                    width: 1.0,
                  ),
                ),
              ),
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

            // Post Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [

                // if clicked, sorts post to most recent
                SizedBox(
                  height: 35.0,
                  child: FlatButton(
                    child: Text(
                      'RECENT',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: currPostCategory == 0
                            ? const Color.fromRGBO(250,205,85, 0.75)
                            : Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currPostCategory = 0;
                      });
                    },
                  ),
                ),

                // if clicked, sorts post to oldest
                SizedBox(
                  height: 35.0,
                  child: FlatButton(
                    child: Text(
                      'OLDEST',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: currPostCategory == 1
                            ? const Color.fromRGBO(250,205,85, 0.75)
                            : Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currPostCategory = 1;
                      });
                    },
                  ),
                ),

              ],
            ),

            currPostCategory == 0
                ? _postList(currPostCategory)
                : _postList(currPostCategory)
          ],
        ),
      );
    } else { return Container(height: 0.0,width: 0.0); }
  }

  // This widget is used to update the singleton data
  // that contains all the user information. Called
  // every time the page is called or when a change
  // is made to a user info.
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

  // This entire widget uses a ListView.builder within
  // a Streambuilder to load the posts from the firestore
  // databases into the app
  Widget _postList(int category) {
    double _width = MediaQuery.of(context).size.width;
    int index;

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
              itemBuilder: (context, i) {

                final TextEditingController commentController = TextEditingController();

                if (category == 0) {
                  index = snapshot.data.documents.length - i - 1;
                }
                else if (category == 1) {
                  index = i;
                }

                int postIndex = index;

                return Column(
                  children: <Widget>[

                    i != 0
                      // separator for each post box
                        ? SizedBox(height: 9.0)
                        : Container(height: 0.0, width: 0.0),

                    Container(
                      alignment: FractionalOffset.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: <Widget>[

                          Container(
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(206, 38, 64, 1.0),
                              border: Border(
                                top: BorderSide(
                                  color: const Color.fromRGBO(132, 26, 42, 1.0),
                                  width: 1.0,
                                ),
                              ),
                              ),
                            child: Stack(
                              children: <Widget>[

                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    children: <Widget>[

                                      ListTile(

                                        // USER PROFILE PIC
                                        // When clicked, puts user information in userData
                                        // singleton for ViewProfilePage to use.
                                        leading: GestureDetector(
                                          onTap: () {

                                            // Gets profile data from firestore database by using
                                            // the UID of the user that is clicked on. This uses
                                            // the postIndex that each ListTile has. Then the
                                            // data is passed into the userData.viewUser singleton
                                            // for use in ViewProfilePage.
                                            crud.getProfileDataFromPost(snapshot.data.documents[postIndex].data['uid']).then((results) {
                                              userData.viewUser = results.documents[0];

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ViewProfilePage()));
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Colors
                                                .transparent,
                                            backgroundImage: NetworkImage(
                                              snapshot.data.documents[index].data['profilePic'],
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: <Widget>[

                                            // Shows the full name of the user
                                            // When clicked, sends the user information
                                            // to the userData singleton for ViewProfilePage to use.
                                            GestureDetector(
                                              onTap: () {

                                                // Gets profile data from firestore database by using
                                                // the UID of the user that is clicked on. This uses
                                                // the postIndex that each ListTile has. Then the
                                                // data is passed into the userData.viewUser singleton
                                                // for use in ViewProfilePage.
                                                crud.getProfileDataFromPost(snapshot.data.documents[postIndex].data['uid']).then((results) {
                                                  userData.viewUser = results.documents[0];

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ViewProfilePage()));
                                                });
                                              },
                                              child: Text(
                                                "${snapshot.data
                                                    .documents[index]
                                                    .data['firstName']} ${snapshot
                                                    .data.documents[index]
                                                    .data['lastName']} ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data
                                              .documents[index].data['date']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),

                                      // Post content
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        alignment: FractionalOffset.center,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(10.0))
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data.documents[index].data['post']}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),

                                      /*
                                      // Row for like buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget> [

                                          StreamBuilder(
                                              stream: Firestore.instance
                                                  .collection('posts')
                                                  .document('crew')
                                                  .collection('posts')
                                                  .document(snapshot.data.documents[postIndex].documentID)
                                                  .collection('likes')
                                                  .snapshots(),
                                              builder: (context, likeSnapshot) {

                                                if (likeSnapshot.data != null) {
                                                  // Loads each post from the firebase database
                                                  return Container(
                                                    width: 75.0,
                                                    height: 62.5,
                                                    child: ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: likeSnapshot.data.documents.length != 0
                                                            ? likeSnapshot.data.documents.length
                                                            : likeSnapshot.data.documents.length + 1,
                                                        itemBuilder: (context, i) {

                                                          /*
                                                          return LikeButton(
                                                            docID: snapshot.data.documents[postIndex].documentID,
                                                            likeID: likeSnapshot.data.documents.length != 0
                                                                ? likeSnapshot.data.documents[0].documentID
                                                                : '',
                                                          );
                                                          */

                                                        }),
                                                  );
                                                }
                                                else { return Container(height: 0.0, width: 0.0); }
                                              }
                                          ),

                                        ],
                                      ),

                                      */

                                      // Used for padding
                                      SizedBox(height: 10.0),

                                    ],
                                  ),
                                ),

                                // Checks if current user owns post, then shows delete button
                                userData.uid ==
                                    snapshot.data.documents[index].data['uid']
                                    ? Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      deletePostDialog(context,
                                        category == 0
                                            ? snapshot.data.documents[snapshot.data.documents.length - i - 1].documentID
                                            : snapshot.data.documents[i].documentID,
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0, right: 10.0),
                                      height: 30.0,
                                      width: 30.0,
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

                          // Border to separate section
                          Container(
                            height: 2.5,
                            alignment: FractionalOffset.center,
                            color: Color.fromRGBO(193, 34, 59, 1.0),
                          ),

                      // COMMENT SECTION
                          Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(206, 38, 64, 1.0),
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromRGBO(132, 26, 42, 1.0),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Container(
                              width: _width * 0.9,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(206, 38, 64, 1.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 10.0),
                                child: Column(
                                  children: <Widget> [

                                    StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('posts')
                                            .document('crew')
                                            .collection('posts')
                                            .document(snapshot.data.documents[postIndex].documentID)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, commentSnapshot) {

                                          switch (commentSnapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                            default:
                                            // ListView.builder for comments
                                              if (commentSnapshot.hasData && commentSnapshot.data != null) {

                                                return ListView.builder(
                                                    physics: ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: commentSnapshot.data.documents.length,
                                                    itemBuilder: (context, i) {

                                                      int commentIndex = i;

                                                      return Column(
                                                        children: <Widget> [

                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[

                                                                GestureDetector(
                                                                  onTap: () {

                                                                    // Gets profile data from firestore database by using
                                                                    // the UID of the user that is clicked on. This uses
                                                                    // the commentIndex that each ListTile has. Then the
                                                                    // data is passed into the userData.viewUser singleton
                                                                    // for use in ViewProfilePage.
                                                                    crud.getProfileDataFromPost(commentSnapshot.data.documents[commentIndex].data['uid']).then((results) {
                                                                      userData.viewUser = results.documents[0];

                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => ViewProfilePage()));
                                                                    });
                                                                  },
                                                                  child: CircleAvatar(
                                                                    radius: 18,
                                                                    backgroundColor: Colors
                                                                        .transparent,
                                                                    backgroundImage: NetworkImage(
                                                                      commentSnapshot.data.documents[i].data['profilePic'],
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Used as padding
                                                                SizedBox(width: 15.0),

                                                                // Long hold to delete comment if user is owner
                                                                GestureDetector(
                                                                  onLongPress: () {
                                                                    if (userData.uid == commentSnapshot.data.documents[i].data['uid']) {
                                                                      deleteCommentDialog(
                                                                          context,
                                                                          snapshot.data.documents[postIndex].documentID,
                                                                          commentSnapshot.data.documents[i].documentID);
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.only(top: 6.0, left: 10.0, bottom: 10.0),
                                                                    decoration: BoxDecoration(
                                                                      color: const Color.fromRGBO(193, 34, 59, 1.0),
                                                                      borderRadius: BorderRadius.only(
                                                                        bottomLeft: const Radius.circular(10.0),
                                                                        topRight: const Radius.circular(10.0),
                                                                        bottomRight: const Radius.circular(10.0),
                                                                      ),
                                                                    ),
                                                                    child: Column(
                                                                        children: <Widget> [

                                                                          // Post content
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(
                                                                                    const Radius.circular(10.0)
                                                                                )
                                                                            ),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget> [

                                                                                Row(
                                                                                  children: <Widget> [
                                                                                    // Full Name of commenter
                                                                                    Container(
                                                                                      width: _width * 0.6,
                                                                                      child: Text(
                                                                                        "${commentSnapshot.data.documents[i].data['firstName']} "
                                                                                            "${commentSnapshot.data.documents[i].data['lastName']}",
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontSize: 16.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                // Comment content
                                                                                Container(
                                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                                  width: _width * 0.663,
                                                                                  child: Text(
                                                                                    "${commentSnapshot.data.documents[i].data['comment']}",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 16.0,
                                                                                      fontWeight: FontWeight.w300,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),

                                                          SizedBox(height: 10.0),

                                                        ],
                                                      );
                                                    }
                                                );
                                              } else { return Container(height: 0.0, width: 0.0); }
                                          }
                                        }
                                    ),

                                    // Current User Comment Box
                                    Container(
                                      child: Row(
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
                                            width: _width * 0.70,
                                            height: 30.0,
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            alignment: FractionalOffset.center,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(10.0))
                                            ),
                                            child: TextField( // Email text box
                                              controller: commentController,
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

                                                // Gets the current date and time to put on the post
                                                var now = DateTime.now();
                                                userData.date = DateFormat.yMMMMd('en_US').format(now);
                                                userData.date = "${userData.date}" " ${DateFormat.jm().format(now)}";

                                                // Puts all the user comment data to
                                                // pass through the function.
                                                List<String> commentData = [
                                                  userData.firstName,
                                                  userData.lastName,
                                                  userData.profilePic,
                                                  value,
                                                  userData.uid,
                                                  userData.date,
                                                ];

                                                crud.addCrewPostComment(snapshot.data.documents[postIndex].documentID, commentData);

                                                commentController.clear();
                                              },
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                    // Used as padding
                                    SizedBox(height: 10.0),

                                  ],
                                ),
                              ),
                            ),
                          ),

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
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
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

  // Widget for displaying the list of crew members
  // with a ListView.builder using the singleton
  // to avoid loading times

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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(132, 26, 42, 1.0),
                  offset: Offset(0.0, 5.0),
                ),
              ],
              color: const Color.fromRGBO(206, 38, 64, 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(10.0))),
          child: Column(
            children: <Widget> [

              // AMC CREW LOGO
              Container(
                height: 100.0,
                child: Stack(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Container(
                          child: Image.asset( // AMC Logo
                            'assets/amc_logo.png',
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),

                        Container(
                          height: 100.0,
                          child: Align (
                            alignment: Alignment(-0.05,0.0),
                            child: Text(
                              "crew",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontFamily: 'AMC2',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              // Border to separate section
              Container(
                height: 2.5,
                alignment: FractionalOffset.center,
                color: Color.fromRGBO(193, 34, 59, 1.0),
              ),

              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: userData.users.documents.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget> [

                      Container(
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
                              subtitle: Text(
                                'AMC Employee',
                                style: TextStyle(
                                  color: const Color.fromRGBO(250,205,85, 1.0),
                                  fontSize: 13.0,
                                  fontStyle: FontStyle.italic,
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

                      // Used as padding
                      SizedBox(height: 15.0),

                      // Border to separate section
                      Container(
                        height: 2.5,
                        alignment: FractionalOffset.center,
                        color: Color.fromRGBO(193, 34, 59, 1.0),
                      ),

                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else { return Container(height: 0.0,width: 0.0); }
  }
}

class LikeButton extends StatefulWidget {
  final CrudMethods crud = CrudMethods();

  final String docID;
  final String likeID;

  LikeButton({Key key, this.docID, this.likeID}): super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool liked = false;
  int likes;
  int length;

  void initState() {
    widget.crud.checkCrewPostLike(widget.docID, userData.uid).then((results) {
      setState(() {
        length = results.documents.length;

        if (length > 0) {
          liked = true;
        }
        else { liked = false; }

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    widget.crud.getCrewPostLikesCount(widget.docID).then((results) {
      setState(() {
        likes = results.documents.length;
      });
    });

    widget.crud.checkCrewPostLike(widget.docID, userData.uid).then((results) {
      setState(() {
        length = results.documents.length;

        if (length > 0) {
          liked = true;
        }
        else {
          liked = false;
        }
      });
    });

    return liked == true || length != null
        ? Column(
      children: <Widget> [

        GestureDetector(
          onTap: () {
            print('Clicked');
            // Gets the current date and time to put on the post
            var now = DateTime.now();
            userData.date = DateFormat.yMMMMd('en_US').format(now);
            userData.date = "${userData.date}" " ${DateFormat.jm().format(now)}";

            // Puts all the user comment data to
            // pass through the function.
            List<String> likeData = [
              userData.firstName,
              userData.lastName,
              userData.profilePic,
              userData.uid,
              userData.date,
            ];

            if (liked == false) {
              widget.crud.addCrewPostLike(widget.docID, likeData);
              setState(() {
                liked = true;

                widget.crud.checkCrewPostLike(widget.docID, userData.uid).then((
                    results) {
                  setState(() {
                    length = results.documents.length;
                  });
                });

              });
            }

            else {
              widget.crud.deleteCrewLike(widget.docID, widget.likeID);
              setState(() {
                liked = false;

                widget.crud.checkCrewPostLike(widget.docID, userData.uid).then((
                    results) {
                  setState(() {
                    length = results.documents.length - 1;
                  });
                });

              });
            }

          },
          child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: liked == false
                    ? const Color.fromRGBO(206, 38, 64, 1.0)
                    : const Color.fromRGBO(250,205,85, 0.75),
                borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                border: Border.all(
                  width: 2.0,
                  color: Color.fromRGBO(193, 34, 59, 1.0),
                ),
              ),
              child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/icons/popcorn.png',
                    color: Colors.white,
                  )
              )
          ),
        ),

        SizedBox(height: 5.0),

        Container(
          width: 100.0,
          height: 20.0,
          child: Center(
            child: Text(
              '${likes}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    )
        : Container(height: 0.0, width: 0.0);

  }
}