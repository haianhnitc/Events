import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseTokenService {
  final FirebaseAuth _firebaseAuth;

  FirebaseTokenService(this._firebaseAuth);

  Future<String?> getAccessToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      return await user.getIdToken(true);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }
}
