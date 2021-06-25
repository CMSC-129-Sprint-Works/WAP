import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wap/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wap/home_page.dart';
import 'package:wap/profilepage.dart';

class AddPostPage extends StatefulWidget {
  final bool homePage;
  const AddPostPage(this.homePage);
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController _captionController = TextEditingController();
  bool imageSelected = false;
  bool isShowSticker = false;
  int postNum;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  String fileName;
  File _imageFile;
  PickedFile image;
  String thisname = "WAP USER";
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  bool uploading = false;
  bool successUpload = false;
  bool accountStatus;
  String accountType;

  var uploadTask;

  initState() {
    if (!mounted) {
      return;
    }
    getUserData();
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    dbGet.getUserPostsCount().then((value) {
      setState(() {
        postNum = value + 1;
      });
    });

    super.initState();
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    final User user = auth.currentUser;
    final dbGet = DatabaseService(uid: user.uid);
    thisname = await dbGet.getName();
    accountType = await dbGet.getAccountType();
    accountStatus = await dbGet.getAccountStatus();
    pic = await DatabaseService(uid: user.uid).getPicture();
  }

  getImageGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        fileName = auth.currentUser.uid;
        imageSelected = true;
      }
    });
  }

  getImageCamera() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        fileName = auth.currentUser.uid;
        imageSelected = true;
      }
    });
  }

  Future updateProfile() async {
    final dbGet = DatabaseService(uid: auth.currentUser.uid);

    if (_imageFile != null) {
      String uniqueID = _imageFile.path.split('/').last;
      uniqueID = uniqueID.substring(0, uniqueID.indexOf('.'));
      var storageReference =
          FirebaseStorage.instance.ref().child("User Posts/$uniqueID");
      uploadTask = storageReference.putFile(_imageFile).whenComplete(() => {
            dbGet.addPost(_captionController.text, uniqueID),
            successUpload = true,
            showDialogDone()
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 1,
        title: Text(
          "Add Post",
          key: Key('addPost'),
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
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(children: [
                  new Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 5),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: pic,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              thisname,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(width: 5),
                            accountType == "institution" &&
                                    accountStatus == true
                                ? Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Image.asset(
                                        "assets/images/verified.png",
                                        height: 20,
                                        matchTextDirection: true,
                                        fit: BoxFit.fill,
                                      ),
                                    ))
                                : SizedBox(width: 1)
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              SizedBox(height: 10),
              buildForm(),
              (isShowSticker
                  ? Padding(
                      padding: EdgeInsets.only(top: 2), child: buildSticker())
                  : Container()),
              _imageFile != null
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Image.file(
                        _imageFile,
                        matchTextDirection: true,
                        fit: BoxFit.fill,
                      ))
                  : SizedBox(
                      height: 1,
                    ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.photo,
                          color: Colors.teal,
                        ),
                        onPressed: () async {
                          await getImageGallery();
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.teal,
                        ),
                        onPressed: () async {
                          await getImageCamera();
                        }),
                    IconButton(
                        icon: Icon(Icons.tag_faces, color: Colors.teal),
                        onPressed: () {
                          setState(() {
                            isShowSticker = !isShowSticker;
                          });
                        })
                  ],
                ),
              ),
              !uploading
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: MaterialButton(
                            onPressed: () async {
                              if (imageSelected == true) {
                                updateProfile();
                                setState(() {
                                  uploading = true;
                                });
                              } else {
                                final snackBar = SnackBar(
                                    backgroundColor: Colors.teal,
                                    content:
                                        Text("No photo selected for post."));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: Colors.teal[400],
                            child: Center(
                              child: Text(
                                'Upload Post',
                                key: Key('uploadPost'),
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
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: MaterialButton(
                            onPressed: () {},
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
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
        ],
      ),
    );
  }

  Widget buildForm() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                child: Column(children: <Widget>[
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key('caption'),
                    maxLength: 60,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    autofocus: true,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.words,
                    controller: _captionController,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.teal)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.teal)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Care for a caption?',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                  ),
                ]),
              ))
        ]);
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        setState(() {
          _captionController.text = _captionController.text + emoji.emoji;
          _captionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _captionController.text.length));
        });
      },
    );
  }

  showDialogDone() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SingleChildScrollView(
              child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            successUpload
                                ? Text("Successfully uploaded post.",
                                    style: TextStyle(fontFamily: 'Montserrat'))
                                : Text(
                                    "Failed to upload post. Please check your connection and try again.",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Ok",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.homePage
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()));
                                })
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 55,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child:
                                  Image.asset('assets/images/successPost.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }
}
