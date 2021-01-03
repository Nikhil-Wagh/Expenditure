import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/screens/home/monthly_overview_holder.dart';
import 'package:expenditure/screens/home/recent_expenditures.dart';
import 'package:expenditure/screens/loaders/loading_auth.dart';
import 'package:expenditure/utils/expenditure_selected_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  int _selectedExpenditureIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] HomeScreenBodyState: creating body');
    final List<Expenditure> expenditures = Provider.of<List<Expenditure>>(
      context,
    );

    if (expenditures == null) {
      debugPrint('[debug] expenditures still loading');
      // Didn't received the data yet, show loading
      return LoadingAuth();
    } else
      debugPrint('[info] expenditures loaded successfully');

    if (_selectedExpenditureIndex >= expenditures.length) {
      _selectedExpenditureIndex = expenditures.length - 1;
    }
    if (_selectedExpenditureIndex < 0) _selectedExpenditureIndex = 0;

    debugPrint('[debug] HomeScreenBody: _selectedExpenditureIndex = '
        '$_selectedExpenditureIndex');

    return Expanded(
      child: NotificationListener<ExpenditureSelectedNotification>(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonthlyOverviewHolder(
              selectedExpenditureIndex: _selectedExpenditureIndex,
              expenditures: expenditures,
            ),
            RecentExpenditures(
              selectedExpenditureIndex: _selectedExpenditureIndex,
              expenditures: expenditures,
            ),
          ],
        ),
        onNotification: (notification) {
          print('[debug] HomeScreenBody.selectedNotification catched'
              ' notification with id = ${notification.selectedIndex}');
          if (_selectedExpenditureIndex != notification.selectedIndex) {
            setState(() {
              _selectedExpenditureIndex = notification.selectedIndex;
            });
            print('[debug] HomeScreenBody '
                '_selectedExpenditure = $_selectedExpenditureIndex');
            return true;
          }
          return false;
        },
      ),
    );
  }
}
