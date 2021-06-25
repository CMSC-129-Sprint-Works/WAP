import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wap/database.dart';
import 'package:wap/profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class EditInstiProfile extends StatefulWidget {
  dynamic pic;
  bool accountStatus;
  String instiname;
  String bio;
  String address;
  String nickname;
  String contactNum;
  EditInstiProfile(this.accountStatus, this.pic, this.instiname, this.bio,
      this.address, this.nickname, this.contactNum);
  @override
  _EditInstiProfileState createState() => _EditInstiProfileState();
}

class _EditInstiProfileState extends State<EditInstiProfile> {
  TextEditingController _instinameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _donateController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  String donationDetails = " ";

  final _key = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  var fileName = "Upload Profile Picture";
  var fileName2 = "Upload Certificate PDF";
  bool uploading = false;

  File _imageFile;
  var _pdfFile;
  PickedFile image;
  FilePickerResult pdf;

  @override
  void initState() {
    _instinameController = TextEditingController(text: widget.instiname);
    _bioController = TextEditingController(text: widget.bio);
    _addressController = TextEditingController(text: widget.address);
    _numberController = TextEditingController(text: widget.contactNum);

    // ignore: unnecessary_statements
    widget.accountStatus == true ? getDonationDetails() : null;
    super.initState();
  }

  getDonationDetails() async {
    String tempDetail =
        await DatabaseService(uid: auth.currentUser.uid).getDonationDetails();
    setState(() {
      donationDetails = tempDetail;
    });

    _donateController = TextEditingController(text: donationDetails);
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

  uploadFile(BuildContext context) async {
    pdf = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    setState(() {
      if (pdf != null) {
        _pdfFile = File(pdf.files.single.path);
        _pdfFile = _pdfFile.readAsBytesSync();
        fileName2 = pdf.paths.first.split('/').last;
      }
    });
  }

  updateFile() async {
    String profID = auth.currentUser.uid;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Certificates/$profID/$fileName2");
    await storageReference.putData(_pdfFile);
  }

  updateProfile(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;

    if (_pdfFile != null) {
      await updateFile();
    }

    if (_imageFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("Profile Pictures/$fileName");
      await storageReference.putFile(_imageFile).whenComplete(() async {
        await DatabaseService(uid: user.uid)
            .updateProfile2(
                _instinameController.text,
                _donateController.text,
                _addressController.text,
                _bioController.text,
                _numberController.text)
            .then((value) => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()))
                });
      });
    } else {
      await DatabaseService(uid: user.uid)
          .updateProfile2(
              _instinameController.text,
              _donateController.text,
              _addressController.text,
              _bioController.text,
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
      //to edit profile pic, name, bio, contact number, address, donation details
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          key: Key('editProfile2'),
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
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Profile Picture",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
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
                    child: Row(
                      children: [
                        Text(
                          "Public Details",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
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
                      ],
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
                              "Name",
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
                              widget.instiname,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                              ),
                            )),
                        SizedBox(height: 5),
                        /* **(start) For verified users only ** */

                        widget.accountStatus == true
                            ? Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, top: 15, right: 5),
                                          child: Icon(Icons.article),
                                        ),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Donation Details",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontFamily: 'Montserrat',
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                )))
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                          donationDetails,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            : Container(),
                        //: SizedBox(height: 0),
                        /* **end For verified users only ** */

                        SizedBox(height: 5),
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
                        SizedBox(height: 5),
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
                                      "Description",
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

                        /* For un-verfified users only*/
                        widget.accountStatus == false
                            ? Column(
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, top: 15, right: 5),
                                        child: Icon(Icons.check_circle),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text(
                                                "Verify your Account",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontFamily: 'Montserrat',
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )))
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        //: SizedBox(height: 0),
                        /* (end) For un-verfified users only*/

                        SizedBox(height: 30),
                        !uploading
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          uploading = true;
                                        });
                                        await updateProfile(context);
                                      },
                                      minWidth: double.infinity,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
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
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: MaterialButton(
                                      onPressed: () {},
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

  Widget buildForm() {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Edit Public Details',
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
                    //Name of Institution
                    controller: _instinameController,
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
                      hintText: 'Institution Name',
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
                      hintText: 'Short Description',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      prefixIcon:
                          Icon(Icons.article_rounded, color: Colors.teal),
                    ),
                  ),
                  SizedBox(height: 10),
                  /* For verified users only*/

                  widget.accountStatus == true
                      ? TextFormField(
                          controller: _donateController,
                          validator: (value) {
                            if (value.length > 210) {
                              return "Character limit reached (210 characters)";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.teal[200])),
                            filled: true,
                            hintText: 'Donation Details',
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'Montserrat'),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            prefixIcon:
                                Icon(Icons.pets_outlined, color: Colors.teal),
                          ),
                        )
                      : Container(),
                  //: SizedBox(height: 0),
                  /* (end) For verified users only */

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
                      prefixIcon: Icon(Icons.home_rounded, color: Colors.teal),
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
                      prefixIcon:
                          Icon(Icons.contact_phone_rounded, color: Colors.teal),
                    ),
                  ),
                  SizedBox(height: 30),
                ]),
              ),
            ),
            /* For un-verified users only */
            widget.accountStatus == false
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Verify your Account",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.teal[100], Colors.teal],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await uploadFile(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(right: 15),
                                      alignment: Alignment.bottomLeft,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(
                                          'assets/images/pdf.png',
                                          matchTextDirection: true,
                                          fit: BoxFit.fill,
                                          height: 45,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                    width: 165,
                                    child: Text(fileName2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat')))
                              ]),
                        ),
                      ],
                    ),
                  )
                : Container(),
            //: SizedBox(height: 0),
            /* (end)  */
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
