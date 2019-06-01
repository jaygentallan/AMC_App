import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {

  bool isLoggedIn() {
    if(FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else { return false; }
  }

  getUsers() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future getCrewPosts() async {
    return await Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .snapshots();
  }

  Future getCrewPost(user) async {
    return await Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .where('post', isEqualTo: user.post);
  }

  getProfileData(user) async {
    return await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
  }

  updateData(selectedDoc, value) {
    Firestore.instance
        .collection('users')
        .document(selectedDoc)
        .updateData(value)
        .catchError((e) {
          print(e); });
  }

  Future<void> addPost(value) async {
    Firestore.instance
        .collection('posts')
        .document('crew')
        .collection('posts')
        .add(value)
        .catchError((e) {
      print(e); });
  }
  
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
}