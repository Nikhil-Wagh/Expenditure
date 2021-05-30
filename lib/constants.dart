// Strings
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const welcome = "Welcome";
const helloString = "Hello";
const createAccountString = "Log into your Expenditure account to analyze your spending, create a monthly budget and save more money";
const motoString = "A penny saved is a penny earned";
const incomeString = "Income";
const balanceString = "Balance";
const expensesString = "Expenses";

// Colors
const primaryColor = Colors.orange;
const primaryAccentColor = Colors.deepOrangeAccent;
const mTextColor = Colors.white;
const mUnselectedTextColor = Colors.grey;

// Dimensions
const mPadding = 8.0;
const mMargin = 8.0;

const USERS_COLLECTION = 'users';
const EXPENDITURES_COLLECTION = 'expenditures';
const MONTHLY_OVERVIEW_COLLECTION = 'monthly_overview';

const FIRST_DATE = "1970-01-01";
const LAST_DATE = "9999-12-31";

const List<Map<String, dynamic>> PAYMENT_MODES = [
  {
    'name': 'CASH',
    'icon': MdiIcons.cash,
    'color': Color(0xFF33691E),
  },
  {
    'name': 'UPI',
    'icon': Icons.mobile_friendly_outlined,
    'color': Color(0xFF0277BD),
  },
  {
    'name': 'CARD',
    'icon': MdiIcons.creditCard,
    'color': Color(0xFFD32F2F),
  },
  {
    'name': 'NET BANKING',
    'icon': MdiIcons.bank,
    'color': Color(0xFF6A1B9A),
  },
];

const String timestampFormat = 'd MMM, h:mm a';
const String dayMonthFormat = 'd MMM';
