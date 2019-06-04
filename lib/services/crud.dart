import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {

  bool isLoggedIn() {
    if(FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else { return false; }
  }

  // USERS

  // Main dart script uses this function in the beginning to get
  // all the users from the database to put into the singleton.
  // This avoids long loading times from querying the database.
  getUsers() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  // This function takes in a user parameter and
  // returns the desired user's profile data.
  getProfileData(user) async {
    return await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .catchError((e) {
          print(e); });;
  }

  // This function takes in the UID of a user
  // as the parameter and returns the post's
  // user profile data.
  getProfileDataFromPost(uid) async {
    return await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .catchError((e) {
          print(e); });;
  }

  // This function accepts the documentID and value
  // as parameters and updates the user's data.
  updateData(selectedDoc, value) {
    Firestore.instance
        .collection('users')
        .document(selectedDoc)
        .updateData(value)
        .catchError((e) {
          print(e); });
  }


  // CREW POSTS

  // This function returns all the crew posts
  // for display in a StreamBuilder
  Future getCrewPosts() async {
    return await Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .snapshots();
  }

  Future getCrewPostCommments(docID) async {
    return await Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .document(docID)
        .collection('comments')
        .snapshots();
  }

  // This function adds a post to the database
  addCrewPost(data, context) {
    Firestore.instance.collection('posts').document('crew').collection('posts')
        .add({
      'firstName': data[0],
      'lastName': data[1],
      'profilePic': data[2],
      'post': data[3],
      'uid': data[4],
      'date': data[5],
    })
        .then((value) {
    })
        .catchError((e) { print(e); });
  }

  // This function deletes a post from the database
  deleteCrewPost(docID) {
    Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .document(docID)
        .delete()
        .catchError((e) {
          print(e);
        });
  }

  // This function adds a post to the database
  Future<void> addCrewPostComment(docID, data) async {
    Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .document(docID)
        .collection('comments')
        .add({
          'firstName': data[0],
          'lastName': data[1],
          'profilePic': data[2],
          'comment': data[3],
          'uid': data[4],
          'date': data[5],
        })
        .then((value) {})
        .catchError((e) {
          print(e); });
  }

  deleteCrewComment(postDocID, commentDocID) {
    Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .document(postDocID)
        .collection('comments')
        .document(commentDocID)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}