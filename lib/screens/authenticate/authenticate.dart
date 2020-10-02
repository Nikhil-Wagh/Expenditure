import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    void toggleView() {
      print('[INFO] Authenticate.toggleView() called');
      setState(() => showSignIn != showSignIn);
    }
    // TODO: Make a tabbed view for authentication

    // if (showSignIn) {
    //   return SignIn(toggleView: toggleView)
    // }
  }
}
