import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart' as mUser;
import 'package:expenditure/screens/home/recent_expenditures.dart';
import 'package:expenditure/services/auth.dart';
import 'package:expenditure/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen_app_bar.dart';
import 'monthly_overview_holder.dart';

class Home extends StatelessWidget {
  final mUser.User user;
  Home({this.user});

  @override
  Widget build(BuildContext context) {
    print("[debug] _HomeState.user.uid = ${user.uid}");
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.all(mMargin),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeScreenAppBar(
                    displayName: user.displayName,
                    photoURL: user.photoURL,
                  ),
                  MonthlyOverviewHolder(),
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
