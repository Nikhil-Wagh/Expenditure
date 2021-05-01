import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';

import 'package:expenditure/models/user.dart';
import 'package:expenditure/services/auth.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class DatabaseService extends ChangeNotifierProvider {
  /*
    Functions
    - download list of expenditures between dates
    - get list of expenditures
    - get income for any point in time/index
    - get expenditures details till some point time/index
  */

  static const String TAG = 'DatabaseService';
  final String uid = AuthService().currentUser.uid;
  static FirebaseFirestore _firestoreInstance;
  static DocumentReference _userDoc;
  static CollectionReference _expendituresCollection;

  static Stream<List<Expenditure>> expendituresList({DateTime startDate, DateTime endDate}) {
    // debugPrint("Started WAITING");
    // Future.delayed(Duration(seconds: 5));
    // debugPrint("Done WAITING");

    print("[info] DatabaseService.expenditure Creating a stream");
    // 1st January, 1970
    if (startDate == null) startDate = DateTime.parse(FIRST_DATE);
    debugPrint('[debug] $TAG startDate = $startDate');

    // 31st December, 9999
    if (endDate == null) endDate = DateTime.parse(LAST_DATE);
    debugPrint('[debug] $TAG endDate = $endDate');

    if (_expendituresCollection == null) {
      debugPrint('[debug] $TAG expenditure collection null, attempting to get');
      _expendituresCollection = _getExpendituresCollection();
    }

    // final Expenditures expenditures = Expenditures();
    // debugPrint('[info] $TAG new expenditures object created');
    // debugPrint('[debug] $TAG expenditures = ${expenditures.toString()}');

    return _expendituresCollection
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
        .map(_expendituresListFromSnapshots);
  }

  static List<Expenditure> _expendituresListFromSnapshots(QuerySnapshot querySnapshot) {
    // Ideally these values should not be null and should raise error if null
    if (querySnapshot == null) return [];
    print('[debug] DatabaseService._expendituresListFromSnapshots.querySnapshot.size = ${querySnapshot.size}');
    return querySnapshot.docs.map(_expenditureFromDocument).toList();
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
    assert(expenditure.ref != null);
    debugPrint('deleting ref = ${expenditure.ref} from database');

    return expenditure.ref.delete();
  }

  static Future<void> updateExpenditure(Expenditure oldExpenditure, Expenditure newExpenditure) {
    assert(newExpenditure.ref == null);
    return oldExpenditure.ref.update(newExpenditure.toMap());
  }

  static Expenditure _expenditureFromDocument(QueryDocumentSnapshot doc) {
    assert(doc != null);
    assert(doc.data().isNotEmpty);

    print('[debug] DatabaseService._expendituresListFromSnapshots.doc = '
        '${doc.data()}');
    double amount = double.parse(doc.data()['amount'].toString());
    return Expenditure(
      ref: doc.reference,
      amount: amount,
      description: doc.data()['description'],
      mode: doc.data()['mode'],
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
