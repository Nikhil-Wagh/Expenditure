import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/screens/loaders/loading_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'monthly_overview_holder.dart';
import 'recent_expenditures.dart';

class HomeScreenBody extends StatefulWidget {
  HomeScreenBody();

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  static const String TAG = 'HomeScreenBodyState';

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] HomeScreenBodyState: creating body');
    final Expenditures expenditures = Provider.of<Expenditures>(
      context,
    );

    if (expenditures == null) {
      debugPrint('[debug] expenditures still loading');
      // Didn't received the data yet, show loading
      // TODO: Show LoadingHomeBody
      return LoadingAuth();
    } else {
      debugPrint('[info] expenditures loaded successfully');
      debugPrint('[debug] $TAG.expenditures = ${expenditures.toString()}');
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthlyOverviewHolder(),
          RecentExpenditures(),
        ],
      ),
    );
  }
}
