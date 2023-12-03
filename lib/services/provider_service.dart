import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_service.dart';

class UserProvider extends ChangeNotifier {
  final SignInService _signInService = SignInService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    final userCredential =
        await _signInService.signInWithEmailPassword(email, password);
    setUser(userCredential?.user);
  }

  Future<void> signOut() async {
    await _signInService.signOut();
    setUser(null);
  }

  Future<bool> checkUserLoggedIn() async {
    _user = _auth.currentUser;
    if (_user != null) {
      // User is already logged in
      return true;
    } else {
      // User is not logged in
      return false;
    }
  }
}
