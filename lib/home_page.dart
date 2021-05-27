import 'package:flutter/material.dart';
import 'package:wap/classtype.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/addPost.dart';
import 'package:wap/database.dart';
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
  String un = "WAP USER";
  String thisname = "WAP USER";
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  bool fetchedPosts = false;
  ScrollController controller = ScrollController();
  bool isLoading = true;
  //List<bool> _isChecked;
  List<dynamic> userID = [];
  List<Post> posts = [];

  initState() {
    super.initState();
    if (!mounted) {
      return;
    }

    getUserPosts().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
  }

  getUserPosts() async {
    if (!mounted) {
      return;
    }
    userID.add(auth.currentUser.uid);

    var dbPostGet;
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    await dbGet.getFollowing().then((value) async {
      await Future.forEach(value, (id) async {
        setState(() {
          userID.add(id);
        });
      });
    });
    // print(userID);
    userID.forEach((element) {
      dbPostGet = DatabaseService(uid: element);
      dbPostGet.getPosts().then((value) async {
        await Future.forEach(value, (post) => posts.add(post));
        setState(() {
          fetchedPosts = true;
        });
      });
    });

    print("fetched: " + fetchedPosts.toString());
    print("posts: " + posts.length.toString());
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
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.teal[500],
            fontFamily: 'Montserrat',
          ),
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
                  ? Container(child: Text("NO POST TO SHOW"))
                  : ListView(
                      children: [
                        Container(
                            height: size.height * 0.8,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: controller,
                              itemCount: posts.length, //userPosts.length
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            new Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        posts[index].userPic,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    posts[index].userName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      fontFamily: 'Montserrat',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            posts[index].caption != ""
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        left: 5),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        posts[index].caption,
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
                                                      shape:
                                                          BoxShape.rectangle),
                                                  child: Image.memory(
                                                      posts[index].postPic)),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: ImageIcon(
                                                      // alignment: Alignment.topLeft,
                                                      AssetImage(
                                                          'assets/images/heart.png'),
                                                      color: Colors.teal,
                                                    ),
                                                  ),
                                                  /*  IconButton(
                                              // alignment: Alignment.topLeft,
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.teal,
                                              ),
                                              onPressed: () {}),*/
                                                  IconButton(
                                                      // alignment: Alignment.topLeft,
                                                      icon: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.teal,
                                                      ),
                                                      onPressed: () {}),
                                                ]),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
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
}
