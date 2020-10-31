import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/utils.dart';

class Expenditure {
  Amount amount;
  String description, mode;
  Timestamp timestamp;

  Expenditure({double amount, this.description, this.mode, this.timestamp}) {
    print('[info] Creating new expenditure');
    print('[debug] Models.Expenditure.data = $amount, $description, $mode, $timestamp');
    this.amount = Amount(amount);
    if (this.timestamp == null) {
      this.timestamp = Timestamp.now();
    }
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

  @override
  String toString() {
    return _amount.toStringAsFixed(2);
  }
}
