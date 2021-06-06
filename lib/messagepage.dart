// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/message_convo.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
// ignore: unused_import
import 'package:wap/searchedUser.dart';
import 'package:wap/profilepage.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat({this.name, this.lastMessage, this.image, this.time, this.isActive});
}

List chatsData = [
  Chat(
      name: "Ana Suarez",
      lastMessage: "Sana okay ka lang...",
      image: "assets/images/defaultPic.png",
      time: "3m ago",
      isActive: false),
  Chat(
      name: "Lau Migallen",
      lastMessage: "Hi mamsh...",
      image: "assets/images/defaultPic.png",
      time: "4m ago",
      isActive: false),
  Chat(
      name: "Camille Atencio",
      lastMessage: "Minions lng sakalam...",
      image: "assets/images/defaultPic.png",
      time: "5m ago",
      isActive: false),
  Chat(
      name: "Almera Gascon",
      lastMessage: "Super truest ...",
      image: "assets/images/defaultPic.png",
      time: "6m ago",
      isActive: false),
  Chat(
      name: "Rayna Baoy",
      lastMessage: "Halu haluuu deeer...",
      image: "assets/images/defaultPic.png",
      time: "7m ago",
      isActive: false),
  Chat(
      name: "Minions Ito",
      lastMessage: "Musta na kayo sa Pinas? ...",
      image: "assets/images/defaultPic.png",
      time: "8m ago",
      isActive: false),
];

class _MessagePageState extends State<MessagePage> {
  ScrollController controller = ScrollController();
  int selectedIndex = 0;
  int _selectedIndex = 3;
  bool isLoading = true;
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  String userName;
  String userUsername;
  String un = "WAP USER";
  String thisname = "WAP USER";
  String firstname = "WAP";
  String lastname = "USER";
  final FirebaseAuth auth = FirebaseAuth.instance;
  // ignore: unused_field
  bool _isChecked = false;

  initState() {
    if (!mounted) {
      return;
    }

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
    final User user = auth.currentUser;
    final dbGet = DatabaseService(uid: user.uid);
    dynamic uname = await dbGet.getUsername();
    dynamic name1 = await dbGet.getName();
    if (name1 == null) {
      name1 = await dbGet.getName2();
      thisname = name1;
    } else {
      thisname = name1;
      name1 = await dbGet.getFName();
      firstname = name1;
      name1 = await dbGet.getLName();
      lastname = name1;
    }

    setState(() {
      un = uname;
    });

    var temp = await DatabaseService(uid: user.uid).getPicture();
    if (temp != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        pic = temp;
      });
    }
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
        //backgroundColor: Colors.teal[100],
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
      body: Column(
        children: [
          Container(
            height: size.height * 0.198,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.teal[100], Colors.teal],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            child: Column(
              children: [
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
                              radius: 40, backgroundImage: pic, //GET FROM DB
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
                                          //"This Name",
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
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  height: size.height * 0.05,
                                  width: (size.width * 0.35),
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
                                              color: Colors.black
                                              //decoration: TextDecoration.underline
                                              )),
                                      SizedBox(width: 5),
                                      Text("Messages",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              color: Colors.black
                                              //decoration: TextDecoration.underline
                                              )),
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
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  height: size.height * 0.05,
                                  width: (size.width * 0.35),
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
                                              color: Colors.black
                                              //decoration: TextDecoration.underline
                                              )),
                                      SizedBox(width: 5),
                                      Text("Notification",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              color: Colors.black
                                              //decoration: TextDecoration.underline
                                              )),
                                    ],
                                  )),
                            )
                          ],
                        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text("Select All",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline))),
              IconButton(icon: Icon(Icons.delete_outline), onPressed: () {})
            ],
          ),
          Container(
              height: size.height * 0.55,
              child: ListView.builder(
                itemCount: chatsData.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => ChatCard(
                    chat: chatsData[index],
                    press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageConvo())),
                    longPress: () {}),
                /*{return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: Colors.teal,
                                  checkColor: Colors.white,
                                  value: false,
                                  onChanged: (bool value) {
                                    /*setState(() {
                                      _isChecked = value;
                                    });*/
                                  }),
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage(chatsData[index].image),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(chatsData[index].name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat')),
                                      SizedBox(height: 5),
                                      Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          chatsData[index].lastMessage,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Montserrat'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                              )),
                              Opacity(
                                  opacity: 0.6,
                                  child: Text(
                                    chatsData[index].time,
                                    style: TextStyle(fontSize: 12),
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
                    );
                  }*/
              )),
        ],
      ),
    );
  }

  getAppNotif(size) {
    return Text("Application Notification");
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
                                      print(selectedIndex);
                                      /* setState(() {
                                        if (selectedIndex.length ==
                                            pets.length) {
                                          _isChecked.clear();
                                          pets.clear();
                                        } else {
                                          selectedIndex.forEach((element) {
                                            _isChecked.removeAt(element - 1);
                                            pets.removeAt(element - 1);
                                          });
                                        }
                                      });*/
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      onLongPress: longPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(chat.image),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat')),
                        SizedBox(height: 5),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            chat.lastMessage,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'Montserrat'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                )),
                Opacity(
                    opacity: 0.6,
                    child: Text(
                      chat.time,
                      style: TextStyle(fontSize: 12),
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
}
