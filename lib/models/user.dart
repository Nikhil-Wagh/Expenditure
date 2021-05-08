class User {
  String uid, email, displayName, phoneNumber;
  String photoURL;
  bool isLoggedIn;
  String locale;

  User({
    this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.isLoggedIn = false,
    this.locale,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'displayName': this.displayName,
      'phoneNumber': this.phoneNumber,
      'photoURL': this.photoURL,
      'isLoggedIn': this.isLoggedIn,
      'locale': this.locale,
    };
  }
}
