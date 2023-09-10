import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //  instance of Auth

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance for firestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Sign in User

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in

      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // create a document if document doesnt exits
      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        SetOptions(merge: true),
      );

      return userCredential;
    }
    // catch any erros
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> signUpWIthEmailandPassword(
      String email, password ,String firstName , String mobileNumber ,String about ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // after creating a new user , create a new document for user in the user collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'firstName' : firstName ,
        'mobileNumber':mobileNumber,
        'about':about,
      });
      return userCredential;
    }
    // catch any error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // add user data

  Future<void> addUserData() async {

  }
  // Sign Out user
  Future<void> SignOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
