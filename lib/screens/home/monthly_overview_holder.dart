import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyOverviewHolder extends StatefulWidget {
  final int selectedIndex;

  MonthlyOverviewHolder({this.selectedIndex});

  @override
  _MonthlyOverviewHolderState createState() => _MonthlyOverviewHolderState();
}

class _MonthlyOverviewHolderState extends State<MonthlyOverviewHolder> {
  @override
  Widget build(BuildContext context) {
    final List<Expenditure> expenditures = Provider.of<List<Expenditure>>(context);
    print("[debug] MonthlyOverviewHolderState.build.expenditures = $expenditures");
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
        ),
        child: _MonthlyOverviewDetail());
  }
}

class _MonthlyOverviewDetail extends StatelessWidget {
  List<Expenditure> expenditures;
  DateTime currentMonth;
  _MonthlyOverviewDetail({this.expenditures, this.currentMonth});

  double _expensesFrom(List<Expenditure> expenditures) {
    double expenses = 0;
    expenditures.forEach((element) {
      expenses += element.amount.toDouble();
    });
    return expenses;
  }

  double _incomeFor(int month, int year) {}

  // MonthlyOverview _monthlyOverviewFromExpenditures() {
  //   double _expenses = _expensesFrom(expenditures);
  //   double _income = DatabaseService.getIncome();
  //   return MonthlyOverview(expenses: _expenses, income: _income, month: this.month, year: this.year);
  // }

  @override
  Widget build(BuildContext context) {
    final Color fontColor = Colors.white;

    // MonthlyOverview monthlyOverviewData = _monthlyOverviewFromExpenditures();
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
                    "Balance",
                    // monthlyOverviewData.balance().toString(),
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
                      "2020, 11",
                      // monthlyOverviewData.monthYear,
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
          SizedBox(height: 0),
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
                    "Income",
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
                    "Expenses",
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
