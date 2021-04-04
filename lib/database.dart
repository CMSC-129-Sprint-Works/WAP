import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');

  Future updateUser(String username, String email) async {
    return await userslist.doc(uid).set({'username': username, 'email': email});
  }
}

Future<bool> isUsernameAvailable(String username) async {
  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');
  userslist.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      if (doc["username"] == username) {
        return false;
      }
    });
    return true;
  });
}
