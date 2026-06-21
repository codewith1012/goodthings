import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<bool> isNewUser() async {
    try {
      // Authentication
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Authorization
      final clientAuth = await GoogleSignIn.instance.authorizationClient
          .authorizationForScopes(['openid', 'profile', 'email']);

      // Prepare the Crendentials
      final String? accessToken = clientAuth?.accessToken;
      final String? idToken = googleUser.authentication.idToken;

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Pass the Credentials to the FireBaseAuth
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.additionalUserInfo?.isNewUser ?? true;
    } catch (e) {
      debugPrint("The exception occurs $e");
      return true;
    }
  }

  Future<void> signInWithGoogle({String? userName}) async {
    try {
      // Authentication
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Authorization
      final clientAuth = await GoogleSignIn.instance.authorizationClient
          .authorizationForScopes(['openid', 'profile', 'email']);

      // Prepare the Crendentials
      final String? accessToken = clientAuth?.accessToken;
      final String? idToken = googleUser.authentication.idToken;

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Pass the Credentials to the FireBaseAuth
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null && userName != null) {
        await user.updateDisplayName(userName);
        await user.reload();
      }
    } catch (e) {
      debugPrint("The exception occurs $e");
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Expection occurend while sign-out: $e");
    }
  }

  /// USE THIS WITH CAUTION
  Future<void> deleteCurrentUser() async {
    try {
      FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      debugPrint("Exception Occurrred while delteing the user: $e");
    }
  }
}
