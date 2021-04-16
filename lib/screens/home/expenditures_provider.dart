import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/services/database.dart';
import 'package:expenditure/utils/app_navigator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpendituresProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Expenditures>(
          create: (context) => DatabaseService.expenditures(),
        ),
      ],
      child: AppNavigator(),
    );
  }
}
