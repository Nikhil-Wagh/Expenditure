// Usefull common functions or classes
// For eg: PaddedTextView

// ignore: implementation_imports
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class Utils {
  // TODO: Move into utils folder
  static NumberFormat getCurrency() {
    return numberFormatSymbols['in'].CURRENCY_PATTERN;
  }

  static String getMonthlyOverviewDocName(int month, int year) {
    return DateFormat('M_y').format(DateTime(year, month));
  }

  static String getMonthYear(int month, int year) {
    return DateFormat.yMMM().format(DateTime(year, month));
  }

  static DateTime monthYearFromTimestamp(Timestamp timestamp) {
    // Returns the DateTime of the 1st day of the month of timestamp
    // 2020-12-20:T10:42:33.231 => 2020-12-01:T00:00.000
    int _microSecondsSinceEpoch = timestamp.microsecondsSinceEpoch;
    DateTime _dateTime = DateTime.fromMicrosecondsSinceEpoch(_microSecondsSinceEpoch);
    return DateTime(_dateTime.year, _dateTime.month);
  }

  static String formatTimestamp(Timestamp timestamp) {
    return DateFormat(timestampFormat).format(timestamp.toDate());
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(timestampFormat).format(dateTime);
  }

  static String dayMonthFromDateTime(DateTime dateTime) {
    return DateFormat.MMMMd().format(dateTime);
  }

  static String monthYearFromDateTime(DateTime dateTime) {
    return DateFormat.yMMM().format(dateTime);
  }

  static String formatCurrency(double value, String locale) {
    return NumberFormat.simpleCurrency(
      locale: locale,
      decimalDigits: 2,
    ).format(value);
  }
}
