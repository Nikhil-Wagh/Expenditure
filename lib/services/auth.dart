import 'package:expenditure/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  /* 
   * Handles all the authentication related functions
   * Including sign in and sign up
   * Returns instance of AuthResult
   */

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User _userFromFirebaseUser(auth.User firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUpEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(user: _userFromFirebaseUser(userCredential.user));
    } on auth.FirebaseAuthException catch (e) {
      print('[ERROR] signUpEmailAndPassword(): error = ' + e.toString());

      return AuthResult(message: e.message);
    } catch (e) {
      // TODO: Notify dev about this exception
      print("[ERROR] error = " + e);

      return AuthResult(message: 'Something went wrong, please try again');
    }
  }
}

class AuthResult {
  /*
   * Helper class to return a user object or exception message
   */
  User user;
  String message;

  AuthResult({this.user, this.message});

  bool hasError() {
    return this.message == null ? false : true;
  }

  String exceptionMessage() {
    if (message != null) return message;
    return null; // Don't like this
  }
}
