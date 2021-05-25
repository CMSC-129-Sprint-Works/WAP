import 'dart:typed_data';
import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wap/classtype.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;
  DatabaseService({this.uid});

  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference userposts =
      FirebaseFirestore.instance.collection('userposts');

  final CollectionReference userpets =
      FirebaseFirestore.instance.collection('userpets');

  Future updateUser1(
      String username, String email, String fname, String lname) async {
    int count = 0;
    List<String> following = [];
    await userposts.doc(uid).set({'postcount': count});
    await userpets.doc(uid).set({'postcount': count});
    return await userslist.doc(uid).set({
      'username': username,
      'email': email,
      'first name': fname.toLowerCase(),
      'last name': lname.toLowerCase(),
      'following': following,
    });
  }

  Future updateUser2(String username, String email, String iname) async {
    int count = 0;
    List<String> following = [];
    await userposts.doc(uid).set({'postcount': count});
    await userpets.doc(uid).set({'postcount': count});
    return await userslist.doc(uid).set({
      'username': username,
      'email': email,
      'institution name': iname.toLowerCase(),
      'following': following,
    });
  }

  Future updateUserInfo1(
      String nickname, String address, String cNum, String bio) async {
    return await userslist.doc(uid).update({
      'nickname': nickname.toLowerCase(),
      'address': address.toLowerCase(),
      'contact number': cNum,
      'bio': bio,
    });
  }

  Future updateProfile1(String first, String last, String bio, String nickname,
      String address, String cNum) async {
    final ud = userslist.doc(uid);
    if (first.isEmpty == false) {
      await ud.update({'first name': first.toLowerCase()});
    }
    if (last.isEmpty == false) {
      await ud.update({'last name': last.toLowerCase()});
    }
    if (bio.isEmpty == false) {
      await ud.update({'bio': bio});
    } else {
      await ud.update({'bio': "The user has not set this yet.".toLowerCase()});
    }
    if (nickname.isEmpty == false) {
      await ud.update({'nickname': nickname.toLowerCase()});
    } else {
      await ud
          .update({'nickname': "The user has not set this yet.".toLowerCase()});
    }
    if (address.isEmpty == false) {
      await ud.update({'address': address});
    } else {
      await ud
          .update({'address': "The user has not set this yet.".toLowerCase()});
    }
    if (cNum.isEmpty == false) {
      await ud.update({'contact number': cNum});
    } else {
      await ud.update(
          {'contact number': "The user has not set this yet.".toLowerCase()});
    }
  }

  addFollowing(String profileID) async {
    try {
      final ud = await userslist.doc(uid).update({
        'following': FieldValue.arrayUnion([profileID])
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  removeFollowing(String profileID) async {
    var val = [];
    val.add(profileID);
    try {
      final ud = await userslist
          .doc(uid)
          .update({'following': FieldValue.arrayRemove(val)});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> get users {
    return userslist.snapshots();
  }

  getUserPostsCount() async {
    try {
      final ud = await userposts.doc(uid).get();
      return ud.get('postcount');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  addPost(String caption) async {
    String postNum;
    try {
      final ud = userposts.doc(uid);

      ud.update({'postcount': FieldValue.increment(1)});
      if (caption.isNotEmpty) {
        getUserPostsCount().then((value) {
          ud.update({'$value': caption});
        });
      } else {
        getUserPostsCount().then((value) {
          ud.update({'$value': ""});
        });
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getUserPetsCount() async {
    try {
      final ud = await userpets.doc(uid).get();
      return ud.get('petcount');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  addPet(String name, String age, String sex, String breed, String needs,
      String others, String charac, String medhis) async {
    final ud = userpets.doc(uid);
    try {
      ud.update({'petcount': FieldValue.increment(1)});

      final petid = await userpets.doc(uid).collection('petlist');
      String returnval;

      await petid.add({
        'name': name,
        'age': age,
        'sex': sex,
        'breed': breed,
        'needs': needs,
        'others': others,
        'charac': charac,
        'medhis': medhis,
      }).then((DocumentReference doc) => returnval = doc.id);

      return returnval;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getFollowing() async {
    var list = [];
    try {
      final ud = await userslist.doc(uid).get();
      list = ud.get('following');
      return list;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getPosts() async {
    List<Post> posts = [];
    String name;
    dynamic pic = AssetImage('assets/images/defaultPic.png');
    Uint8List postPic;
    Post post;
    var name2;
    String caption = "";
    var postCount = 0;
    await getUserPostsCount().then((value) {
      postCount = value;
    });

    final storageReference = FirebaseStorage.instance.ref();
    final ud = await userposts.doc(uid).get();
    await getPicture().then((value) {
      if (value != null) {
        pic = value;
      }
    });

    await getName().then((value) {
      name = value.toString();
    }, onError: (msg) {
      getName2().then((value) => name = value.toString());
    });
    try {
      if (postCount > 0) {
        for (int i = postCount; i > 0; i--) {
          name2 = i.toString();
          postPic = await storageReference.child("Posts/$uid/$name2").getData();
          caption = ud.get(name2);
          post = new Post(
              userPic: pic, userName: name, postPic: postPic, caption: caption);
          posts.add(post);
        }
      }
      return posts;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //to get data about pets
  getPets() async {
    final storageReference = await FirebaseStorage.instance.ref();
    String petID;
    List<Pet> pets = [];
    Pet fetchedPet;
    Uint8List petPic;
    String petName;
    String petAge;
    String petSex;
    String petBreed;
    String petNeeds;
    String petCharacteristics;
    String petMedHis;
    String petOthers;
    try {
      final ud =
          await userpets.doc(uid).collection('petlist').get().then((doc) async {
        await Future.forEach(doc.docs, (e) async {
          petID = e.id;
          petName = e['name'];
          petAge = e['age'];
          petSex = e['sex'];
          petBreed = e['breed'];
          petNeeds = e['needs'];
          petCharacteristics = e['charac'];
          petMedHis = e['medhis'];
          petOthers = e['others'];
          petPic = await storageReference
              .child("Pet Profile Pictures/$petID")
              .getData();
          fetchedPet = new Pet(
              petID: petID,
              petPic: petPic,
              petName: petName,
              petAge: petAge,
              petSex: petSex,
              petBreed: petBreed,
              petNeeds: petNeeds,
              petCharacteristics: petCharacteristics,
              petMedHis: petMedHis,
              petOthers: petOthers);
          pets.add(fetchedPet);
        });
      });

      return pets;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  removePet(String id) async {
    try {
      final ud = userpets.doc(uid);
      final storageReference = await FirebaseStorage.instance
          .ref()
          .child("Pet Profile Pictures/$id")
          .delete();
      await ud.update({'petcount': FieldValue.increment(-1)});
      return await userpets.doc(uid).collection('petlist').doc(id).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
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

  Future getEmail() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("email");
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

  Future getFName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("first name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getLName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("last name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getName2() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("institution name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getBio() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("bio");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getNickname() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("nickname")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getAddress() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("address");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getContact() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("contact number");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getPicture() async {
    try {
      final storageReference = await FirebaseStorage.instance
          .ref()
          .child("Profile Pictures/$uid")
          .getData();
      return MemoryImage(storageReference);
    } catch (e) {
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
