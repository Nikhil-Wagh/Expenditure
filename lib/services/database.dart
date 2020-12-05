import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart';
import 'package:expenditure/models/monthly_overview.dart';
import 'package:expenditure/services/auth.dart';
import 'package:expenditure/utils.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/src/widgets/async.dart';

class DatabaseService {
  /*
    Functions
    - download list of expenditures between dates
    - get list of expenditures
    - get income for any point in time/index
    - get expenditures details till some point time/index
  */

  final String uid = AuthService().currentUser().uid;
  FirebaseFirestore _firestoreInstance;
  DocumentReference _userDoc;
  CollectionReference _expendituresCollection;
  CollectionReference _monthlyOverview;

  DatabaseService() {
    if (!Platform.isAndroid || !Platform.isIOS) {
      String host = "10.0.2.2:8080";
      print("Connecting to $host");
      FirebaseFirestore.instance.settings = Settings(
        host: host,
        sslEnabled: false,
      );
    }

    _firestoreInstance = FirebaseFirestore.instance;
    _firestoreInstance.enableNetwork();
    print("[debug] DatabaseService.uid = $uid");
    _userDoc = _firestoreInstance.collection(USERS_COLLECTION).doc(uid);
    _expendituresCollection = _userDoc.collection(EXPENDITURES_COLLECTION);
  }

  Stream<List<Expenditure>> expenditures({DateTime startDate, DateTime endDate}) {
    print("[info] DatabaseService.expenditure Creating a stream");
    // 1st January, 1970
    if (startDate == null) startDate = DateTime.parse(DEFAULT_START_DATE);

    // Forever
    if (endDate == null) endDate = DateTime.parse(DEFAULT_END_DATE);
    return _expendituresCollection
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where(
          'timestamp',
          isLessThan: Timestamp.fromDate(endDate),
        )
        .orderBy('timestamp')
        .snapshots()
        .map(_expendituresListFromSnapshots);
  }

  List<Expenditure> _expendituresListFromSnapshots(QuerySnapshot querySnapshot) {
    // Ideally these values should not be null and should raise error if null
    if (querySnapshot == null) return [];
    print('[debug] DatabaseService._expendituresListFromSnapshots.querySnapshot.size = ${querySnapshot.size}');
    return querySnapshot.docs.map((doc) {
      print('[debug] DatabaseService._expendituresListFromSnapshots.doc = ${doc.data()}');
      double amount = double.parse(doc.data()['amount'].toString());
      return Expenditure(
        amount: amount ?? 0.0,
        description: doc.data()['description'] ?? '',
        mode: doc.data()['mode'] ?? 'CASH', // Default mode will be CASH
        timestamp: doc.data()['timestamp'] ?? Timestamp.now(),
      );
    }).toList();
  }

  Future updateUserData(User user) async {
    return await _userDoc.set(user.toMap());
  }

  Future getUserSnapshot() async {
    DocumentSnapshot userSnapshot = await _userDoc.get();
    print("[info] DatabaseService.getUserSnapshot");
    print("[debug] userSnapshot.data() = ${userSnapshot.data()}");
  }

  Future<QuerySnapshot> getMonthlyOverview(int month, int year) {
    if (_monthlyOverview == null) _monthlyOverview = _userDoc.collection(MONTHLY_OVERVIEW_COLLECTION);

    return _monthlyOverview.where('month', isEqualTo: month).where('year', isEqualTo: year).get();
  }

  Future addToIncome(MonthlyOverview monthlyOverview) async {
    if (_monthlyOverview == null) _monthlyOverview = _userDoc.collection(MONTHLY_OVERVIEW_COLLECTION);

    return await _monthlyOverview.doc(Utils.getMonthlyOverviewDocName(monthlyOverview.month, monthlyOverview.year)).set(monthlyOverview.toMap());
  }

  Stream monthlyOverviewStream() {
    if (_monthlyOverview == null) _monthlyOverview = _userDoc.collection(MONTHLY_OVERVIEW_COLLECTION);
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    String docName = Utils.getMonthlyOverviewDocName(month, year);
    print('[debug] month = $month, year = $year, docName = $docName');
    print(_monthlyOverview.doc(docName).get().asStream());
    return _monthlyOverview.doc(docName).get().asStream();
  }

  MonthlyOverview monthlyOverviewFromSnapshot(AsyncSnapshot<DocumentSnapshot> snapshot) {
    print('[debug] monthlyOverviewFromSnapshot.snapshot = ${snapshot.data.data()}');
    Map<String, dynamic> data = snapshot.data.data();
    if (data == null) throw 'No data from snapshot = $snapshot';
    print('[debug] snapshot reference = ${snapshot.data.reference}');
    return MonthlyOverview(expenses: data['expenses'], income: data['income'], month: data['month'], year: data['year']);
  }
}
