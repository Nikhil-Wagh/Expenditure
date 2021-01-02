import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/screens/home/monthly_overview_holder.dart';
import 'package:expenditure/screens/home/recent_expenditures.dart';
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

    if (_selectedExpenditureIndex >= expenditures.length) {
      _selectedExpenditureIndex = expenditures.length - 1;
    }
    if (_selectedExpenditureIndex < 0) _selectedExpenditureIndex = 0;

    return Expanded(
      child: Container(
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
      ),
    );
  }
}
