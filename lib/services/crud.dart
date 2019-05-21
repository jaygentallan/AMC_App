import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {

  bool isLoggedIn() {
    if(FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else { return false; }
  }

  Future<void> addData(data,name) async {
    Firestore.instance.collection(name).add(data).catchError((e) { print(e); }
    );
  }

  Future<void> addProfileData(data,path,uid) async {
    Firestore.instance.collection(path).document('${uid}').updateData(data).catchError((e) { print(e); }
    );
  }

  getProfileData(user) async {
    return await Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).getDocuments();
  }


}