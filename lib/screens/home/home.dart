import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart' as mUser;
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen_app_bar.dart';
import 'home_screen_body.dart';
import 'monthly_overview_holder.dart';

class Home extends StatelessWidget {
  final mUser.User user;
  Home({this.user});

  @override
  Widget build(BuildContext context) {
    print("[debug] _HomeState.user.uid = ${user.uid}");
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(mMargin),
        child: Center(
          child: StreamProvider<List<Expenditure>>.value(
            value: DatabaseService().expenditures(),
            child: Column(
              children: [
                HomeScreenAppBar(
                  displayName: user.displayName,
                  photoURL: user.photoURL,
                ),
                HomeScreenBody(),
                // MonthlyOverviewHolder(),
                // RecentExpenditures(uid: user.uid),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
