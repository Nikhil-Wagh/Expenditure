import 'dart:ui';

import 'package:expenditure/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAuth extends StatelessWidget {
  @override
  Widget build(BuildContext contexts) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: EdgeInsets.only(top: 15.0),
          // color: Colors.black.withOpacity(0),
          child: Center(
            child: SpinKitThreeBounce(
              color: primaryAccentColor,
              size: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
