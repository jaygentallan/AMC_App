import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, data, context) {
    Firestore.instance.collection('/users')
      .add({
        'firstName': data[0],
        'lastName': data[1],
        'employeeID': data[2],
        'profilePic': null,
        'email': user.email,
        'uid': user.uid,
      })
      .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/homepage');
      })
      .catchError((e) { print(e); });
  }
}