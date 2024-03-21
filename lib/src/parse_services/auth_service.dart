// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:openim_common/src/models/user_data.dart';
// import 'package:provider/provider.dart';
// import 'package:openim_common/src/models/user_model.dart';

class AuthService {
  // static final _auth = FirebaseAuth.instance;
  // static final _firestore = FirebaseStorage.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      // UserCredential authResult = await _auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // User signedInUser = user1; //authResult.user;

      // if (signedInUser != null) {
      //   // _firestore.collection('/users').document(signedInUser.uid).setData({
      //   //   'name': name,
      //   //   'email': email,
      //   //   'profileImageUrl': '',
      //   // });   //jincm
      //   Provider.of<UserData>(context).currentUserId =
      //       "jincm2"; //signedInUser.uid;
      //   Navigator.pop(context);
      //   //Navigator.
      // }
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    //_auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      //await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
