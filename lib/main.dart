import 'package:expenditure/screens/loaders/loading_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screens/errors/something_went_wrong.dart';
import 'screens/wrapper.dart';
import 'services/auth.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Something went wrong');
          print(snapshot.error);
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: primaryColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Wrapper(),
            ),
          );
        }
        return LoadingFirebase();
      },
    );
  }
}
