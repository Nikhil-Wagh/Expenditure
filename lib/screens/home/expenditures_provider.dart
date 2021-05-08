import 'package:expenditure/models/expenditure_item.dart';
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
        StreamProvider(create: (_) => DatabaseService.expendituresList()),
        ChangeNotifierProxyProvider<List<Expenditure>, Expenditures>(
          create: (context) => Expenditures(
            Provider.of<List<Expenditure>>(context, listen: false),
          ),
          update: (
            context,
            List<Expenditure> expendituresList,
            Expenditures expenditures,
          ) =>
              Expenditures(
            expendituresList,
            selectedExpenditureRef: expenditures.selectedExpenditureRef,
          ),
        ),
      ],
      child: AppNavigator(),
    );
  }
}
