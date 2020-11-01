import 'package:expenditure/utils.dart';

class MonthlyOverview {
  var year, month;
  var income, expenses;

  MonthlyOverview({this.year, this.month, this.income, this.expenses}) {
    if (expenses == null) this.expenses = 0;
  }

  void addToBalance(double amount) {
    this.income += amount;
  }

  void addToExpenses(double amount) {
    this.expenses += amount;
  }

  balance() {
    print('[debug] MonthlyOverview :: income = $income, expenses = $expenses');
    return income - expenses;
  }

  String get monthYear {
    return Utils.getMonthYear(month, year);
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'income': income,
      'expenses': expenses
    };
  }
}
