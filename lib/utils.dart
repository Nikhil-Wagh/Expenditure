// Usefull common functions or classes
// For eg: PaddedTextView
import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:intl/intl.dart';

class Util {
  static NumberFormat getCurrency() {
    // return

    // return NumberFormat.simpleCurrency(
    //   locale: Locale("en", "in").toString(),
    //   name: "24000",
    //   decimalDigits: 240000,
    // ).toString();
    // return NumberFormat.compactCurrency(new Locale("en", "in"), )
    // return NumberFormat.getCurrencyInstance(new Locale("en", "in"));
    return numberFormatSymbols['in'].CURRENCY_PATTERN;
    // Localizations.localeOf(context).toString();
  }
}
