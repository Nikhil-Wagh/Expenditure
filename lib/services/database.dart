import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';

import 'package:expenditure/models/user.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/services/auth.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';

class DatabaseService {
  /*
    Functions
    - download list of expenditures between dates
    - get list of expenditures
    - get income for any point in time/index
    - get expenditures details till some point time/index
  */

  final String uid = AuthService().currentUser.uid;
  static FirebaseFirestore _firestoreInstance;
  static DocumentReference _userDoc;
  static CollectionReference _expendituresCollection;

  static Expenditures expenditures({DateTime startDate, DateTime endDate}) {
    // debugPrint("Started WAITING");
    // Future.delayed(Duration(seconds: 5));
    // debugPrint("Done WAITING");

    print("[info] DatabaseService.expenditure Creating a stream");
    // 1st January, 1970
    if (startDate == null) startDate = DateTime.parse(FIRST_DATE);

    // 31st December, 9999
    if (endDate == null) endDate = DateTime.parse(LAST_DATE);

    if (_expendituresCollection == null) {
      _expendituresCollection = _getExpendituresCollection();
    }

    Expenditures expenditures = Expenditures();

    _expendituresCollection
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where(
          'timestamp',
          isLessThan: Timestamp.fromDate(endDate),
        )
        .orderBy('timestamp', descending: true)
        // .limit(limit)
        // TODO: Decide whether I want limit or not
        // Probably need to do some load testing
        .snapshots()
        .forEach(
      (item) {
        assert(item != null);
        debugPrint('[debug] DatabaseService length of docs = ${item.docs.length}');
        item.docs.forEach(
          (doc) {
            expenditures.add(_expenditureFromDocument(doc));
          },
        );
      },
    );

    debugPrint('[info] Expenditures captured from database');
    return expenditures;
  }

  Future updateUserData(User user) async {
    if (_userDoc == null) {
      _userDoc = _getUserDoc();
    }
    return await _userDoc.set(user.toMap());
  }

  static Future<DocumentReference> addNewExpenditure(Expenditure newExpenditure) {
    _expendituresCollection = _expendituresCollection ?? _getExpendituresCollection();

    return _expendituresCollection.add(newExpenditure.toMap());
  }

  static Future<void> removeExpenditure(Expenditure expenditure) {
    return expenditure.ref.delete();
  }

  static Future<void> updateExpenditure(Expenditure oldExpenditure, Expenditure newExpenditure) {
    assert(newExpenditure.ref == null);
    return oldExpenditure.ref.update(newExpenditure.toMap());
  }

  static Expenditure _expenditureFromDocument(QueryDocumentSnapshot doc) {
    print('[debug] DatabaseService._expendituresListFromSnapshots.doc = '
        '${doc.data()}');
    double amount = double.parse(doc.data()['amount'].toString());
    return Expenditure(
      ref: doc.reference,
      amount: amount,
      description: doc.data()['description'],
      mode: doc.data()['mode'], // Default mode will be CASH
      timestamp: doc.data()['timestamp'],
    );
  }

  static CollectionReference _getExpendituresCollection() {
    if (_userDoc == null) {
      _userDoc = _getUserDoc();
    }

    return _userDoc.collection(EXPENDITURES_COLLECTION);
  }

  static DocumentReference _getUserDoc() {
    if (_firestoreInstance == null) {
      _firestoreInstance = _getFirebaseInstance();
    }

    return _firestoreInstance.collection(USERS_COLLECTION).doc(
          AuthService().currentUser.uid,
        );
  }

  static _getFirebaseInstance() {
    if (!Platform.isAndroid || !Platform.isIOS) {
      String host = "10.0.2.2:8080";
      print("Connecting to $host");
      FirebaseFirestore.instance.settings = Settings(
        host: host,
        sslEnabled: false,
      );
    }

    return FirebaseFirestore.instance;
  }
}
