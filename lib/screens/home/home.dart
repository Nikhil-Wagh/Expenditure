import 'package:expenditure/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'home_screen_app_bar.dart';
import 'home_screen_body.dart';

class Home extends StatelessWidget {
  static const String TAG = 'Home';

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] $TAG.build called');

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Center(
          child: Provider(
            create: (context) => ItemScrollController(),
            child: Column(
              children: [
                HomeScreenAppBar(),
                HomeScreenBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
