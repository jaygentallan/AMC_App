

class UserData {
  static final UserData _userData = UserData._internal();

  String firstName = '';
  String lastName = '';
  String uid = '';
  String profilePic = '';
  String docID = '';
  String favMovie = '';
  String bio = '';

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();