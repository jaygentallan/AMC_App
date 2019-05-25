
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static final UserData _userData = UserData._internal();

  String firstName = '';
  String lastName = '';
  String uid = '';
  String profilePic = '';
  String docID = '';
  String favMovie = '';
  String bio = '';

  String date = '';
  String post = '';

  int postIndex;

  QuerySnapshot users;
  QuerySnapshot posts;
  DocumentSnapshot viewUser;

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();