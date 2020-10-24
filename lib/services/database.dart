import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';

import 'dart:io';

import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/home/list_expenditures.dart';

class DatabaseService {
  final String uid;
  FirebaseFirestore _firestoreInstance;
  DocumentReference userDoc;
  CollectionReference expendituresCollection;

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
    userDoc = _firestoreInstance.collection(USERS_COLLECTION).doc(uid);
    expendituresCollection = userDoc.collection(EXPENDITURES_COLLECTION);
  }

  Future updateUserData(User user) async {
    return await userDoc.set(user.toMap());
  }

  Stream<QuerySnapshot> get expenditures {
    return expendituresCollection.snapshots();
  }

  Future getUserSnapshot() async {
    DocumentSnapshot userSnapshot = await userDoc.get();
    print("[info] DatabaseService.getUserSnapshot");
    print("[debug] userSnapshot.data() = ${userSnapshot.data()}");
  }
}
