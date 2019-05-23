
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

  QuerySnapshot users;
  DocumentSnapshot viewUser;

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();