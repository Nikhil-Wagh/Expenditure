import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart';

import 'dart:io';

class DatabaseService {
  final String uid;
  FirebaseFirestore _firestoreInstance;
  DocumentReference _userDoc;
  CollectionReference _expendituresCollection;

  DatabaseService({this.uid}) {
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

  static List<Expenditure> expendituresListFromSnapshots(QuerySnapshot querySnapshot) {
    // Ideally these values should not be null and should raise error if null
    if (querySnapshot == null) return null;
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

  Stream<QuerySnapshot> get expenditures {
    _expendituresCollection.snapshots().forEach((element) {
      for (var data in element.docs) print('[debug] data = ${data.data()}');
    });
    return _expendituresCollection.snapshots(); //.map(_expendituresListFromSnapshots);
  }

  Future getUserSnapshot() async {
    DocumentSnapshot userSnapshot = await _userDoc.get();
    print("[info] DatabaseService.getUserSnapshot");
    print("[debug] userSnapshot.data() = ${userSnapshot.data()}");
  }
}
