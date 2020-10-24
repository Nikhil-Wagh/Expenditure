import 'package:expenditure/constants.dart';
import 'package:expenditure/models/user.dart' as mUser;
import 'package:expenditure/screens/home/recent_expenditures.dart';
import 'package:expenditure/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen_app_bar.dart';
import 'monthly_overview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService auth = AuthService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  mUser.User user;

  @override
  void initState() {
    user = auth.userFromFirebaseUser(firebaseAuth.currentUser);
    assert(user != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("[debug] _HomeState.user.uid = ${user.uid}");
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.all(mMargin),
            // Use this for gradient if it looks good
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       primaryAccentColor[100],
            //       primaryColor[100],
            //     ],
            //   ),
            // ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeScreenAppBar(
                    displayName: user.displayName,
                    photoURL: user.photoURL,
                  ),
                  MonthlyOverview(),
                  RecentExpenditures(uid: user.uid),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
