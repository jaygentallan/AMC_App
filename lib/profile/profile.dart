import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:amc/services/usermanagement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amc/services/crud.dart';
import 'package:amc/services/usermanagement.dart';

import 'package:amc/singletons/userdata.dart';

class ProfilePage extends StatelessWidget {
  Future<void> _refresh() async
  {
    print('refreshing');
    ProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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

          RefreshIndicator(
            backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
            color: Colors.white,
            onRefresh: _refresh,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 25.0),

                ProfilePic(),

                SizedBox(height: 5.0),

                UserInfo(),

                SizedBox(height: 20.0),

              ],
            ),
          ),
        ],
    );
  }
}

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File profilePic;
  File newProfilePic;

  QuerySnapshot profileData;
  UserManagement userManagement = UserManagement();
  CrudMethods crud = CrudMethods();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
    });
    uploadImage();
  }
  /*
  Future<DocumentReference> getUserDoc() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _firestore.collection('users').document(userData.uid);
    return ref;
  } */

  uploadImage() async {

    final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('profilepics/${userData.uid}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);

    var downurl = await (await task.onComplete).ref.getDownloadURL();
    String url = downurl.toString();

    userManagement.updateProfilePic(url);

    //Firestore.instance.collection('users').document(docRef.documentID).updateData({'profilePic': url});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(
            width: 190.0,
            height: 190.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: NetworkImage(
                  userData.profilePic,
                ),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: getImage,
              )
            )
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool init = true;

  String favMovie;
  String bio;

  QuerySnapshot profileData;
  CrudMethods crud = CrudMethods();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
    {
      return AlertDialog(
        title: Text('Favorite Movie', style: TextStyle(fontSize: 15)),
        content: Center(
          child: Container(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter your favorite movie'),
              onChanged: (value) {
                this.favMovie = value;
              }
              ),
            ),
            ),
          );
        }
      );
    }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget> [

        // FULL NAME
        Container(
          width: _width / 1.25,
          height: 60.0,
          alignment: Alignment.center,
          child: Column(
            children: <Widget> [
              Text(
                "${userData.firstName} ${userData.lastName}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              Text(
                "AMC Employee",
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 15.0,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 350.0,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[

              SizedBox(height: 30.0),

              // FAVORITE MOVIE
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  Container(
                    child: Row(
                      children: <Widget> [

                      Icon(
                        IconData(0xe824,fontFamily: 'line_icons'),
                        color: const Color.fromRGBO(212,175,55, 1.0),
                        size: 28,
                      ),

                      SizedBox(width: 10.0),

                      Text(
                        "Favorite Movie",
                        style: TextStyle(
                          color: const Color.fromRGBO(212,175,55, 1.0),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),

                      // EDIT BUTTON
                      ButtonTheme(
                        minWidth: 10,
                        height: 20,
                        splashColor: Colors.transparent,
                        child: FlatButton(
                          onPressed: () {
                            addDialog(context);
                          },
                          child: Icon(
                              IconData(0xe802,fontFamily: 'line_icons'),
                              color: Colors.white24,
                              size: 20,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              // FAVORITE MOVIE OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  userData.favMovie == ''
                  ? 'Add your favorite movie!'
                  : '${userData.favMovie}',
                  style: TextStyle(
                    color: userData.favMovie == null
                      ? Colors.white
                      : Colors.white24,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 30.0),

              // BIOGRAPHY
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe828,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(212,175,55, 1.0),
                          size: 25,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          userData.favMovie == ''
                              ? 'Add your favorite movie!'
                              : '${userData.favMovie}',
                          style: TextStyle(
                            color: userData.favMovie == null
                                ? Colors.white
                                : Colors.white24,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),

                        // EDIT BUTTON
                        ButtonTheme(
                          minWidth: 10,
                          height: 20,
                          splashColor: Colors.transparent,
                          child: FlatButton(
                            onPressed: () {
                              print('Button Pressed');
                            },
                            child: Icon(
                              IconData(0xe802,fontFamily: 'line_icons'),
                              color: Colors.white24,
                              size: 20,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.0),
              // BIOGRAPHY OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "The FitnessGram Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly but gets faster each minute after you hear this signal bodeboop. A sing lap should be completed every time you hear this sound. ding Remember to run in a straight line and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark. Get ready!… Start. ding﻿",
                  style: TextStyle(
                    color:  Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 30.0),
              // TROPHIES
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe822,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(212,175,55, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Achievements",
                          style: TextStyle(
                            color: const Color.fromRGBO(212,175,55, 1.0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.0),

              // FAVORITE MOVIE OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "• Bathroom Legend - clean the women's restroom 1000 times",
                  style: TextStyle(
                    color:  Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),


            ],
          ),
        ),
      ],
    );
  }
}