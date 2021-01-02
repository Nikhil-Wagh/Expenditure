import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart' as mUser;
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen_app_bar.dart';
import 'home_screen_body.dart';

class Home extends StatefulWidget {
  final mUser.User user;
  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    debugPrint('[info] Home.build called');
    print("[debug] _HomeState.user.uid = ${widget.user.uid}");
    return Container(
      margin: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
      child: Center(
        child: StreamProvider<List<Expenditure>>.value(
          value: DatabaseService().expenditures(),
          child: Column(
            children: [
              HomeScreenAppBar(user: widget.user),
              HomeScreenBody(),
            ],
          ),
        ),
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
