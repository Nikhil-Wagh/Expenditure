import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart';
import 'package:expenditure/services/auth.dart';

import 'dart:io';

class DatabaseService {
  /*
    Functions
    - download list of expenditures between dates
    - get list of expenditures
    - get income for any point in time/index
    - get expenditures details till some point time/index
  */

  final String uid = AuthService().currentUser().uid;
  static FirebaseFirestore _firestoreInstance;
  static DocumentReference _userDoc;
  static CollectionReference _expendituresCollection;

  Stream<List<Expenditure>> expenditures({DateTime startDate, DateTime endDate}) {
    print("[info] DatabaseService.expenditure Creating a stream");
    // 1st January, 1970
    if (startDate == null) startDate = DateTime.parse(DEFAULT_START_DATE);

    // Forever
    if (endDate == null) endDate = DateTime.parse(DEFAULT_END_DATE);

    if (_expendituresCollection == null) {
      _expendituresCollection = _getExpendituresCollection();
    }
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
        // TODO: Decide whether we want limit or not
        // Probably need to do some load testing
        .snapshots()
        .map(_expendituresListFromSnapshots);
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

  List<Expenditure> _expendituresListFromSnapshots(QuerySnapshot querySnapshot) {
    // Ideally these values should not be null and should raise error if null
    if (querySnapshot == null) return [];
    print('[debug] DatabaseService._expendituresListFromSnapshots.querySnapshot.size = ${querySnapshot.size}');
    return querySnapshot.docs.map((doc) {
      print('[debug] DatabaseService._expendituresListFromSnapshots.doc = ${doc.data()}');
      double amount = double.parse(doc.data()['amount'].toString());
      return Expenditure(
        ref: doc.reference,
        amount: amount ?? 0.0,
        description: doc.data()['description'] ?? '',
        mode: doc.data()['mode'] ?? 'CASH', // Default mode will be CASH
        timestamp: doc.data()['timestamp'] ?? Timestamp.now(),
      );
    }).toList();
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
          AuthService().currentUser().uid,
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
