

class UserData {
  static final UserData _userData = UserData._internal();

  String firstName = '';
  String lastName = '';

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();