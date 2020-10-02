import 'package:flutter/material.dart';

class LoadingFirebase extends StatefulWidget {
  @override
  _LoadingFirebaseState createState() => _LoadingFirebaseState();
}

class _LoadingFirebaseState extends State<LoadingFirebase> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text('Loading ...'),
        ),
      ),
    );
  }
}
