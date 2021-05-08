import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/authenticate/authenticate.dart';
import 'package:expenditure/screens/home/expenditures_provider.dart';
import 'package:expenditure/screens/loaders/loading_auth.dart';
import 'package:expenditure/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LoadApp extends StatelessWidget {
  // 1. Show a splash screen when the app is launched
  // 2. Create firebase instance and wait for it to load
  // 3. Get the user data from firebase instance and
  // 4. navigate to either Authenticate Screen or Home

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] LoadApp.build called');
    initializeDateFormatting();
    Intl.defaultLocale = 'en_IN';

    return Scaffold(
      body: StreamBuilder<f_auth.User>(
        stream: f_auth.FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingAuth();
          } else {
            if (snapshot.hasData) {
              return Provider<User>(
                create: (context) => AuthService.userFromFirebaseUser(
                  snapshot.data,
                ),
                child: ExpendituresProvider(),
              );
            } else {
              return Authenticate();
            }
          }
        },
      ),
    );
  }
}
