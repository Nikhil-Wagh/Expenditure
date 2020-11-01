import 'package:expenditure/models/user.dart';
import 'package:expenditure/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  /* 
   * Handles all the authentication related functions
   * Including sign in and sign up
   * Returns instance of AuthResult
   */

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User userFromFirebaseUser(auth.User firebaseUser) {
    if (firebaseUser == null) return null;
    // firebaseUser.providerData;
    print("[debug] AuthService firebase user = $firebaseUser");
    String email = firebaseUser.email, phoneNumber = firebaseUser.phoneNumber;

    if (email == null) {
      if (firebaseUser.providerData.length > 0 && firebaseUser.providerData.first != null) {
        email = firebaseUser.providerData.first.email;
      }
    }

    if (firebaseUser.phoneNumber == null) {
      if (firebaseUser.providerData.length > 0 && firebaseUser.providerData.first != null) {
        phoneNumber = firebaseUser.providerData.first.phoneNumber;
      }
    }
    return User(
      uid: firebaseUser.uid,
      email: email,
      displayName: firebaseUser.displayName,
      phoneNumber: phoneNumber,
      photoURL: firebaseUser.photoURL,
    );
  }

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map(userFromFirebaseUser);
  }

  Future signUpEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(user: userFromFirebaseUser(userCredential.user));
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
      return AuthResult(user: userFromFirebaseUser(userCredential.user));
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
    auth.User firebaseUser = userCredential.user;
    User user = userFromFirebaseUser(firebaseUser);
    DatabaseService().updateUserData(user);
    return AuthResult(user: user);
  }

  Future signInWithFacebook() async {
    print("AuthService.signInWithFacebook()");
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn([
      'email'
    ]);
    auth.FacebookAuthCredential facebookAuthCredential = auth.FacebookAuthProvider.credential(result.accessToken.token);

    auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    return AuthResult(user: userFromFirebaseUser(userCredential.user));
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
    return userFromFirebaseUser(userCredential.user);
  }

  Future signInWithApple() async {}

  signOut() {
    _firebaseAuth.signOut();
  }

  User currentUser() {
    if (_firebaseAuth.currentUser != null) {
      return userFromFirebaseUser(_firebaseAuth.currentUser);
    }
    // TODO: Default values for user model
    return User();
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
