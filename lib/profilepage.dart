import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wap/addPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:wap/bookmarkPage.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/editprofile.dart';
import 'package:wap/editprofile2.dart';
import 'package:wap/messagepage.dart';
import 'package:wap/petprofilepage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/setupPetProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-----------------------------ACCESSORS + INDECES----------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController controller = ScrollController();
  int tabSelectedIndex = 0;
  int navBarSelectedIndex = 2;
  Stream messageStream;
  Stream appRequestsStream;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-----------------------------USER DETAILS VARIABLE--------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  String accountType;
  bool accountStatus = false;
  String userName = "WAP USER";
  String fullName = "WAP USER";
  String firstName = "WAP";
  String lastName = "USER";
  String donationDetails = "The user has not set this yet.";
  String bio = " ";
  String address = "The user has not set this yet.";
  String contact = "The user has not set this yet.";
  String nickname = "The user has not set this yet.";
  String email = "The user has not set this yet.";
  dynamic pic = AssetImage('assets/images/defaultPic.png');

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------LOADERS-----------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  bool isLoading = true;
  bool postLoading = true;
  bool petLoading = true;
  bool noMorePets = false;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //---------------------------POSTLIST + PETLIST-------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  List<bool> _isChecked = [];
  List<bool> _isLiked = [];
  List<int> likes = [];
  List<dynamic> posts = [];
  List<dynamic> pets = [];
  List<String> petIDs = [];

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //---------------------------INIT + GETTER FUNCTIONS--------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  initState() {
    //CHECK IF WIDGETS ARE MOUNTED
    if (!mounted) {
      return;
    }
    //DATABASE FUNCTIONS ACCESSOR

    //GET USER DETAILS
    getUserData().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    getUserPic();

    //GET USER POSTS
    getUserPosts();
    super.initState();
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    accountType =
        await DatabaseService(uid: auth.currentUser.uid).getAccountType();
    if (accountType == "institution") {
      accountStatus =
          await DatabaseService(uid: auth.currentUser.uid).getAccountStatus();
      if (accountStatus == true) {
        donationDetails = await DatabaseService(uid: auth.currentUser.uid)
            .getDonationDetails();
      }
    }
    var stream =
        await DatabaseService(uid: auth.currentUser.uid).messageNotifHandler();
    var stream2 =
        await DatabaseService(uid: auth.currentUser.uid).messageNotifHandler2();
    var uName = await DatabaseService(uid: auth.currentUser.uid).getUsername();
    setState(() {
      messageStream = stream;
      appRequestsStream = stream2;
      userName = uName;
    });
    fullName = await DatabaseService(uid: auth.currentUser.uid).getName();
    firstName = await DatabaseService(uid: auth.currentUser.uid).getFName();
    lastName = await DatabaseService(uid: auth.currentUser.uid).getLName();
    userName = await DatabaseService(uid: auth.currentUser.uid).getUsername();
    email = await DatabaseService(uid: auth.currentUser.uid).getEmail();

    bio = await DatabaseService(uid: auth.currentUser.uid).getBio();
    nickname = await DatabaseService(uid: auth.currentUser.uid).getNickname();
    address = await DatabaseService(uid: auth.currentUser.uid).getAddress();
    contact = await DatabaseService(uid: auth.currentUser.uid).getContact();
  }

  getUserPic() async {
    pic = await DatabaseService(uid: auth.currentUser.uid).getPicture();
  }

  getUserPets() async {
    return await DatabaseService(uid: auth.currentUser.uid)
        .getPets(petIDs)
        .then((value) async {
      setState(() {
        pets.addAll(value);
        petLoading = false;
        if (value.length == 0) noMorePets = true;
      });
      pets.forEach((element) {
        petIDs.add(element.petID);
      });

      pets.isNotEmpty
          ? _isChecked = List<bool>.filled(pets.length, false, growable: true)
          : _isChecked = [];
    });
  }

  getUserPosts() async {
    return await DatabaseService(uid: auth.currentUser.uid)
        .getPosts()
        .then((value) async {
      setState(() {
        posts.addAll(value);
        posts.forEach((element) {
          _isLiked.add(element.liked);
          likes.add(element.likes);
        });
        postLoading = false;
      });
    });
  }

  deletePost(String postID) async {
    return await DatabaseService(uid: auth.currentUser.uid).deletePost(postID);
  }

  deletePet(List<int> selectedIndex) {
    final db = DatabaseService(uid: auth.currentUser.uid);
    selectedIndex.forEach((index) {
      db.removePet(pets.elementAt(index - 1).petID);
    });
  }

  addLike(String postID) async {
    return await DatabaseService(uid: auth.currentUser.uid)
        .addLikeToPost(postID);
  }

  void _onItemTapped(int index) {
    setState(() {
      navBarSelectedIndex = index;
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
        {}
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
    navBarSelectedIndex = 2;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
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
      floatingActionButton: isLoading
          ? Container()
          : tabSelectedIndex == 0
              ? FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPostPage(false)));
                  },
                  child: Image.asset('assets/images/postButton.png'),
                )
              : (Container()),
      body: isLoading
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[900]),
              backgroundColor: Colors.white,
            )
          : ListView(
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
                                    padding:
                                        const EdgeInsets.only(left: 28, top: 7),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: pic, //GET FROM DB
                                      child: GestureDetector(
                                        onTap: () async {
                                          await expandPhoto(pic, true, 0);
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (size.width - 50) * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Text(
                                                      fullName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    accountType ==
                                                                "institution" &&
                                                            accountStatus ==
                                                                true
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Container(
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/verified.png",
                                                                height: 20,
                                                                matchTextDirection:
                                                                    true,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ))
                                                        : SizedBox(width: 1)
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 1),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          //GET FROM DB
                                                          '@' + userName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
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
                              SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, bottom: 5),
                                child: Text(
                                  bio,
                                  style: TextStyle(fontFamily: 'Montserrat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 50, right: 50),
                                child: MaterialButton(
                                  onPressed: () {
                                    accountType == "personal"
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile(
                                                        pic,
                                                        firstName,
                                                        lastName,
                                                        bio,
                                                        address,
                                                        nickname,
                                                        contact)))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditInstiProfile(
                                                        accountStatus,
                                                        pic,
                                                        fullName,
                                                        bio,
                                                        address,
                                                        nickname,
                                                        contact)));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  color: Colors.teal[50],
                                  child: Container(
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                            ])
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.grid_on_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            print("Display Posts"); //FROM DB
                            setState(() {
                              tabSelectedIndex = 0;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.pets_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            print("Display Pet List"); //FROM DB
                            getUserPets();
                            setState(() {
                              tabSelectedIndex = 1;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.account_box_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            print("Display About Me"); //FROM DB
                            setState(() {
                              tabSelectedIndex = 2;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Column(children: [
                  Row(
                    children: [
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: tabSelectedIndex == 0
                                  ? Colors.teal[800]
                                  : Colors.transparent)),
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: tabSelectedIndex == 1
                                  ? Colors.teal[800]
                                  : Colors.transparent)),
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: tabSelectedIndex == 2
                                  ? Colors.teal[800]
                                  : Colors.transparent))
                    ],
                  ),
                  Container(
                    height: 0.5,
                    width: size.width,
                    decoration: BoxDecoration(color: Colors.teal),
                  ),
                ]),
                SizedBox(height: 10),
                IndexedStack(
                  index: tabSelectedIndex,
                  children: [
                    postLoading
                        ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 50),
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal[900])),
                          )
                        : posts.isNotEmpty
                            ? getPosts(size)
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 60, right: 50, top: 200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("No Posts Available",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 30)),
                                  ],
                                ),
                              ),
                    getPetList(size),
                    getAboutMe(),
                  ],
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
                                          userName &&
                                      element["lastMessageSeen"] == false) {
                                    count = count + 1;
                                  }
                                });
                                dsList.forEach((element) {
                                  if (element["lastMessageSentby"] !=
                                          userName &&
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
                                          userName &&
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
        currentIndex: navBarSelectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.teal,
        showUnselectedLabels: true,
      ),
    );
  }

  getPosts(size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(posts.length, (index) {
        return Container(
          height: 150,
          width: (size.width - 6) / 3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: MemoryImage(posts[index].postPic), fit: BoxFit.cover)),
          child: GestureDetector(
            onTap: () {
              expandPhoto(MemoryImage(posts[index].postPic), false, index);
            },
          ),
        );
      }),
    );
  }

  getAboutMe() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 70, right: 70),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("About Me",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[50])),
                ),
                SizedBox(height: 15),
                //Display user's nickname if account type is personal
                accountType == "personal"
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                    height: 60,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.teal),
                                    child: Icon(Icons.person_outline_rounded,
                                        color: Colors.white)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Nickname",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //Get nickname of user
                          Text(
                            nickname,
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.teal),
                        ],
                      )
                    //Display donation details for verified institution
                    : accountType == "institution" && accountStatus == true
                        ? Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                          height: 60,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.teal),
                                          child: Icon(Icons.pets_outlined,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Donation Details",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Get donation details of user
                                Text(
                                  donationDetails,
                                  style: TextStyle(fontFamily: 'Montserrat'),
                                ),
                                SizedBox(height: 10),
                                Divider(color: Colors.teal),
                              ],
                            ),
                          )
                        : SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child:
                              Icon(Icons.home_outlined, color: Colors.white)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                //Get address of user
                Text(
                  address,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child:
                              Icon(Icons.phone_outlined, color: Colors.white)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Contact Number",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                //Get contact details of user
                Text(
                  contact,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child:
                              Icon(Icons.email_outlined, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                //Get email address of user
                Text(
                  email,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal)
              ],
            ))
      ],
    );
  }

  getPetList(size) {
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
            child: Text("My Pet List",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[50])),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (pets.length > 0) {
                        _isChecked = List<bool>.filled(pets.length, true,
                            growable: true);
                      }
                    });
                  },
                  child: Text("Select All",
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline))),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.add, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SetupPetProfile()));
                      }),
                  IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.teal),
                      onPressed: () async {
                        List<int> selectedIndex = [];
                        int elementNum = 0;
                        _isChecked.forEach((element) {
                          elementNum += 1;
                          if (element == true) {
                            selectedIndex.add(elementNum);
                          }
                        });

                        if (selectedIndex.isNotEmpty) {
                          await showDialogDelete(selectedIndex);
                        }
                      }),
                ],
              ),
            ],
          ),
          petLoading
              ? Container(
                  margin: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.teal[900])),
                )
              : pets.isNotEmpty
                  ? Container(
                      height: size.height * 0.45,
                      child: ListView.builder(
                        controller: controller,
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            pets.length >= 4 ? pets.length + 1 : pets.length,
                        itemBuilder: (context, index) {
                          return (index == pets.length && pets.length >= 4)
                              ? noMorePets
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "No more pets to show",
                                        style:
                                            TextStyle(color: Colors.teal[500]),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.teal[100],
                                      child: TextButton(
                                        child: Text(
                                          "Load More",
                                          style: TextStyle(
                                              color: Colors.teal[500]),
                                        ),
                                        onPressed: () async {
                                          await getUserPets();
                                        },
                                      ),
                                    )
                              : Container(
                                  height: 120,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withAlpha(100),
                                            blurRadius: 10.0),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: Colors.teal,
                                            checkColor: Colors.white,
                                            value: _isChecked[index],
                                            onChanged: (bool value) {
                                              setState(() {
                                                _isChecked[index] = value;
                                              });
                                            }),
                                        CircleAvatar(
                                          backgroundColor: Colors.teal,
                                          radius: size.height * 0.05,
                                          backgroundImage: MemoryImage(
                                              pets[index].petPic), //GET FROM DB
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PetProfilePage(
                                                                pet:
                                                                    pets[index],
                                                                publicViewType:
                                                                    false,
                                                              )));
                                                },
                                                child: Text(pets[index].petName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat')),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      pets[index].petBreed,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Montserrat'),
                                                    ),
                                                    Text(
                                                      pets[index].petSex,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Montserrat'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ));
                        },
                      ))
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Pet List to Show",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25)),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  showDialogDelete(List<int> selectedIndex) {
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
                                "Do you really want to delete the selected pet profile/s?",
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
                                      deletePet(selectedIndex);
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

  expandPhoto(dynamic img, bool profPic, dynamic index) async {
    if (!mounted) {
      return;
    }
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
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image(
                      fit: BoxFit.fill,
                      image: img,
                    ),
                  ),
                  !profPic
                      ? Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                bottom: 5,
                              ),
                              child: InkWell(
                                customBorder: CircleBorder(),
                                onTap: () async {
                                  await addLike(posts[index].postID);
                                  setState(() {
                                    _isLiked[index] = !_isLiked[index];

                                    _isLiked[index]
                                        ? likes[index] = likes[index] + 1
                                        : likes[index] = likes[index] - 1;
                                  });
                                  Navigator.pop(context);
                                  expandPhoto(img, profPic, index);
                                },
                                child: ImageIcon(
                                  AssetImage('assets/images/heart.png'),
                                  color: _isLiked[index]
                                      ? Colors.red
                                      : Colors.teal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, bottom: 5),
                              child: Text(
                                likes[index].toString() + " Paw Hearts",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.delete, color: Colors.teal),
                                    onPressed: () async {
                                      await showDialogDelete2(
                                          posts[index].postID);
                                    },
                                  )),
                            )
                          ],
                        )
                      : Container(),
                  !profPic
                      ? Row(children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: CircleAvatar(
                              backgroundImage: pic,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 5),
                              child: Text('@' + userName,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 10, bottom: 5),
                              child: Text(posts[index].date,
                                  style: TextStyle(fontFamily: 'Montserrat')),
                            ),
                          )
                        ])
                      : Container(),
                  !profPic
                      ? posts[index].caption != ""
                          ? Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 60, bottom: 10),
                              child: Text(posts[index].caption,
                                  style: TextStyle(fontFamily: 'Montserrat')),
                            )
                          : Container()
                      : Container()
                ],
              ),
              Positioned(
                top: -20,
                right: -15,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/cancel.png',
                    height: 40,
                  ),
                ),
              ),
            ],
          )),
        );
      },
      barrierDismissible: true,
    );
  }

  showDialogDelete2(String postID) {
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
                            Text("Do you really want to delete this post?",
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
                                    onPressed: () async {
                                      await deletePost(postID);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()));
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
  }
}
