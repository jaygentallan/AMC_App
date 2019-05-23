import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/widgets.dart';

import 'package:amc/services/crud.dart';

import 'package:amc/singletons/userdata.dart';

class UserManagement {
  final usersRef = FirebaseDatabase.instance.reference().child('users');


  CrudMethods crud = CrudMethods();
  
  storeNewUser(user, data, context) {
    Firestore.instance.collection('/users')
      .add({
        'firstName': data[0],
        'lastName': data[1],
        'employeeID': data[2],
        'favMovie': '',
        'bio': '',
        'profilePic': 'https://firebasestorage.googleapis.com/v0/b/amc-app-6af78.appspot.com/o/profilepics%2Fdefault_profile_pic.jpg?alt=media&token=1ae15fe5-0b43-439d-b329-952b692b84e9',
        'email': user.email,
        'uid': user.uid,
      })
      .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/homepage');
      })
      .catchError((e) { print(e); });

    /* POSTS COLLECTION CREATION
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('/users/${docs.documents[0].documentID}').collection('post')
            .add({
              'favMovie': null,
            })
            .then((val) {
          print('Added');
        }).catchError((e) {print(e);});
      });
    }); */
  }

  updateProfilePic(picUrl) {
    userData.profilePic = picUrl;
    var userInfo = UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('/users/${docs.documents[0].documentID}')
            .updateData({'profilePic': picUrl})
            .then((val) {
          print('Updated');
        });
      });
    });
  }
      /*
    Firestore.instance
      .collection('users')
      .document()
      .updateData(newPic)
      .catchError((e) {
        print(e);
      });
    */

  updateFavMovie(data) {
    userData.favMovie = data;
    var userInfo = UserUpdateInfo();
    userInfo.displayName = data;

    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('/users/${docs.documents[0].documentID}')
            .updateData({'favMovie': data})
            .then((val) {
          print('Updated');
        });
      });
    });
  }

  updateProfileBio(data) {
    userData.bio = data;
    var userInfo = UserUpdateInfo();
    userInfo.displayName = data;

    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.document('/users/${docs.documents[0].documentID}')
            .updateData({'bio': data})
            .then((val) {
          print('bio');
        });
      });
    });
  }

}