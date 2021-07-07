import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO: rename to ExpenditureItem
class Expenditure extends ChangeNotifier {
  DocumentReference ref;
  Amount amount;
  String description, mode;
  Timestamp timestamp;
  String category;
  static const String TAG = 'ExpenditureItem';

  Expenditure({this.ref, this.amount, this.description, this.mode, this.timestamp, this.category}) {
    print('[info] $TAG Creating new expenditure');
    print('[debug] $TAG Models.Expenditure.data = $amount, $description, $mode, $timestamp');
  }

  get month => timestamp.toDate().month;

  get year => timestamp.toDate().year;

  String timestampToString() {
    return Utils.formatTimestamp(timestamp);
  }

  String toStringDebug() {
    return '[ ref = $ref, amount = $amount, description $description, '
        'mode = $mode, category = $category, timestamp = $timestamp ]';
  }

  String toString() {
    return '${amount.toString()}, $description, $mode, ${timestampToString()}';
  }

  Map<String, dynamic> toMap() {
    return {
      'ref': ref,
      'amount': {
        'value': amount.value,
        'locale': amount.locale
      },
      'description': description,
      'mode': mode,
      'category': category,
      'timestamp': timestamp,
    };
  }

  contains(String query) {
    if (amount.toString().contains(query)) return true;
    if (description.toLowerCase().contains(query)) return true;
    if (timestampToString().toLowerCase().contains(query)) return true;

    return false;
  }
}

class Amount {
  double value;
  String locale;
  Amount(this.value, this.locale);

  String get currency => NumberFormat.simpleCurrency(locale: locale).currencySymbol;

  double toDouble() {
    return value;
  }

  String toString() {
    return Utils.formatCurrency(value, locale);
  }
}
