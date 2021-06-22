import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/applicationRequest.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/message_convo.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/classtype.dart';
import 'package:wap/profilepage.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  ScrollController controller = ScrollController();
  int selectedIndex = 0;
  int _selectedIndex = 3;
  bool isLoading = true;
  dynamic pic;
  dynamic otherPic = AssetImage('assets/images/defaultPic.png');
  String thisname = "WAP USER";
  String un = "WAP_USER";
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream directMessageStream;
  Stream applicationRequestStream;

  initState() {
    if (!mounted) {
      return;
    }
    getChatrooms();
    getChatrooms2();
    getUserData().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
    super.initState();
  }

  getUserData() async {
    if (!mounted) {
      return;
    }

    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    un = await dbGet.getUsername();
    thisname = await dbGet.getName();
    pic = await DatabaseService(uid: auth.currentUser.uid).getPicture();
  }

  getChatrooms() async {
    directMessageStream =
        await DatabaseService(uid: auth.currentUser.uid).getLastChats();
  }

  getChatrooms2() async {
    applicationRequestStream =
        await DatabaseService(uid: auth.currentUser.uid).getLastChats2();
  }

  getOtherName(dynamic username) async {
    return await DatabaseService(uid: auth.currentUser.uid)
        .getUserID(username.toString());
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Message",
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.teal[100], Colors.teal],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 3,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 28, top: 7),
                              child: CircleAvatar(
                                radius: size.height * 0.05,
                                backgroundImage: pic, //GET FROM DB
                              ),
                            ),
                            Container(
                              width: (size.width - 50) * 0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            thisname,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    //GET FROM DB
                                                    '@' + un,
                                                    //"@username",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Direct",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: Colors.black)),
                                        SizedBox(width: 5),
                                        Text("Messages",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ],
                                    )),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Application",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: Colors.black)),
                                        SizedBox(width: 5),
                                        Text("Requests",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            IndexedStack(
              index: selectedIndex,
              children: [getDirectMessages(size), getAppNotif(size)],
            ),
          ],
        ),
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

  getDirectMessages(size) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10)),
            child: Text("Private Messages",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[50])),
          ),
          StreamBuilder(
            stream: directMessageStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      height: size.height * 0.55,
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            String formattedDate = DateFormat.yMMMd()
                                .format(ds["lastMessageSendTs"].toDate());
                            String formattedTime = DateFormat("h:mma")
                                .format(ds["lastMessageSendTs"].toDate());
                            List users = ds["users"];
                            int inx = users.indexOf(un);
                            inx == 0 ? inx = 1 : inx = 0;
                            return ChatCard(
                                chat: Chat(
                                    seen: ds["lastMessageSeen"],
                                    name: ds["users"][inx].toString(),
                                    sentByMe: ds["lastMessageSentby"] == un,
                                    lastMessage: ds["lastMessage"],
                                    image: otherPic,
                                    time: formattedDate + " " + formattedTime),
                                press: () async {
                                  dynamic id = await getOtherName(
                                      ds["users"][inx].toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MessageConvo(id)));
                                },
                                longPress: () {});
                          }))
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  getAppNotif(size) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10)),
            child: Text("Application Messages",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[50])),
          ),
          StreamBuilder(
            stream: applicationRequestStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      height: size.height * 0.55,
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            List users = ds["users"];
                            int inx = users.indexOf(un);
                            inx == 0 ? inx = 1 : inx = 0;
                            String formattedDate = DateFormat.yMMMd()
                                .format(ds["lastMessageSendTs"].toDate());
                            String formattedTime = DateFormat("h:mma")
                                .format(ds["lastMessageSendTs"].toDate());
                            return ChatCard(
                                chat: Chat(
                                  seen: ds["lastMessageSeen"],
                                  name: ds["users"][inx].toString(),
                                  lastMessage: ds["lastMessage"],
                                  sentByMe: ds["lastMessageSentby"] == un,
                                  image: otherPic,
                                  time: formattedDate + " " + formattedTime,
                                ),
                                press: () async {
                                  dynamic id = await getOtherName(
                                      ds["users"][inx].toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ApplicationRequest(
                                                ownerID: id,
                                                petID: ds["pet ID"],
                                                petName: ds["pet name"],
                                              )));
                                },
                                longPress: () {});
                          }))
                  : snapshot != null
                      ? Center(child: CircularProgressIndicator())
                      : Container(child: Text("No Messages"));
            },
          ),
        ],
      ),
    );
  }

  showDialogDelete() {
    bool flag;
    showDialog(
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
                                "Do you really want to delete this conversation?",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Delete",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
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
                          radius: 50,
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
    return flag;
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key key,
    @required this.chat,
    @required this.press,
    @required this.longPress,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;
  final VoidCallback longPress;

  Future<UserDetails> getPhoto() async {
    String uid = await DatabaseService().getUserID(chat.name.toString());
    return UserDetails(
        fullName: await DatabaseService(uid: uid).getName(),
        image: await DatabaseService(uid: uid).getPicture());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPhoto(),
        builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: press,
              onLongPress: longPress,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: snapshot.data.image,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Flexible(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(snapshot.data.fullName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: chat.sentByMe
                                                ? Colors.black
                                                : !chat.seen
                                                    ? Colors.teal
                                                    : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  )),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                          chat.time,
                                          style: TextStyle(fontSize: 12),
                                        )),
                                  ),
                                ]),
                                SizedBox(height: 5),
                                Container(
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      chat.lastMessage,
                                      style: TextStyle(
                                          color: chat.sentByMe
                                              ? Colors.black
                                              : !chat.seen
                                                  ? Colors.teal
                                                  : Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ]),
                        )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: press,
              onLongPress: longPress,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: chat.image,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                    child: Text(chat.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: chat.sentByMe
                                                ? Colors.black
                                                : !chat.seen
                                                    ? Colors.teal
                                                    : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ),
                                  chat.sentByMe
                                      ? Container()
                                      : !chat.seen
                                          ? Container(
                                              padding:
                                                  EdgeInsets.only(right: 3),
                                              child: Icon(
                                                Icons.circle,
                                                size: 10,
                                                color: Colors.teal,
                                              ),
                                            )
                                          : Container(),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                          chat.time,
                                          style: TextStyle(fontSize: 12),
                                        )),
                                  ),
                                ]),
                                SizedBox(height: 5),
                                Container(
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      chat.lastMessage,
                                      style: TextStyle(
                                          color: chat.sentByMe
                                              ? Colors.black
                                              : !chat.seen
                                                  ? Colors.teal
                                                  : Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ]),
                        )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
