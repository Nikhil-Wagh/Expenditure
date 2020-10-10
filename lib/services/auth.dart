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

  Future signInEmailAndPassword(String email, password) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResult(user: _userFromFirebaseUser(userCredential.user));
    } on auth.FirebaseAuthException catch (e) {
      print('[ERROR] signInEmailAndPassword(): error = ' + e.toString());

      return AuthResult(message: e.message);
    } catch (e) {
      // TODO: Notify dev about this exception
      print("[ERROR] error = " + e);

      return AuthResult(message: 'Something went wrong, please try again');
    }
  }

  Future signInWithGoogle() async {}

  Future signInWithFacebook() async {}

  Future signInWithTwitter() async {}

  Future signInWithApple() async {}

  signOut() {
    _firebaseAuth.signOut();
  }

  validateEmail(String email) {
    if (email.isEmpty)
      return 'Enter an email';
    else if (!email.contains('@') || email.split('@').length < 2 || (!email.split('@')[1].contains('.com')))
      return 'Not a valid email address';
    else
      return null;
  }

  validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be atleast of 6 characters';
    } else
      return null;
  }

  validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Password don\'t match';
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

  bool hasErrors() {
    return this.message == null ? false : true;
  }

  String errorMessage() {
    if (message != null) return message;
    return null; // Don't like this
  }
}
