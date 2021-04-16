import 'package:expenditure/constants.dart';

import 'package:flutter/material.dart';

import 'home_screen_app_bar.dart';
import 'home_screen_body.dart';

class Home extends StatefulWidget {
  // TODO: user can be removed from all constructors as there is a provider
  // of User in successors
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String TAG = "Home";
  @override
  Widget build(BuildContext context) {
    debugPrint('[info] $TAG.build called');

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Center(
          child: Column(
            children: [
              HomeScreenAppBar(),
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
