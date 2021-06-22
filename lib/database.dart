import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
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

  final CollectionReference userpets =
      FirebaseFirestore.instance.collection('userpets');

  final CollectionReference petlist =
      FirebaseFirestore.instance.collection('pets');

  final CollectionReference postlist =
      FirebaseFirestore.instance.collection('posts');

  Stream<QuerySnapshot> get users {
    return userslist.snapshots();
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //--------------------------APPLICATION MESSAGES------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  createApplicationRequest(dynamic chatroomID, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatroomID.toString())
        .get();
    if (snapShot.exists) {
      return "existing";
    } else {
      return FirebaseFirestore.instance
          .collection("application requests")
          .doc(chatroomID.toString())
          .set(chatRoomInfoMap);
    }
  }

  getLastChats2() async {
    String uname = await getUsername();
    return FirebaseFirestore.instance
        .collection("application requests")
        .where('users', arrayContains: uname)
        .orderBy('lastMessageSendTs', descending: true)
        .limit(5)
        .snapshots();
  }

  Future addMessage2(
      dynamic chatRoomID, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatRoomID.toString())
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSent2(dynamic chatroomID, Map lastMessageInfoMap) async {
    print(chatroomID.toString());
    return await FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatroomID.toString())
        .update(lastMessageInfoMap);
  }

  getApplicationStatus(dynamic chatRoomId) async {
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection("application requests")
          .doc(chatRoomId.toString())
          .get();
      return docSnap.get('application status');
    } catch (e) {
      return null;
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages2(
      dynamic chatRoomId, int fetchLimit) async {
    return FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatRoomId.toString())
        .collection("chats")
        .orderBy("ts", descending: true)
        .limit(fetchLimit)
        .snapshots();
  }

  deleteUnsentMessages2(dynamic chatroomID) async {
    await FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatroomID.toString())
        .collection("chats")
        .where("message status", isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("application requests")
            .doc(chatroomID.toString())
            .collection("chats")
            .doc(element.id)
            .delete();
      });
    });
  }

  convoOpened2(String username, dynamic chatroomID) async {
    try {
      final lastMsg = await FirebaseFirestore.instance
          .collection("application requests")
          .doc(chatroomID.toString())
          .get();
      String sender = await lastMsg.get('lastMessageSentby');
      if (sender != username) {
        await FirebaseFirestore.instance
            .collection("application requests")
            .doc(chatroomID.toString())
            .update({"lastMessageSeen": true});
      }
    } catch (e) {}
  }

  getConvoStatus2(String username, String chatroomID) async {
    await convoOpened2(username, chatroomID);
    try {
      final lastMsg = await FirebaseFirestore.instance
          .collection("application requests")
          .doc(chatroomID.toString())
          .get();
      return await lastMsg.get('lastMessageSeen');
    } catch (e) {}
  }

  messageStatusChecker2(dynamic chatRoomID, String messageId) async {
    var status;
    final chatDoc = FirebaseFirestore.instance
        .collection("application requests")
        .doc(chatRoomID.toString())
        .collection("chats");

    DocumentSnapshot docSnap = await chatDoc.doc(messageId).get();
    status = await docSnap.get("message status");
    if (status == false) {
      await chatDoc.doc(messageId).delete();
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------BOOKMARKS---------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  addToBookmarks(String id) async {
    try {
      return await userslist.doc(uid).update({
        'bookmarks': FieldValue.arrayUnion([id])
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getBookmarks() async {
    final storageReference = FirebaseStorage.instance.ref();
    List<Pet> bookmarkedPets = [];
    var list = [];

    try {
      final ud = await userslist.doc(uid).get();
      var ud2;
      var ud3;
      String id;
      Pet fetchedPet;
      list = ud.get('bookmarks');

      String name;
      for (int i = 0; i < list.length; i++) {
        ud2 = await petlist.doc(list[i]).get();
        id = ud2.get('ownerID');
        ud3 = await userpets.doc(id).collection('petlist').doc(list[i]).get();
        name = list[i].toString();
        fetchedPet = new Pet(
            petID: list[i],
            petPic: await storageReference
                .child("Pet Profile Pictures/$name")
                .getData(),
            petName: ud3.get('name'),
            petAge: ud3.get('age'),
            petBreed: ud3.get('breed'),
            petCharacteristics: ud3.get('charac'),
            petMedHis: ud3.get('medhis'),
            petNeeds: ud3.get('needs'),
            petSex: ud3.get('sex'),
            petOthers: ud3.get('others'));
        bookmarkedPets.add(fetchedPet);
      }
      return bookmarkedPets;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  removeBookmark(String id) async {
    var val = [];
    val.add(id);
    try {
      return await userslist
          .doc(uid)
          .update({'bookmarks': FieldValue.arrayRemove(val)});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //---------------------------DIRECT MESSAGES----------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  getLastChats() async {
    String uname = await getUsername();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where('users', arrayContains: uname)
        .orderBy('lastMessageSendTs', descending: true)
        .limit(5)
        .snapshots();
  }

  Future addMessage(
      dynamic chatRoomID, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomID.toString())
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSent(dynamic chatroomID, Map lastMessageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomID.toString())
        .update(lastMessageInfoMap);
  }

  createChatRoom(dynamic chatroomID, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomID.toString())
        .get();
    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomID.toString())
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(
      dynamic chatRoomId, int fetchLimit) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId.toString())
        .collection("chats")
        .orderBy("ts", descending: true)
        .limit(fetchLimit)
        .snapshots();
  }

  messageStatusChecker(dynamic chatRoomID, String messageId) async {
    var status;
    final chatDoc = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomID.toString())
        .collection("chats");

    DocumentSnapshot docSnap = await chatDoc.doc(messageId).get();
    status = await docSnap.get("message status");
    if (status == false) {
      await chatDoc.doc(messageId).delete();
    }
  }

  deleteUnsentMessages(dynamic chatroomID) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomID.toString())
        .collection("chats")
        .where("message status", isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatroomID.toString())
            .collection("chats")
            .doc(element.id)
            .delete();
      });
    });
  }

  convoOpened(String username, dynamic chatroomID) async {
    try {
      final lastMsg = await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomID.toString())
          .get();
      String sender = await lastMsg.get('lastMessageSentby');
      if (sender != username) {
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatroomID.toString())
            .update({"lastMessageSeen": true});
      }
    } catch (e) {}
  }

  getConvoStatus(String username, String chatroomID) async {
    await convoOpened(username, chatroomID);
    try {
      final lastMsg = await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomID.toString())
          .get();
      return await lastMsg.get('lastMessageSeen');
    } catch (e) {}
  }

  messageNotifHandler(String username) async {
    final here = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where('users', arrayContains: username)
        .get();
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-------------------------------EDIT PROFILE---------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

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
      await ud.update({'bio': " "});
    }
    if (nickname.isEmpty == false) {
      await ud.update({'nickname': nickname.toLowerCase()});
    } else {
      await ud.update({'nickname': "The user has not set this yet."});
    }
    if (address.isEmpty == false) {
      await ud.update({'address': address});
    } else {
      await ud.update({'address': "The user has not set this yet."});
    }
    if (cNum.isEmpty == false) {
      await ud.update({'contact number': cNum});
    } else {
      await ud.update({'contact number': "The user has not set this yet."});
    }
  }

  Future updatePetProfile(
      String petID,
      String petName,
      String petBreed,
      String petAge,
      String petSex,
      String petMedHis,
      String petNeeds,
      String petCharac,
      String petOthers) async {
    final ud = userpets.doc(uid).collection('petlist').doc(petID);

    if (petName.isEmpty == false) {
      await ud.update({'name': petName.toLowerCase()});
    }
    if (petBreed.isEmpty == false) {
      await ud.update({'breed': petBreed.toLowerCase()});
    }
    if (petAge.isEmpty == false) {
      await ud.update({'age': petAge});
    }
    if (petSex.isEmpty == false) {
      await ud.update({'sex': petSex.toLowerCase()});
    }
    if (petMedHis.isEmpty == false) {
      await ud.update({'medhis': petMedHis});
    }
    if (petNeeds.isEmpty == false) {
      await ud.update({'needs': petNeeds});
    }
    if (petCharac.isEmpty == false) {
      await ud.update({'charac': petCharac});
    }
    if (petOthers.isEmpty == false) {
      await ud.update({'others': petOthers});
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-------------------------------FOLLOWING------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

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

  addFollowing(String profileID) async {
    try {
      return await userslist.doc(uid).update({
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
      return await userslist
          .doc(uid)
          .update({'following': FieldValue.arrayRemove(val)});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------PETS--------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

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

      final petid = userpets.doc(uid).collection('petlist');
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

      await petlist.doc(returnval).set({'ownerID': uid});
      return returnval;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getPets(List<String> petIDs) async {
    final storageReference = FirebaseStorage.instance.ref();
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
      if (petIDs.isEmpty) {
        await userpets
            .doc(uid)
            .collection('petlist')
            .limit(4)
            .get()
            .then((doc) async {
          await Future.forEach(doc.docs, (e) async {
            petID = e.id;
            petName = ReCase(e['name']).titleCase;
            petAge = e['age'];
            petSex = ReCase(e['sex']).titleCase;
            petBreed = ReCase(e['breed']).titleCase;
            petNeeds = ReCase(e['needs']).titleCase;
            petCharacteristics = ReCase(e['charac']).titleCase;
            petMedHis = ReCase(e['medhis']).titleCase;
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
      } else {
        await userpets
            .doc(uid)
            .collection('petlist')
            .limit(4)
            .get()
            .then((doc) async {
          await Future.forEach(doc.docs, (e) async {
            if (!petIDs.contains(e.id)) {
              petID = e.id;
              petName = ReCase(e['name']).titleCase;
              petAge = e['age'];
              petSex = ReCase(e['sex']).titleCase;
              petBreed = ReCase(e['breed']).titleCase;
              petNeeds = ReCase(e['needs']).titleCase;
              petCharacteristics = ReCase(e['charac']).titleCase;
              petMedHis = ReCase(e['medhis']).titleCase;
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
            }
          });
        });
      }
      return pets;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  removePet(String id) async {
    try {
      final ud = userpets.doc(uid);
      await FirebaseStorage.instance
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

  getPetPhoto(String petID) async {
    final storageReference = FirebaseStorage.instance.ref();
    try {
      return await storageReference
          .child("Pet Profile Pictures/$petID")
          .getData();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------POSTS-------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  checkLiked(String postID) async {
    final docSnap = await postlist.doc(postID).get();
    List likers = await docSnap.get('likers');
    return likers.contains(FirebaseAuth.instance.currentUser.uid);
  }

  getUserPostsCount() async {
    try {
      final ud = await postlist.doc("admin").get();
      return ud.get('SystemPostsCount');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  addLikeToPost(String postID) async {
    final docSnap = await postlist.doc(postID).get();
    List likers = await docSnap.get('likers');
    if (likers.contains(uid)) {
      await postlist.doc(postID).update({
        'likers': FieldValue.arrayRemove([uid])
      });
      return await postlist.doc(postID).update({'likes': likers.length - 1});
    } else {
      await postlist.doc(postID).update({
        'likers': FieldValue.arrayUnion([uid])
      });
      return await postlist.doc(postID).update({'likes': likers.length + 1});
    }
  }

  addPost(String caption, String postID) async {
    final ud = postlist.doc("admin");
    ud.update({'SystemPostsCount': FieldValue.increment(1)});
    var count = await getUserPostsCount();
    final postDB = FirebaseFirestore.instance.collection('posts');
    int likes = 0;
    String date = DateTime.now().month.toString() +
        '/' +
        DateTime.now().day.toString() +
        '/' +
        DateTime.now().year.toString();
    try {
      if (caption.isNotEmpty) {
        return await postDB.doc(postID).set({
          'post ID': postID,
          'poster ID': uid,
          'post number': count,
          'caption': caption,
          'date': date,
          'likes': likes,
          'likers': []
        });
      } else {
        return await postDB.doc(postID).set({
          'post ID': postID,
          'poster ID': uid,
          'post number': count,
          'caption': "",
          'date': date,
          'likes': likes,
          'likers': []
        });
      }
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
    String date;
    int likes;
    bool liked;

    final storageReference = FirebaseStorage.instance.ref();

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .where('poster ID', isEqualTo: uid)
          .orderBy('post number', descending: true)
          .limitToLast(9)
          .get()
          .then((doc) async {
        await Future.forEach(doc.docs, (e) async {
          name2 = e.id;
          postPic = await storageReference.child("User Posts/$name2").getData();
          caption = e['caption'];
          date = e['date'];
          likes = e['likes'];
          uid = e['poster ID'];
          liked = await checkLiked(e.id);
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
          post = new Post(
            postID: e.id,
            userPic: pic,
            userName: name,
            postPic: postPic,
            caption: caption,
            date: date,
            likes: likes,
            liked: liked,
          );
          posts.add(post);
        });
      });

      return posts;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getPosts1() async {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('poster ID', isEqualTo: uid)
        .snapshots();
  }

  getPostPicture(String postID) async {
    final storageReference = FirebaseStorage.instance.ref();
    return await storageReference.child("User Posts/$postID").getData();
  }

  getHomePosts(List<String> showed) async {
    List<Post> posts = [];
    String name;
    dynamic pic = AssetImage('assets/images/defaultPic.png');
    Uint8List postPic;
    Post post;
    var name2;
    String caption = "";
    String date;
    int likes;
    bool liked;

    final storageReference = FirebaseStorage.instance.ref();
    List<dynamic> following = await getFollowing();
    following.add(uid);
    try {
      if (showed.isEmpty) {
        await FirebaseFirestore.instance
            .collection('posts')
            .where('poster ID', whereIn: following)
            .orderBy('post number', descending: true)
            .limit(2)
            .get()
            .then((doc) async {
          await Future.forEach(doc.docs, (e) async {
            name2 = e.id;
            liked = await checkLiked(e.id);
            postPic =
                await storageReference.child("User Posts/$name2").getData();
            caption = e['caption'];
            date = e['date'];
            likes = e['likes'];
            uid = e['poster ID'];
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
            post = new Post(
                postID: e.id,
                userPic: pic,
                userName: name,
                postPic: postPic,
                caption: caption,
                date: date,
                liked: liked,
                likes: likes);
            posts.add(post);
          });
        });
      } else {
        List<dynamic> fetchedSnaps = [];
        final docSnap = FirebaseFirestore.instance
            .collection('posts')
            .where('poster ID', whereIn: following)
            .get();
        await docSnap.then((value) async {
          await Future.forEach(value.docs, (element) {
            if (!showed.contains(element['post ID'])) {
              fetchedSnaps.add(element);
            }
          });
        });
        fetchedSnaps
            .sort((b, a) => a['post number'].compareTo(b['post number']));
        if (fetchedSnaps.length > 2) {
          fetchedSnaps = fetchedSnaps.sublist(0, 1);
        }
        for (int i = 0; i < fetchedSnaps.length; i++) {
          name2 = fetchedSnaps[i].id;
          liked = await checkLiked(name2);
          postPic = await storageReference.child("User Posts/$name2").getData();
          caption = fetchedSnaps[i]['caption'];
          date = fetchedSnaps[i]['date'];
          likes = fetchedSnaps[i]['likes'];
          uid = fetchedSnaps[i]['poster ID'];
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
          post = new Post(
              postID: name2,
              userPic: pic,
              userName: name,
              postPic: postPic,
              caption: caption,
              date: date,
              liked: liked,
              likes: likes);
          posts.add(post);
        }
      }
      return posts;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  deletePost(String postID) async {
    try {
      final ud = postlist.doc("admin");
      await FirebaseStorage.instance.ref().child("User Posts/$postID").delete();
      await ud.update({'SystemPostsCount': FieldValue.increment(-1)});
      return await postlist.doc(postID).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-------------------------------REGISTRATION---------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  Future updateUser1(
      String username, String email, String fname, String lname) async {
    int count = 0;
    List<String> following = [];
    await userslist.doc(uid).set({'postcount': count});
    await userpets.doc(uid).set({'postcount': count});
    return await userslist.doc(uid).set({
      'accType': "personal",
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
    await userslist.doc(uid).set({'postcount': count});
    await userpets.doc(uid).set({'postcount': count});
    return await userslist.doc(uid).set({
      'accType': "institution",
      'verified': false,
      'username': username,
      'email': email,
      'institution name': iname.toLowerCase(),
      'following': following,
    });
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //------------------------------SETUP PROFILE---------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  Future updateUserInfo1(
      String nickname, String address, String cNum, String bio) async {
    return await userslist.doc(uid).update({
      'nickname': nickname.toLowerCase(),
      'address': address.toLowerCase(),
      'contact number': cNum,
      'bio': bio,
    });
  }

  //----------------------------------------------------------------------------

  Future updateUsername(String newUsername) async {
    try {
      return await userslist.doc(uid).update({'username': newUsername});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updatePassword(String newPassword) async {
    try {
      return await FirebaseAuth.instance.currentUser
          .updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //---------------------------USER DETAILS GETTER------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  Future getAccountType() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("accType");
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
      return "WAP USER";
    }
  }

  Future getUserID(String name) async {
    String userID;
    try {
      final un = userslist.where('username', isEqualTo: name);
      await un.get().then((value) async {
        await Future.forEach(value.docs, (doc) async {
          userID = doc.id;
        });
      });
      return userID;
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
      return "WAP_USER@email.com";
    }
  }

  Future getName() async {
    DocumentSnapshot un = await userslist.doc(uid).get();
    try {
      return ReCase(un.get("first name") + " " + un.get("last name")).titleCase;
    } catch (e) {
      return ReCase(un.get("institution name")).titleCase;
    }
  }

  Future getFName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      String name = ReCase(un.get("first name")).titleCase;
      if (name == null) name = ReCase(un.get("institution name")).titleCase;
      return name;
    } catch (e) {
      print(e.toString());
      return "WAP";
    }
  }

  Future getLName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      String name = ReCase(un.get("last name")).titleCase;
      if (name == null) name = ReCase(un.get("institution name")).titleCase;
      return name;
    } catch (e) {
      print(e.toString());
      return "USER";
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
      return " ";
    }
  }

  getNickname() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("nickname")).titleCase;
    } catch (e) {
      print(e.toString());
      return "The user has not set this yet.";
    }
  }

  getAddress() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("address");
    } catch (e) {
      print(e.toString());
      return "The user has not set this yet.";
    }
  }

  getContact() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("contact number");
    } catch (e) {
      print(e.toString());
      return "The user has not set this yet.";
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
      return AssetImage('assets/images/defaultPic.png');
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //---------------------------NOTHING FOLLOWS----------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

}
