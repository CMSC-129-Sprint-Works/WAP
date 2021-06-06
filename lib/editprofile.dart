import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:wap/profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  dynamic pic;
  String firstName;
  String lastName;
  String bio;
  String address;
  String nickname;
  String contactNum;
  EditProfile(this.pic, this.firstName, this.lastName, this.bio, this.address,
      this.nickname, this.contactNum);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  final _key = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  var fileName = "Upload Profile Picture";
  double _progress;

  File _imageFile;
  PickedFile image;

  initState() {
    super.initState();
    _firstnameController =
        TextEditingController(text: widget.firstName.toString());
    _lastnameController =
        TextEditingController(text: widget.lastName.toString());
    _bioController = TextEditingController(text: widget.bio.toString());
    _addressController = TextEditingController(text: widget.address.toString());
    _nicknameController =
        TextEditingController(text: widget.nickname.toString());
    _numberController =
        TextEditingController(text: widget.contactNum.toString());
  }

  uploadImage(BuildContext context) async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        widget.pic = FileImage(_imageFile);
        fileName = auth.currentUser.uid;
      } else {}
    });
  }

  updatePicture() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Profile Pictures/$fileName");
    final UploadTask uploadTask = storageReference.putFile(_imageFile);
    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });
    });
    print(_progress);
  }

  updateProfile(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;

    if (_imageFile != null) {
      await updatePicture().then((value) async {
        await DatabaseService(uid: user.uid)
            .updateProfile1(
                _firstnameController.text,
                _lastnameController.text,
                _bioController.text,
                _nicknameController.text,
                _addressController.text,
                _numberController.text)
            .then((value) => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()))
                });
      });
    } else {
      await DatabaseService(uid: user.uid)
          .updateProfile1(
              _firstnameController.text,
              _lastnameController.text,
              _bioController.text,
              _nicknameController.text,
              _addressController.text,
              _numberController.text)
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()))
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to edit profile pic, name, username, and bio
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.teal[500],
            fontFamily: 'Montserrat',
          ),
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
                        Expanded(
                          child: Text(
                            "Profile Picture",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 190),
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
                        backgroundImage: widget.pic //GET FROM DB
                        ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "Public Details",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 190),
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
                              child: Icon(Icons.person),
                            ),
                            Expanded(
                                child: Container(
                                    child: Text(
                              "Names",
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
                                  "First: " + widget.firstName,
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
                                  "Last: " + widget.lastName,
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
                                  "Other Name: " + widget.nickname,
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
                              margin:
                                  EdgeInsets.only(left: 20, top: 15, right: 5),
                              child: Icon(Icons.contact_page),
                            ),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Contact Information",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))),
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
                                  "Address: " + widget.address,
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
                                  "Phone Number: " + widget.contactNum,
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
                              margin:
                                  EdgeInsets.only(left: 20, top: 15, right: 5),
                              child: Icon(Icons.article),
                            ),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Bio",
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
                              widget.bio,
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
                                onPressed: () {
                                  updateProfile(context);
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
        ],
      )),
    );
  }

  buildForm() {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.teal[100],
          centerTitle: true,
          title: Text(
            'Edit Public Details',
            style: TextStyle(
              color: Colors.teal[500],
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _key,
                  child: Column(children: <Widget>[
                    TextFormField(
                      //FirstName
                      controller: _firstnameController,
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
                        // fillColor: Colors.teal[200],
                        filled: true,
                        // hintText: 'First Name',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //LastName
                      controller: _lastnameController,
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
                        hintText: 'Last Name',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _bioController,
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
                        filled: true,
                        hintText: 'Bio',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.article_rounded, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nicknameController,
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
                        filled: true,
                        hintText: 'Nickname',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.person_rounded, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
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
                        hintText: 'Address',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon:
                            Icon(Icons.home_rounded, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        return validateMobile(value);
                      },
                      controller: _numberController,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal[200])),
                        filled: true,
                        hintText: 'Contact Number',
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: 'Montserrat'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        prefixIcon: Icon(Icons.contact_phone_rounded,
                            color: Colors.teal),
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

String validateMobile(String value) {
  String patttern = r'(^09[0-9]{9}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return null;
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid 11 digit mobile number';
  }
  return null;
}
