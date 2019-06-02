import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:amc/services/usermanagement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amc/services/crud.dart';

import 'package:amc/singletons/userdata.dart';

class ProfilePage extends StatelessWidget {
  Future<void> _refresh() async
  {
    print('Refreshing');
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
      child: Stack(
        children: <Widget>[

          // Golden line decoration behind profile picture
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            height: 190.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(top: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(top: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.all(const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(bottom: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(bottom: const Radius.circular(40.0)),
                  ),
                ),

              ],
            ),
          ),

          Align(
            child: Container(
              width: 190.0,
              height: 190.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250,205,85, 1.0),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5.0,
                  color: const Color.fromRGBO(250,205,85, 0.75),
                ),
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
                ),
              ),
            ),
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

  String _userData;

  List<String> favMovieDialog = ['Favorite Movie','Enter your favorite movie', 'favMovie'];
  List<String> bioDialog = ['Biography','Enter your bio', 'bio'];

  QuerySnapshot profileData;
  UserManagement userManagement = UserManagement();
  CrudMethods crud = CrudMethods();

  Future<bool> addDialog(BuildContext context, List<String> data) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Center(
              child: Text(data[0],
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
              child: TextField(
                  decoration: InputDecoration(
                    hintText: data[1],
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(206, 38, 64, 1.0)),
                    ),
                  ),
                  cursorColor: const Color.fromRGBO(206, 38, 64, 1.0),
                  onChanged: (value) {
                    _userData = value;
                  }
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: const Color.fromRGBO(212,175,55, 1.0),
                  ),
                ),
                onPressed: () {

                  data[2] == 'favMovie'
                      ? userManagement.updateFavMovie(_userData)
                      : userManagement.updateProfileBio(_userData);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    //double _height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget> [

        // FULL NAME
        Container(
          width: _width / 1.25,
          height: 85.5,
          alignment: Alignment.center,
          child: Column(
            children: <Widget> [

              SizedBox(height: 10.0),

              Text(
                "${userData.firstName} ${userData.lastName}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [

                  // Golden line decoration
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 50.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250,205,85, 0.75),
                      borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(40.0)),
                    ),
                  ),

                  Text(
                    "AMC Employee",
                    style: TextStyle(
                      color: const Color.fromRGBO(250,205,85, 1.0),
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
                    ),
                  ),

                  // Golden line decoration
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 50.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250,205,85, 0.75),
                      borderRadius: BorderRadius.only(bottomRight: const Radius.circular(40.0)),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),

        SizedBox(height: 20.0),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
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
          child: Column(
            children: <Widget>[

              SizedBox(height: 10.0),

              // FAVORITE MOVIE
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for the Favorite Movie label
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe824,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Favorite Movie",
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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
                              addDialog(context,favMovieDialog);
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
                margin: const EdgeInsets.only(left: 67.0,right: 20.0),
                child: Text(
                  userData.favMovie == '' || userData.favMovie == null
                      ? 'Tell us your favorite movie!'
                      : '${userData.favMovie}',
                  style: TextStyle(
                    color: userData.favMovie == '' || userData.favMovie == null
                        ? Colors.white24
                        : Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              // Used as padding
              SizedBox(height: 20.0),

              // Border to separate section
              Container(
                height: 2.5,
                alignment: FractionalOffset.center,
                color: Color.fromRGBO(193, 34, 59, 1.0),
              ),

              // Used as padding
              SizedBox(height: 10.0),

              // BIOGRAPHY
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for Biography label
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe828,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 25,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          'Biography',
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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
                              addDialog(context, bioDialog);
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
                margin: const EdgeInsets.only(left: 67.0,right: 20.0),
                child: Text(
                  userData.bio == '' || userData.bio == null
                      ? 'Tell us something about yourself!'
                      : '${userData.bio}',
                  style: TextStyle(
                    color: userData.bio == '' || userData.bio == null
                        ? Colors.white24
                        : Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              // Used as padding
              SizedBox(height: 20.0),

              // Border to separate section
              Container(
                height: 2.5,
                alignment: FractionalOffset.center,
                color: Color.fromRGBO(193, 34, 59, 1.0),
              ),

              // Used as padding
              SizedBox(height: 20.0),

              // ACHIEVEMENTS
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for Achievements
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe822,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Achievements",
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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

              // ACHIEVEMENT OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "",
                  style: TextStyle(
                    color:  Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 75.0),


            ],
          ),
        ),
      ],
    );
  }
}