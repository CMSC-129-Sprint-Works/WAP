import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/profilepage.dart';

import 'classtype.dart';

class EditPetProfilePage extends StatefulWidget {
  final Pet pet;
  const EditPetProfilePage({@required this.pet});
  @override
  _EditPetProfilePageState createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _petnameController = TextEditingController();
  TextEditingController _breedController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _medhisController = TextEditingController();
  TextEditingController _needsController = TextEditingController();
  TextEditingController _characteristicsController = TextEditingController();
  TextEditingController _othersController = TextEditingController();

  final _key = GlobalKey<FormState>();
  var fileName;

  File _imageFile;
  final picker = ImagePicker();
  PickedFile image;

  @override
  void initState() {
    _petnameController = TextEditingController(text: widget.pet.petName);
    _breedController = TextEditingController(text: widget.pet.petBreed);
    _ageController = TextEditingController(text: widget.pet.petAge);
    _sexController = TextEditingController(text: widget.pet.petSex);
    _medhisController = TextEditingController(text: widget.pet.petMedHis);
    _needsController = TextEditingController(text: widget.pet.petNeeds);
    _characteristicsController =
        TextEditingController(text: widget.pet.petCharacteristics);
    _othersController =
        TextEditingController(text: widget.pet.petCharacteristics);
    super.initState();
  }

  uploadImage(BuildContext context) async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        widget.pet.petPic = FileImage(_imageFile);
        fileName = widget.pet.petID;
      } else {}
    });
  }

  updatePicture() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Pet Profile Pictures/$fileName");
    final UploadTask uploadTask = storageReference.putFile(_imageFile);
  }

  updatePetProfile() async {
    if (_imageFile != null) {
      await updatePicture().then((value) async {
        await DatabaseService(uid: auth.currentUser.uid)
            .updatePetProfile(
                widget.pet.petID,
                _petnameController.text,
                _breedController.text,
                _ageController.text,
                _sexController.text,
                _medhisController.text,
                _needsController.text,
                _characteristicsController.text,
                _othersController.text)
            .then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        });
      });
    } else {
      await DatabaseService(uid: auth.currentUser.uid)
          .updatePetProfile(
              widget.pet.petID,
              _petnameController.text,
              _breedController.text,
              _ageController.text,
              _sexController.text,
              _medhisController.text,
              _needsController.text,
              _characteristicsController.text,
              _othersController.text)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Edit Pet Profile",
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
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.8,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Pet Profile Picture",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.teal,
                              ),
                              onPressed: () async {
                                await uploadImage(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          backgroundColor: Colors.teal[200],
                          radius: 60,
                          backgroundImage:
                              MemoryImage(widget.pet.petPic) //GET FROM DB
                          ),
                    ),
                  ],
                ),
                Container(
                  width: size.width * 0.8,
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        "Pet Details",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => buildForm()));
                        },
                      ),
                    ),
                  ]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 450,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 5),
                                child: Icon(Icons.pets_outlined),
                              ),
                              Expanded(
                                  child: Container(
                                      child: Text(
                                "About Me",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline,
                                ),
                              )))
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Name: " + widget.pet.petName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Breed: " + widget.pet.petBreed,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Age: " + widget.pet.petAge,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Sex: " + widget.pet.petSex,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Medical History: " + widget.pet.petMedHis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, top: 15, right: 5),
                                child: Icon(Icons.pets_outlined),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "Special Needs",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                          decoration: TextDecoration.underline,
                                        ),
                                      ))),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: 5,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.pet.petNeeds,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, top: 15, right: 5),
                                child: Icon(Icons.pets_outlined),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "Characteristics",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                          decoration: TextDecoration.underline,
                                        ),
                                      )))
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: 5,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.pet.petCharacteristics,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, top: 15, right: 5),
                                child: Icon(Icons.pets_outlined),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "Short Description",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                          decoration: TextDecoration.underline,
                                        ),
                                      )))
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: 5,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.pet.petOthers,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                              )),
                          SizedBox(height: 30),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: MaterialButton(
                                  onPressed: () async {
                                    await updatePetProfile();
                                  },
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.teal[400],
                                  child: Center(
                                    child: Text(
                                      'Update',
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
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  buildForm() {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Edit Pet Details',
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
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _key,
                  child: Column(children: <Widget>[
                    TextFormField(
                      //Pet Name
                      controller: _petnameController,
                      validator: (value) {
                        if (value.length > 64) {
                          return "Character limit reached (32 characters)";
                        } else if (value.isEmpty) {
                          return "This field is required";
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
                        filled: true,
                        hintText: 'Pet Name',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //Breed
                      controller: _breedController,
                      validator: (value) {
                        if (value.length > 32) {
                          return "Character limit reached (32 characters)";
                        } else if (value.isEmpty) {
                          return "This field is required";
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
                        filled: true,
                        hintText: 'Breed',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _ageController,
                      validator: (value) {
                        if (value.length > 32) {
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
                        filled: true,
                        hintText: 'Age',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _sexController,
                      validator: (value) {
                        if (value.length > 60) {
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
                        filled: true,
                        hintText: 'Sex',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _medhisController,
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
                        filled: true,
                        hintText: 'Medical History',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value.length > 64) {
                          return "Character limit reached (64 characters)";
                        } else {
                          return null;
                        }
                      },
                      controller: _needsController,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal[200])),
                        filled: true,
                        hintText: 'Special Needs',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value.length > 64) {
                          return "Character limit reached (64 characters)";
                        } else {
                          return null;
                        }
                      },
                      controller: _characteristicsController,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal[200])),
                        filled: true,
                        hintText: 'Characteristics',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value.length > 62) {
                          return "Character limit reached (64 characters)";
                        } else {
                          return null;
                        }
                      },
                      controller: _othersController,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal[200])),
                        filled: true,
                        hintText: 'Short Description',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.pets_outlined, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: MaterialButton(
                            onPressed: () {
                              if (_key.currentState.validate()) {
                                Navigator.pop(context);
                              }
                            },
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: Colors.teal[400],
                            child: Center(
                              child: Text(
                                'Save Changes',
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
                    ),
                  ]),
                )),
          ],
        ));
  }
}
