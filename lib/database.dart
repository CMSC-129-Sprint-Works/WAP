import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');

  Future updateUser1(
      String username, String email, String fname, String lname) async {
    return await userslist.doc(uid).set({
      'username': username,
      'email': email,
      'first name': fname,
      'last name': lname,
    });
  }

  Future updateUser2(String username, String email, String iname) async {
    return await userslist
        .doc(uid)
        .set({'username': username, 'email': email, 'institution name': iname});
  }

  Future updateUserInfo1(
      String nickname, String address, String cNum, String bio) async {
    return await userslist.doc(uid).update({
      'nickname': nickname,
      'address': address,
      'contact number': cNum,
      'bio': bio
    });
  }

  Stream<QuerySnapshot> get users {
    return userslist.snapshots();
  }

  Future getUsername() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("username");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  
  Future getName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("first name") + " " + un.get("last name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //for first name and last name : return [firstname, lastname];
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
  });
  return true;
}
