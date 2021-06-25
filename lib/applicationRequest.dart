import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/profilepage.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationRequest extends StatefulWidget {
  final String petID;
  final String ownerID;
  final String petName;

  const ApplicationRequest({this.petID, this.ownerID, this.petName});
  @override
  _ApplicationRequestState createState() => _ApplicationRequestState();
}

class _ApplicationRequestState extends State<ApplicationRequest> {
  ScrollController controller = ScrollController();
  TextEditingController messageControl = TextEditingController();
  int fetchLimit = 20;
  int prevCount = 0;
  int selectedIndex = 0;
  int _selectedIndex = 3;
  bool isLoading = true;
  bool showSticker = false;
  dynamic petPic = AssetImage('assets/images/defaultPic.png');
  dynamic ownerPic = AssetImage('assets/images/defaultPic.png');
  String userName;
  String userUsername;
  String un = "WAP USER";
  String thisname = "WAP USER";
  String firstname = "WAP";
  String lastname = "USER";
  final FirebaseAuth auth = FirebaseAuth.instance;

  dynamic chatroomID;
  String messageID = "";
  String myFirstName, myLastName, myUserName;
  String username1 = " ";
  Stream messageStream;
  String applicationStatus = " ";

  ReceivePort receivePort = ReceivePort();
  var _messageFile;
  FilePickerResult file;
  String filename;
  String _localPath;
  bool uploading = false;

  initState() {
    if (!mounted) {
      return;
    }
    onLaunch();
    getUserData().then((value) {
      DatabaseService().deleteUnsentMessages(chatroomID);
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});

    super.initState();
  }

  onLaunch() async {
    await getMyData();
    await getAndSetMessages();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "Downloads");
    try {
      await FlutterDownloader.initialize(debug: false);
    } catch (e) {
      print(e.toString());
    }
  }

  getChatRoomID(String u1, String u2) {
    String petid = widget.petID;
    if (u1.substring(0, 1).codeUnitAt(0) > u2.substring(0, 1).codeUnitAt(0)) {
      return "$u2\_$u1\_$petid";
    } else {
      return "$u1\_$u2\_$petid";
    }
  }

  getMyData() async {
    dynamic holder =
        await DatabaseService(uid: widget.ownerID.toString()).getUsername();
    username1 = holder.toString();
    myUserName = await DatabaseService(uid: auth.currentUser.uid).getUsername();
    chatroomID = await getChatRoomID(username1, myUserName);
    petPic = MemoryImage(await DatabaseService().getPetPhoto(widget.petID));
    ownerPic = await DatabaseService(uid: widget.ownerID).getPicture();
    applicationStatus =
        await DatabaseService().getApplicationStatus(chatroomID);
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    un = await DatabaseService(uid: auth.currentUser.uid).getUsername();
    thisname = await DatabaseService(uid: auth.currentUser.uid).getName();
  }

  getAndSetMessages() async {
    Stream temp =
        await DatabaseService().getChatRoomMessages2(chatroomID, fetchLimit);
    setState(() {
      messageStream = temp;
    });
  }

  initializeDownloader() async {
    await getPermission();
    FlutterDownloader.registerCallback(downloadCallback);
    await _prepareSaveDir();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('Downloads');
    send.send([id, status, progress]);
  }

  getPermission() async {
    if (!(await Permission.storage.status.isGranted)) {
      Permission.storage.request();
    }
  }

  Future<void> _prepareSaveDir() async {
    String dir = (await _findLocalPath());
    setState(() {
      _localPath = dir + Platform.pathSeparator + 'Media Files';
    });
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();

    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();

    if (directory == null) {
      return null;
    }
    return directory.path;
  }

  downloadFile(String url) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  uploadFile(BuildContext context) async {
    file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg']);
    setState(() {
      if (file != null) {
        _messageFile = File(file.files.single.path);
        _messageFile = _messageFile.readAsBytesSync();
        filename = file.paths.first.split('/').last;
      }
    });
  }

  addMessageFile() async {
    messageID = randomAlphaNumeric(12);

    String storedFilename = messageID + "_" + filename;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Message Files/$storedFilename");
    setState(() {
      uploading = true;
    });
    final uploadTask =
        await storageReference.putData(_messageFile).whenComplete(() => {
              setState(() {
                _messageFile = null;
                file = null;
                uploading = false;
              })
            });
    String downloadURL = await uploadTask.ref.getDownloadURL();

    var lastMessageTs = DateTime.now();
    Map<String, dynamic> messageInfoMap = {
      "messageType": "file",
      "file name": filename,
      "message": downloadURL,
      "sentBy": myUserName,
      "ts": lastMessageTs,
      "message status": true,
    };
    await DatabaseService()
        .addMessage2(chatroomID, messageID, messageInfoMap)
        .then((value) {
      Map<String, dynamic> lastMessageInfoMap = {
        "lastMessageSeen": false,
        "lastMessage": "user sent a file message.",
        "lastMessageSendTs": lastMessageTs,
        "lastMessageSentby": myUserName,
      };
      DatabaseService().updateLastMessageSent2(chatroomID, lastMessageInfoMap);
    });
  }

  addMessage(bool sendClicked) async {
    if (messageControl.text != "") {
      String message = messageControl.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "messageType": 'text',
        "message": message,
        "sentBy": myUserName,
        "ts": lastMessageTs,
        "message status": sendClicked,
      };

      if (messageID == "") {
        messageID = randomAlphaNumeric(12);
      }

      DatabaseService()
          .addMessage2(chatroomID, messageID, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessageSeen": false,
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSentby": myUserName,
        };

        if (sendClicked == true) {
          DatabaseService()
              .updateLastMessageSent2(chatroomID, lastMessageInfoMap);
        }
      });
    }
    if (sendClicked == true) {
      messageControl.text = "";
      messageID = "";
    }
  }

  checkMsg() async {
    if (messageID != "") {
      DatabaseService().messageStatusChecker2(chatroomID, messageID);
    }
  }

  updateApplicationStatus(bool status) async {
    if (status == true) {
      return await DatabaseService().updateApplicationStatus(chatroomID, true);
    } else {
      return await DatabaseService().updateApplicationStatus(chatroomID, false);
    }
  }

  cancelApplication() async {
    return await DatabaseService().cancelApplication(chatroomID);
  }

  Widget chatMessageTile(
      String messageType,
      String messFilename,
      String message,
      bool sentByMe,
      bool sent,
      bool sameSender,
      bool start,
      String timeStamp) {
    return FutureBuilder(
        future: DatabaseService().getConvoStatus2(myUserName, chatroomID),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return !sent
                ? !sentByMe
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("Other user is typing..."))
                    : Container()
                : Column(children: [
                    sentByMe
                        ? Container(
                            padding: EdgeInsets.only(right: 20),
                            alignment: Alignment.topRight,
                            child: Text(
                              timeStamp,
                              style: TextStyle(fontSize: 10),
                            ))
                        : Container(
                            padding: EdgeInsets.only(left: 70),
                            alignment: Alignment.topLeft,
                            child: Text(
                              timeStamp,
                              style: TextStyle(fontSize: 10),
                            )),
                    Row(
                      mainAxisAlignment: sentByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        !sentByMe
                            ? sameSender
                                ? Container(
                                    padding: EdgeInsets.only(left: 60),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: CircleAvatar(
                                      backgroundImage: ownerPic,
                                    ))
                            : Container(),
                        Flexible(
                          child: Container(
                              margin: sentByMe
                                  ? EdgeInsets.only(
                                      left: 150, right: 20, top: 2, bottom: 6)
                                  : EdgeInsets.only(
                                      right: 150, left: 10, top: 2, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: sentByMe
                                        ? Radius.circular(18)
                                        : Radius.circular(0),
                                    topRight: Radius.circular(18),
                                    bottomRight: sentByMe
                                        ? Radius.circular(0)
                                        : Radius.circular(18)),
                                color: sentByMe
                                    ? Colors.teal[300]
                                    : Colors.grey[350],
                              ),
                              padding: EdgeInsets.all(10),
                              child: messageType == "text"
                                  ? Text(
                                      message,
                                      style: TextStyle(
                                          color: sentByMe
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  : InkWell(
                                      radius: 10,
                                      highlightColor: Colors.yellow,
                                      onTap: () async {
                                        await initializeDownloader();
                                        await downloadFile(message);
                                      },
                                      child: Text(
                                        messFilename,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: sentByMe
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !sentByMe
                            ? Container()
                            : !start
                                ? Container()
                                : snapshot.data == true
                                    ? Container(
                                        padding: EdgeInsets.only(right: 10),
                                        alignment: Alignment.bottomRight,
                                        child: Text("Seen"))
                                    : Container(
                                        padding: EdgeInsets.only(right: 10),
                                        alignment: Alignment.bottomRight,
                                        child: Text("Sent"))
                      ],
                    ),
                  ]);
          } else {
            return !sent
                ? !sentByMe
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("Other user is typing..."))
                    : Container()
                : Column(children: [
                    sentByMe
                        ? Container(
                            padding: EdgeInsets.only(right: 20),
                            alignment: Alignment.topRight,
                            child: Text(
                              timeStamp,
                              style: TextStyle(fontSize: 10),
                            ))
                        : Container(
                            padding: EdgeInsets.only(left: 70),
                            alignment: Alignment.topLeft,
                            child: Text(
                              timeStamp,
                              style: TextStyle(fontSize: 10),
                            )),
                    Row(
                      mainAxisAlignment: sentByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        !sentByMe
                            ? sameSender
                                ? Container(
                                    padding: EdgeInsets.only(left: 60),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: CircleAvatar(
                                      backgroundImage: ownerPic,
                                    ))
                            : Container(),
                        Flexible(
                          child: Container(
                              margin: sentByMe
                                  ? EdgeInsets.only(
                                      left: 150, right: 20, top: 2, bottom: 6)
                                  : EdgeInsets.only(
                                      right: 150, left: 10, top: 2, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: sentByMe
                                        ? Radius.circular(18)
                                        : Radius.circular(0),
                                    topRight: Radius.circular(18),
                                    bottomRight: sentByMe
                                        ? Radius.circular(0)
                                        : Radius.circular(18)),
                                color: sentByMe
                                    ? Colors.teal[300]
                                    : Colors.grey[350],
                              ),
                              padding: EdgeInsets.all(10),
                              child: messageType == "text"
                                  ? Text(
                                      message,
                                      style: TextStyle(
                                          color: sentByMe
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  : InkWell(
                                      radius: 10,
                                      highlightColor: Colors.yellow,
                                      onTap: () async {
                                        await initializeDownloader();
                                        await downloadFile(message);
                                      },
                                      child: Text(
                                        messFilename,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: sentByMe
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                        ),
                      ],
                    ),
                    !sentByMe
                        ? Container()
                        : !start
                            ? Container()
                            : Container(
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.bottomRight,
                                child: Text("Sent"))
                  ]);
          }
        });
  }

  Widget chatMessages() {
    return Expanded(
        child: StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                itemCount: snapshot.data.docs.length >= 20
                    ? snapshot.data.docs.length + 1
                    : snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  if (index == snapshot.data.docs.length) {
                    if (prevCount == snapshot.data.docs.length) {
                      return Container();
                    } else {
                      return Container(
                        color: Colors.teal[100],
                        child: TextButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.teal[500]),
                          ),
                          onPressed: () async {
                            setState(() {
                              fetchLimit = fetchLimit + 20;
                              prevCount = snapshot.data.docs.length;
                            });
                            await getAndSetMessages();
                          },
                        ),
                      );
                    }
                  } else {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    String formattedDate =
                        DateFormat.yMd().format(ds["ts"].toDate());
                    String formattedTime =
                        DateFormat("h:mma").format(ds["ts"].toDate());
                    return index == snapshot.data.docs.length - 1
                        ? chatMessageTile(
                            ds["messageType"],
                            ds["messageType"] != "text" ? ds["file name"] : "",
                            ds["message"],
                            myUserName == ds["sentBy"],
                            ds["message status"],
                            false,
                            index == 0,
                            formattedDate + " " + formattedTime)
                        : chatMessageTile(
                            ds["messageType"],
                            ds["messageType"] != "text" ? ds["file name"] : "",
                            ds["message"],
                            myUserName == ds["sentBy"],
                            ds["message status"],
                            snapshot.data.docs[index + 1]["sentBy"] ==
                                ds["sentBy"],
                            index == 0,
                            formattedDate + " " + formattedTime);
                  }
                })
            : Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.teal[900])));
      },
    ));
  }

  handleClick(String click) {
    switch (click) {
      case "Accept Request":
        {
          createAdoptionAccept(context);
        }
        break;

      case "Deny Request":
        {
          createAdoptionDeny(context);
        }
        break;

      case "Cancel Application":
        {
          createAdoptionCancel(context);
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        actions: <Widget>[
          applicationStatus == "Pending"
              ? PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    if (widget.ownerID == auth.currentUser.uid) {
                      return {'Accept Request', 'Deny Request'}
                          .map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    } else {
                      return {'Cancel Application'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    }
                  },
                )
              : SizedBox()
        ],
        title: Row(
          children: [
            BackButton(
              onPressed: () async {
                await checkMsg();
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage: ownerPic,
            ),
            SizedBox(width: 10),
            Text(username1,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16)),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.teal[100], Colors.teal],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 15,
            ),
            height: size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: size.height * 0.04,
                    backgroundImage: petPic,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.petName,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(widget.petID,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Montserrat',
                              fontSize: 13)),
                      SizedBox(height: 5),
                      Text(applicationStatus,
                          style: TextStyle(
                              color: applicationStatus == "Accepted"
                                  ? Colors.green
                                  : Colors.red[400],
                              fontFamily: 'Montserrat',
                              fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          chatMessages(),
          showSticker ? buildSticker() : Container(),
          _messageFile != null
              ? Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: BoxDecoration(color: Colors.teal[50], boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 30,
                        color: Colors.grey[300])
                  ]),
                  child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(children: [
                        Icon(
                          Icons.file_copy,
                          color: Colors.teal[900],
                        ),
                        Expanded(
                            child: Text(filename,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'))),
                        uploading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal[900]))
                            : IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.teal[900],
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _messageFile = null;
                                    file = null;
                                  });
                                },
                              ),
                      ])))
              : SizedBox(),
          Container(
            height: size.height * 0.08,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.teal[100], Colors.teal],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 30,
                      color: Colors.teal[300])
                ]),
            child: SafeArea(
                child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.attach_file_outlined),
                    onPressed: () async {
                      await uploadFile(context);
                    }),
                Expanded(
                    child: Container(
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white70),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.sentiment_satisfied_alt_outlined),
                          onPressed: () async {
                            setState(() {
                              showSticker = !showSticker;
                            });
                          }),
                      Expanded(
                          child: TextFormField(
                        controller: messageControl,
                        onEditingComplete: () async {
                          await checkMsg();
                        },
                        onChanged: (value) {
                          addMessage(false); //typing indicator
                        },
                        onFieldSubmitted: (value) {
                          addMessage(true);
                        },
                        decoration: InputDecoration(
                            hintText: "Type Message", border: InputBorder.none),
                      )),
                      IconButton(
                          icon: Icon(Icons.send_outlined),
                          onPressed: () async {
                            if (uploading != true) {
                              _messageFile != null
                                  ? await addMessageFile()
                                  : await addMessage(true);
                            }
                          })
                    ],
                  ),
                ))
              ],
            )),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.teal,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        setState(() {
          messageControl.text = messageControl.text + emoji.emoji;
          messageControl.selection = TextSelection.fromPosition(
              TextPosition(offset: messageControl.text.length));
        });
      },
    );
  }

  createAdoptionAccept(BuildContext context) {
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
                            Text(
                                "Do you want to accept this adoption application? The pet profile will automatically be deleted after this.",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Yes",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () async {
                                      await updateApplicationStatus(true);
                                    }),
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("No",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            )
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
                                  Image.asset('assets/images/sucessPost.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  createAdoptionDeny(BuildContext context) {
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
                            Text(
                                "Do you want to deny this adoption application?",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Yes",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () async {
                                      await updateApplicationStatus(false);
                                    }),
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("No",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            )
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
                              child: Image.asset('assets/images/haha.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  createAdoptionCancel(BuildContext context) {
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
                            Text(
                                "Do you want to cancel this adoption application?",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Yes",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () async {
                                      await cancelApplication();
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ApplicationRequest(
                                                    ownerID: widget.ownerID,
                                                    petID: widget.petID,
                                                    petName: widget.petName,
                                                  )));
                                    }),
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("No",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            )
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
                              child: Image.asset('assets/images/haha.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        break;
      case 1:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        }
        break;
      case 2:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
        break;
      case 3:
        {}
        break;
      case 4:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        }
        break;
    }
  }
}
