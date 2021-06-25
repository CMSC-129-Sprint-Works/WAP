import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wap/database.dart';
import 'package:wap/profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SetupPetProfile extends StatefulWidget {
  @override
  _SetupPetProfileState createState() => _SetupPetProfileState();
}

class _SetupPetProfileState extends State<SetupPetProfile> {
  TextEditingController _petnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _breedController = TextEditingController();
  TextEditingController _needsController = TextEditingController();
  TextEditingController _othersController = TextEditingController();
  TextEditingController _characteristicsController = TextEditingController();
  TextEditingController _medhisController = TextEditingController();

  final _key = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  var fileName = "Upload Profile Picture";
  dynamic pic = AssetImage('assets/images/confused.png');
  bool uploading = false;

  File _imageFile;
  PickedFile image;

  initState() {
    super.initState();
  }

  uploadImage(BuildContext context) async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        pic = FileImage(_imageFile);
        fileName = auth.currentUser.uid;
      } else {}
    });
  }

  addPicture(var namefile) async {
    fileName = namefile;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Pet Profile Pictures/$fileName");
    await storageReference.putFile(_imageFile).whenComplete(() => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ProfilePage()))
        });
  }

  Future createPet() async {
    User user = auth.currentUser;
    final db = DatabaseService(uid: user.uid);
    String temp;

    temp = await db.addPet(
        _petnameController.text,
        _ageController.text,
        _sexController.text,
        _breedController.text,
        _needsController.text,
        _othersController.text,
        _characteristicsController.text,
        _medhisController.text);

    if (_imageFile != null) {
      await addPicture(temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to add pet name, ages, sex, breed, characteristics
      //medical history, special needs, and other important info about the pet
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 1,
        title: Text(
          "Setup Pet Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.teal[100], Colors.teal],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Column(
            //alignment: Alignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 30, top: 30),
                    child: Row(
                      children: [
                        Text(
                          "Pet Profile Picture",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(left: 10),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            await uploadImage(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: pic, fit: BoxFit.contain),
                      border: Border.all(
                        color: Colors.teal[100],
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                child: Row(children: [
                  Text(
                    "Pet Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 580,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildForm(),
                        SizedBox(height: 30),
                        !uploading
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (_key.currentState.validate()) {
                                          if (_imageFile != null) {
                                            setState(() {
                                              createPet();
                                              uploading = true;
                                            });
                                          }
                                        }
                                      },
                                      minWidth: double.infinity,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      color: Colors.teal[400],
                                      child: Center(
                                        child: Text(
                                          'Upload Pet Profile',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: MaterialButton(
                                      onPressed: () async {},
                                      minWidth: double.infinity,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      color: Colors.teal[400],
                                      child: Center(
                                          child: SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 20.0,
                                      )),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              key: _key,
              child: Column(children: <Widget>[
                TextFormField(
                  //PetName
                  controller: _petnameController,
                  validator: (value) {
                    if (value.length > 64) {
                      return "Character limit reached (64 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Pet Name',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //Age
                  controller: _ageController,
                  validator: (value) {
                    if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Age',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //sex
                  controller: _sexController,
                  validator: (value) {
                    if (value.length > 60) {
                      return "Character limit reached (60 characters)";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Sex',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //breed
                  controller: _breedController,
                  validator: (value) {
                    if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Breed',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //characteristics
                  controller: _characteristicsController,
                  validator: (value) {
                    if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Characteristics',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //medical history
                  controller: _medhisController,
                  validator: (value) {
                    if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Medical History',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //special needs
                  controller: _needsController,
                  validator: (value) {
                    if (value.length > 64) {
                      return "Character limit reached (64 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Special Needs',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //other description
                  controller: _othersController,
                  validator: (value) {
                    if (value.length > 64) {
                      return "Character limit reached (64 characters)";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[200],
                    filled: true,
                    hintText: 'Short Description',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.pets, color: Colors.white),
                  ),
                ),
              ]),
            )),
      ],
    );
  }
}