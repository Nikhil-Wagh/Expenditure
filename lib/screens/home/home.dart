import 'package:expenditure/constants.dart';
import 'package:expenditure/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You should see this when authenticated',
            ),
            SizedBox(height: 8.0),
            RaisedButton(
              color: primaryColor,
              onPressed: () => auth.signOut(),
              child: Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
