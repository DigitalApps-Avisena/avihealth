// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user.dart' as UserModel;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'database.dart';

class Auth with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Map<String, Object> userData;
  String? userId;
  String? accessToken;
  String? devicetoken;
  Dio dio = Dio();

  bool _isGuest = false;
  bool _isLoggedIn = false;

  bool get isGuest => _isGuest;
  bool get isLoggedIn => _isLoggedIn;

  void loginAsGuest() {
    _isGuest = true;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future deleteUser(String? email, String? password) async {
    try {
      User user = _auth.currentUser!;
      await user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // final facebookLogin = FacebookLogin();
  Map? userProfile;
  var id;
  var name;
  var email;
  var password;

  UserModel.User? _userFromFirebaseUser(User? user) {
    if (user != null) {
      return UserModel.User(uid: user.uid);
    } else {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return e.code.toString();
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Error: $e');
      return e.toString();
    }
  }

  Future changePassword(email, oldpassword, newpassword) async {
    // print("change password == $email $oldpassword $newpassword");
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: oldpassword);
      User? user = result.user;
      print("result.user ${user?.uid}");
      await user?.updatePassword(newpassword).then((_) {
        return "Success";
      });
    } catch (e) {
      print(e.toString());
      return "Error";
    }
  }

  Future resetPass(String email) async {
    try {
      print("result is === ${_auth.sendPasswordResetEmail(email: email)}");
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return "ERROR";
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('patient')
        .where('email', isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
