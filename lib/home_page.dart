import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wap/classtype.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/addPost.dart';
import 'package:wap/database.dart';
import 'package:wap/messagepage.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/searchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool fetchedPosts = false;
  ScrollController controller = ScrollController();
  bool isLoading = true;
  List<dynamic> userID = [];
  List<Post> posts = [];
  List<String> postIDs = [];
  bool noMorePosts = false;
  List<bool> _isLiked = [];
  List<int> likes = [];
  String myUsername;
  Stream messageStream;
  Stream appRequestsStream;

  initState() {
    super.initState();
    if (!mounted) {
      return;
    }
    myData();
    getUserPosts().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
  }

  myData() async {
    var stream =
        await DatabaseService(uid: auth.currentUser.uid).messageNotifHandler();
    var stream2 =
        await DatabaseService(uid: auth.currentUser.uid).messageNotifHandler2();
    var myUname =
        await DatabaseService(uid: auth.currentUser.uid).getUsername();
    setState(() {
      messageStream = stream;
      appRequestsStream = stream2;
      myUsername = myUname;
    });
  }

  getUserPosts() async {
    if (!mounted) {
      return;
    }
    userID.add(auth.currentUser.uid);
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    dbGet.getHomePosts(postIDs).then((value) {
      posts.addAll(value);
      postIDs.clear();
      posts.forEach((element) {
        postIDs.add(element.postID);
        _isLiked.add(element.liked);
        likes.add(element.likes);
      });
      setState(() {
        fetchedPosts = true;
        if (value.length == 0) {
          noMorePosts = true;
        }
      });
    });
  }

  addLike(String postID) async {
    return await DatabaseService(uid: auth.currentUser.uid)
        .addLikeToPost(postID);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        {}
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
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MessagePage()));
        }
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
    _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(
          "Home",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostPage(true)));
        },
        child: Image.asset('assets/images/postButton.png'),
      ),
      body: isLoading
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[900]),
              backgroundColor: Colors.white,
            )
          : !fetchedPosts
              ? LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[900]),
                  backgroundColor: Colors.white,
                )
              : posts.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: Text("NO POST TO SHOW"))
                  : ListView(
                      children: [
                        Container(
                            height: size.height * 0.8,
                            child: ListView.builder(
                                shrinkWrap: true,
                                controller: controller,
                                itemCount: posts.length >= 2
                                    ? posts.length + 1
                                    : posts.length,
                                itemBuilder: (context, index) {
                                  if (index == posts.length &&
                                      posts.length >= 2) {
                                    if (noMorePosts) {
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "No more posts to show",
                                          style: TextStyle(
                                              color: Colors.teal[500]),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.teal[100],
                                        child: TextButton(
                                          child: Text(
                                            "Load More",
                                            style: TextStyle(
                                                color: Colors.teal[500]),
                                          ),
                                          onPressed: () async {
                                            await getUserPosts();
                                          },
                                        ),
                                      );
                                    }
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                new Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage:
                                                            posts[index]
                                                                .userPic,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        posts[index].userName,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                      ),
                                                    ),
                                                    posts[index].accountStatus
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Container(
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/verified.png",
                                                                height: 15,
                                                                matchTextDirection:
                                                                    true,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ))
                                                        : SizedBox()
                                                  ],
                                                ),
                                                posts[index].caption != ""
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 5),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            posts[index]
                                                                .caption,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape
                                                              .rectangle),
                                                      child: Image.memory(
                                                          posts[index]
                                                              .postPic)),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15),
                                                        child: InkWell(
                                                          customBorder:
                                                              CircleBorder(),
                                                          onTap: () async {
                                                            await addLike(
                                                                posts[index]
                                                                    .postID);
                                                            setState(() {
                                                              _isLiked[index] =
                                                                  !_isLiked[
                                                                      index];
                                                            });
                                                            _isLiked[index]
                                                                ? likes[index] =
                                                                    likes[index] +
                                                                        1
                                                                : likes[index] =
                                                                    likes[index] -
                                                                        1;
                                                          },
                                                          child: ImageIcon(
                                                            AssetImage(
                                                                'assets/images/heart.png'),
                                                            color:
                                                                _isLiked[index]
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .teal,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                          likes[index]
                                                                  .toString() +
                                                              " Paw Hearts",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 15),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          posts[index].date,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                    ]),
                                                Divider(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                })),
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
            label: 'Messages',
            icon: Stack(children: [
              Icon(Icons.chat_bubble),
              StreamBuilder(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> dsList = snapshot.data.docs;
                      int count = 0;

                      return StreamBuilder(
                          stream: appRequestsStream,
                          builder: (context2, snapshot2) {
                            if (snapshot2.hasData) {
                              List<DocumentSnapshot> dsList2 =
                                  snapshot2.data.docs;

                              if (dsList2.length > 0) {
                                dsList2.forEach((element) {
                                  if (element["lastMessageSentby"] !=
                                          myUsername &&
                                      element["lastMessageSeen"] == false) {
                                    count = count + 1;
                                  }
                                });
                                dsList.forEach((element) {
                                  if (element["lastMessageSentby"] !=
                                          myUsername &&
                                      element["lastMessageSeen"] == false) {
                                    count = count + 1;
                                  }
                                });

                                if (count > 0) {
                                  return Positioned(
                                    right: 0,
                                    child: new Container(
                                      child: Text(
                                        count < 9 ? count.toString() : "9+",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              } else {
                                if (count > 0) {
                                  return Positioned(
                                    right: 0,
                                    child: new Container(
                                      child: Text(
                                        count < 9 ? count.toString() : "9+",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }
                            } else {
                              if (dsList.length > 0) {
                                dsList.forEach((element) {
                                  if (element["lastMessageSentby"] !=
                                          myUsername &&
                                      element["lastMessageSeen"] == false) {
                                    count = count + 1;
                                  }
                                });
                                if (count > 0) {
                                  return Positioned(
                                    right: 0,
                                    child: new Container(
                                      child: Text(
                                        count < 9 ? count.toString() : "9+",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              } else {
                                return SizedBox();
                              }
                            }
                          });
                    } else {
                      return SizedBox();
                    }
                  }),
            ]),
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
}
