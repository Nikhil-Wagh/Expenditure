import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid, email, displayName, phoneNumber;
  String photoURL;

  User({
    this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'displayName': this.displayName,
      'phoneNumber': this.phoneNumber,
      'photoURL': this.photoURL
    };
  }
}
