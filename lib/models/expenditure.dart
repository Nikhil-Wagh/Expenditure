import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Expenditure {
  DocumentReference ref;
  Amount _amount;
  String description, mode;
  Timestamp timestamp;

  Expenditure({this.ref, double amount, this.description, this.mode, this.timestamp}) {
    print('[info] Creating new expenditure');
    print('[debug] Models.Expenditure.data = $amount, $description, $mode, $timestamp');
    this._amount = Amount(amount);
  }

  String timestampToString() {
    return DateFormat.MMMd().addPattern(', ').add_jm().format(timestamp.toDate());
  }

  String toString() {
    return '[ ref = $ref, amount = $amount, description $description, '
        'mode = $mode, timestamp = $timestamp ]';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': ref,
      'amount': amount,
      'description': description,
      'mode': mode,
      'timestamp': timestamp
    };
  }

  double get amount {
    return _amount.toDouble();
  }

  contains(String query) {
    if (amount.toString().contains(query)) return true;
    if (description.toLowerCase().contains(query)) return true;
    if (timestampToString().toLowerCase().contains(query)) return true;

    return false;
  }
}

class Amount {
  double _amount;
  var currency;
  Amount(var amount, {this.currency}) {
    this._amount = double.parse(amount.toString());
    if (currency == null) {
      // currency = Util.getCurrency();
    }
  }

  double toDouble() {
    return _amount;
  }

  @override
  String toString() {
    return _amount.toStringAsFixed(2);
  }
}
