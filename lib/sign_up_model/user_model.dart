import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'secondName': secondName,
        'photoUrl': photoUrl,
      };

  Future<void> save() async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(toMap(), SetOptions(merge: true));
  }
}
