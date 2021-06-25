import 'dart:typed_data';
import 'package:flutter/material.dart';

class SearchedUser {
  final String id;
  final String name;
  final String username;
  final dynamic userpic;
  final bool userStatus;
  const SearchedUser(
      {@required this.id,
      @required this.name,
      @required this.username,
      @required this.userpic,
      @required this.userStatus});
}

class Post {
  dynamic userPic;
  final String postID;
  final String userName;
  final Uint8List postPic;
  final String caption;
  final String date;
  final bool liked;
  bool accountStatus;
  int likes;

  Post(
      {@required this.postID,
      @required this.userPic,
      @required this.userName,
      @required this.postPic,
      @required this.date,
      @required this.likes,
      this.accountStatus,
      this.liked,
      this.caption});
}

class Pet {
  dynamic petPic;
  final String petID;
  final String petName;
  final String petAge;
  final String petSex;
  final String petBreed;
  final String petNeeds;
  final String petCharacteristics;
  final String petMedHis;
  final String petOthers;

  Pet(
      {@required this.petID,
      @required this.petPic,
      @required this.petName,
      @required this.petAge,
      @required this.petSex,
      @required this.petBreed,
      @required this.petNeeds,
      @required this.petCharacteristics,
      @required this.petMedHis,
      this.petOthers});
}

class Chat {
  final String name, lastMessage, time;
  dynamic image;
  final bool seen, sentByMe;

  Chat(
      {this.name,
      this.lastMessage,
      this.image,
      this.time,
      this.seen,
      this.sentByMe});
}

class UserDetails {
  final String fullName;
  final dynamic image;
  final String accountType;
  final bool accountStatus;
  UserDetails(
      {this.fullName, this.image, this.accountStatus, this.accountType});
}

enum ChatMessageType { text, audio, image, video }
enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage(
      {this.text,
      @required this.messageType,
      @required this.messageStatus,
      @required this.isSender});
}
