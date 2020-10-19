import 'dart:io';

import 'package:expenditure/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService auth = AuthService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser;
    print("User = ${user}");
    print("displayname = ${user.displayName}");
    assert(user != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              child: Image(
                image: NetworkImage(user.photoURL),
              ),
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.displayName,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}
