import 'package:expenditure/screens/home/monthly_overview_holder.dart';
import 'package:expenditure/screens/home/recent_expenditures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  int _selectedExpenditure = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: NotificationListener<ExpenditureSelectedNotification>(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonthlyOverviewHolder(selectedExpenditureIndex: _selectedExpenditure),
              RecentExpenditures(selectedExpenditureIndex: _selectedExpenditure),
            ],
          ),
          onNotification: (notification) {
            print('[debug] HomeScreenBody.selectedNotification catched'
                ' notification with id = ${notification.selectedIndex}');
            if (_selectedExpenditure != notification.selectedIndex) {
              _selectedExpenditure = notification.selectedIndex;
              print('[debug] _selectedExpenditure = $_selectedExpenditure');
              return true;
            }
            return false;
          },
        ),
      ),
    );
  }
}
