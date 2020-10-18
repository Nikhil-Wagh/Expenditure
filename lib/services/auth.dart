import 'package:expenditure/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final auth.GoogleAuthCredential googleAuthCredential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);
    return AuthResult(user: _userFromFirebaseUser(userCredential.user));
  }

  Future signInWithFacebook() async {
    print("AuthService.signInWithFacebook()");
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn([
      'email'
    ]);
    auth.FacebookAuthCredential facebookAuthCredential = auth.FacebookAuthProvider.credential(result.accessToken.token);

    auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    return AuthResult(user: _userFromFirebaseUser(userCredential.user));
  }

  Future signInWithTwitter() async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(hours: 1));
    await remoteConfig.activateFetched();

    String twitterConsumerKey = remoteConfig.getValue('twitter_consumer_key').asString();
    String twitterConsumerSecret = remoteConfig.getValue('twitter_consumer_secret').asString();

    final TwitterLogin twitterLogin = TwitterLogin(
      consumerKey: twitterConsumerKey,
      consumerSecret: twitterConsumerSecret,
    );
    final TwitterLoginResult result = await twitterLogin.authorize();
    final TwitterSession twitterSession = result.session;
    final auth.AuthCredential twitterAuthCredential = auth.TwitterAuthProvider.credential(accessToken: twitterSession.token, secret: twitterSession.secret);
    auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(twitterAuthCredential);
    return _userFromFirebaseUser(userCredential.user);
  }

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
