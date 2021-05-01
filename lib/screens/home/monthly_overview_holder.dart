import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/models/monthly_overview.dart';
import 'package:expenditure/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This doesn't have to be a statefulwidget
class MonthlyOverviewHolder extends StatefulWidget {
  @override
  _MonthlyOverviewHolderState createState() => _MonthlyOverviewHolderState();
}

class _MonthlyOverviewHolderState extends State<MonthlyOverviewHolder> {
  static const String TAG = 'MonthlyOverviewHolder';
  @override
  Widget build(BuildContext context) {
    debugPrint('[info] $TAG build called');
    final Expenditures expenditures = Provider.of<Expenditures>(context);

    debugPrint('[info] $TAG expenditures = $expenditures');
    if (expenditures.isLoading) {
      // TODO: Create a loading placeholder
      return Container(
        child: Text('Loading ...'),
      );
    }

    debugPrint('[debug] $TAG calling isEmpty');
    if (expenditures.isEmpty) {
      // TODO: Return a proper Widget
      return Container(
        child: Text("No Expenditures added yet"),
      );
    }

    MonthlyOverview _monthlyOverview = _getMonthlyOverview(expenditures);
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(minHeight: 150),
      margin: EdgeInsets.all(mMargin),
      decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            tileMode: TileMode.repeated,
            // transform: ,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // transform: GradientTransform(),
            colors: [
// Colors.orange, // Accents with purple
              Colors.purple[900], // Accents with greens
              Colors.indigo, // Accents with red
            ],
          ),
          color: primaryColor,
          border: Border.all(color: Colors.black, width: 5)),
      child: _MonthlyOverviewDetail(
        monthYear: _monthlyOverview.monthYear,
        income: _monthlyOverview.income.toString(),
        balance: _monthlyOverview.balance.toString(),
        expenses: _monthlyOverview.expenses.toString(),
      ),
    );
  }

  MonthlyOverview _getMonthlyOverview(Expenditures expenditures) {
    // FIX ME: throws error when expenditures is empty
    // datetime should come from date.now() or if index >= 0

    Expenditure _selectedExpenditure = expenditures.items.firstWhere((expenditure) => expenditure.ref == expenditures.selectedExpenditureRef);

    DateTime selectedExpenditureMonthDateTime;

    selectedExpenditureMonthDateTime = Utils.dateFromTimestamp(
      _selectedExpenditure.timestamp,
    );

    int selectedExpenditureMonth = selectedExpenditureMonthDateTime.month;
    int selectedExpenditureYear = selectedExpenditureMonthDateTime.year;

    // FIXME: income would come from a static doc
    double income = 1000000;
    double expenses = 0;

    // index 0 is the latest expenditure
    expenditures.items.where((expenditure) => (expenditure.timestamp.compareTo(_selectedExpenditure.timestamp) <= 0)).forEach((item) {
      DateTime currentExpenditureMonthDateTime = Utils.dateFromTimestamp(
        item.timestamp,
      );
      int currentMonth = currentExpenditureMonthDateTime.month;
      int currentYear = currentExpenditureMonthDateTime.year;
      // comparing with currentMonth is also fine
      if (currentMonth != selectedExpenditureMonth || currentYear != selectedExpenditureYear) {
        return;
      }

      expenses += item.amount;
    });

    return MonthlyOverview(
      expenses: expenses,
      income: income,
      month: selectedExpenditureMonth,
      year: selectedExpenditureYear,
    );
  }
}

class _MonthlyOverviewDetail extends StatefulWidget {
  final String balance, income, expenses;
  final String monthYear;
  _MonthlyOverviewDetail({
    this.monthYear,
    this.income,
    this.balance,
    this.expenses,
  });

  @override
  __MonthlyOverviewDetailState createState() => __MonthlyOverviewDetailState();
}

class __MonthlyOverviewDetailState extends State<_MonthlyOverviewDetail> {
  final Color fontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    balanceString,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.balance,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      // Take this from monthly overview object
                      widget.monthYear,
                      style: TextStyle(
                        fontSize: 16,
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 40,
            thickness: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    incomeString,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.income,
                    // monthlyOverviewData.income.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expensesString,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.expenses,
                    // monthlyOverviewData.expenses.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
