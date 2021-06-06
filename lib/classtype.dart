import 'dart:typed_data';
import 'package:flutter/material.dart';

class Post {
  dynamic userPic;
  final String userName;
  final Uint8List postPic;
  final String caption;

  Post(
      {@required this.userPic,
      @required this.userName,
      @required this.postPic,
      this.caption});
}

class Pet {
  Uint8List petPic;
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
