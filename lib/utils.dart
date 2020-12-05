// Usefull common functions or classes
// For eg: PaddedTextView
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:intl/intl.dart';

class Utils {
  static NumberFormat getCurrency() {
    return numberFormatSymbols['in'].CURRENCY_PATTERN;
  }

  static String getMonthlyOverviewDocName(int month, int year) {
    return DateFormat('M_y').format(DateTime(year, month));
  }

  static String getMonthYear(int month, int year) {
    return DateFormat.yMMM().format(DateTime(year, month));
  }

  static DateTime dateFromTimestamp(Timestamp timestamp) {
    int _microSecondsSinceEpoch = timestamp.microsecondsSinceEpoch;
    DateTime _dateTime = DateTime.fromMicrosecondsSinceEpoch(_microSecondsSinceEpoch);
    return DateTime(_dateTime.year, _dateTime.month);
  }

}
