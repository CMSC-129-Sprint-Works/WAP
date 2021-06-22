import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/profilepage.dart';
import 'package:intl/intl.dart';

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

  initState() {
    if (!mounted) {
      return;
    }
    DatabaseService().deleteUnsentMessages2(chatroomID);
    getUserData().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
    onLaunch();
    getUserData().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
    super.initState();
  }

  addMessage(bool sendClicked) async {
    if (messageControl.text != "") {
      String message = messageControl.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
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

  getAndSetMessages() async {
    messageStream =
        await DatabaseService().getChatRoomMessages2(chatroomID, fetchLimit);
    setState(() {});
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
    SharedPreferences shared = await SharedPreferences.getInstance();
    myFirstName = shared.getString('firstname');
    myLastName = shared.getString('lastname');
    myUserName = shared.getString('username');

    final dbGet = DatabaseService(uid: widget.ownerID.toString());
    dynamic holder = await dbGet.getUsername();
    username1 = holder.toString();
    chatroomID = await getChatRoomID(username1, myUserName);

    petPic = MemoryImage(await DatabaseService().getPetPhoto(widget.petID));
    var temp = await DatabaseService(uid: widget.ownerID).getPicture();
    if (temp != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        ownerPic = temp;
      });
    }
    applicationStatus =
        await DatabaseService().getApplicationStatus(chatroomID);
  }

  onLaunch() async {
    await getMyData();
    getAndSetMessages();
  }

  checkMsg() async {
    if (messageID != "") {
      DatabaseService().messageStatusChecker2(chatroomID, messageID);
    }
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    final User user = auth.currentUser;
    final dbGet = DatabaseService(uid: user.uid);
    dynamic uname = await dbGet.getUsername();
    dynamic name1 = await dbGet.getName();
    if (name1 == null) {
      name1 = await dbGet.getName2();
      thisname = name1;
    } else {
      thisname = name1;
    }

    setState(() {
      un = uname;
    });
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

  Widget chatMessageTile(String message, bool sentByMe, bool sent,
      bool sameSender, bool start, String timeStamp) {
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
                              child: Text(
                                message,
                                style: TextStyle(
                                    color:
                                        sentByMe ? Colors.white : Colors.black),
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
                              child: Text(
                                message,
                                style: TextStyle(
                                    color:
                                        sentByMe ? Colors.white : Colors.black),
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
                            ds["message"],
                            myUserName == ds["sentBy"],
                            ds["message status"],
                            false,
                            index == 0,
                            formattedDate + " " + formattedTime)
                        : chatMessageTile(
                            ds["message"],
                            myUserName == ds["sentBy"],
                            ds["message status"],
                            snapshot.data.docs[index + 1]["sentBy"] ==
                                ds["sentBy"],
                            index == 0,
                            formattedDate + " " + formattedTime);
                  }
                })
            : Center(child: CircularProgressIndicator());
      },
    ));
  }

  handleClick(String click) {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Accept Request', 'Deny Request', 'Delete Conversation'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
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
                              color: Colors.red[400],
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
                    icon: Icon(Icons.attach_file_outlined), onPressed: () {}),
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
                            addMessage(true);
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
}
