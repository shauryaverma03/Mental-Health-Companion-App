import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genai/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService();

  /// Sign in with Google and return the [UserCredential] on success, otherwise null.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        // User aborted the sign-in
        debugPrint('Google sign-in aborted by user.');
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      if (gAuth.idToken == null && gAuth.accessToken == null) {
        debugPrint('Google auth returned no tokens.');
        return null;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential;
    } catch (e, stack) {
      debugPrint('Error signing in with Google: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// Returns the current Firebase ID token for the signed-in user, or null.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      debugPrint('getIdToken: no user is currently signed in.');
      return null;
    }
    try {
      final String token = await user.getIdToken(forceRefresh);
      return token;
    } catch (e, stack) {
      debugPrint('Error getting ID token: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// Send the Firebase ID token to your backend to authenticate / create a user.
  /// Stores a backend JWT (if returned) into secure storage under the key 'jwt'.
  /// Returns true on success, false otherwise.
  Future<bool> loginWithFirebase({String? firebaseIdToken}) async {
    try {
      final String? token = firebaseIdToken ?? await getIdToken();
      if (token == null) {
        debugPrint('loginWithFirebase: no firebase id token available.');
        return false;
      }

      final response = await http.post(
        Uri.parse('https://gen-ai-g6tt.onrender.com/api/v1/users/firebaseUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        // Try to parse a server-provided JWT from response body.
        try {
          final Map<String, dynamic> body = jsonDecode(response.body);
          // common keys could be 'token', 'jwt', 'accessToken' — check them
          final String? serverJwt = body['token'] as String? ??
              body['jwt'] as String? ??
              body['accessToken'] as String?;

          if (serverJwt != null && serverJwt.isNotEmpty) {
            await storage.write(key: 'jwt', value: serverJwt);
            debugPrint('Backend JWT stored in secure storage.');
          } else {
            // If backend didn't return a JWT, you may want to store the Firebase ID token.
            await storage.write(key: 'jwt', value: token);
            debugPrint(
                'No server JWT found; stored Firebase ID token instead (consider returning a backend token).');
          }
        } catch (e) {
          // If response is not JSON or parsing failed, store firebase token as fallback
          await storage.write(key: 'jwt', value: token);
          debugPrint(
              'Response parsing failed; stored Firebase ID token as fallback.');
        }
        debugPrint('Login successful (status 200).');
        return true;
      } else {
        debugPrint(
            'Login failed. statusCode=${response.statusCode}, body=${response.body}');
        return false;
      }
    } catch (e, stack) {
      debugPrint('Error in loginWithFirebase: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  /// Read stored token (backend JWT or fallback) from secure storage.
  Future<String?> readToken() async {
    try {
      final String? storedToken = await storage.read(key: 'jwt');
      if (storedToken != null && storedToken.isNotEmpty) {
        debugPrint('Stored JWT Token found.');
        return storedToken;
      } else {
        debugPrint('No JWT Token found in secure storage.');
        return null;
      }
    } catch (e, stack) {
      debugPrint('Error reading token from secure storage: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// Sign out from Firebase and Google (if signed in) and clear secure storage.
  /// Then navigate to the LoginPage (replacing the current route).
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      // Try sign out from Google as well; it will be ignored if not signed in.
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('GoogleSignIn signOut error (ignored): $e');
      }
    } catch (e, stack) {
      debugPrint('Error signing out from Firebase: $e');
      debugPrintStack(stackTrace: stack);
    }

    try {
      await storage.delete(key: 'jwt');
      // If you stored other keys, remove them as needed:
      // await storage.deleteAll();
    } catch (e, stack) {
      debugPrint('Error clearing secure storage: $e');
      debugPrintStack(stackTrace: stack);
    }

    // Navigate to login page replacing the current route stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  /// Optional helper: returns the currently signed-in Firebase [User], or null.
  User? currentUser() {
    return _auth.currentUser;
  }

  /// Optional: listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}