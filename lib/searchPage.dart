import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wap/classtype.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/messagepage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/searchedUser.dart';
import 'package:wap/profilepage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final auth = FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();
  ScrollController controller = ScrollController();
  int _selectedIndex = 1;
  List<SearchedUser> searchedUsers = [];
  List<String> id = [];
  bool searching = false;
  bool searched = false;
  bool isLoading = false;
  String myUsername;
  Stream messageStream;
  Stream appRequestsStream;
  bool hasNotif = false;

  initState() {
    super.initState();
    myData();
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

  getSearchData() async {
    id.forEach((userID) async {
      await getUsersData(userID).then((value) {
        setState(() {
          searchedUsers.add(value);
        });
      });
      searchedUsers.sort(
          (b, a) => a.userStatus.toString().compareTo(b.userStatus.toString()));
    });

    searching = false;
  }

  getUsersData(String userid) async {
    if (!mounted) {
      return;
    }
    dynamic uname = await DatabaseService(uid: userid).getUsername();
    dynamic name = await DatabaseService(uid: userid).getName();
    bool accStatus = await DatabaseService(uid: userid).getAccountStatus();
    dynamic profpic = await DatabaseService(uid: userid).getPicture();

    return SearchedUser(
        id: userid,
        name: name,
        username: uname,
        userpic: profpic,
        userStatus: accStatus);
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
        {}
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
    _selectedIndex = 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(
          "Search",
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
          child: Column(
        children: [
          buildForm(),
          new SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(5),
            child: !searched
                ? Container(
                    padding: EdgeInsets.all(100),
                    child: Image.asset(
                      'assets/images/search.png',
                      color: Colors.teal,
                    ))
                : searching
                    ? Container(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitPouringHourglass(
                                color: Colors.teal[900],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Searching..."),
                            ]))
                    : searchedUsers.isEmpty
                        ? Text(
                            "No results found",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                          )
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Search Results",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 70, right: 70),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Container(
                                    height: size.height * 0.7,
                                    child: ListView.builder(
                                      controller: controller,
                                      itemCount: searchedUsers.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                            height: 100,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      blurRadius: 10.0),
                                                ]),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage:
                                                            searchedUsers[index]
                                                                .userpic,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          .uid ==
                                                                      searchedUsers[
                                                                              index]
                                                                          .id
                                                                  ? Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ProfilePage()))
                                                                  : Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              PublicProfilePage(searchedUsers[index].id)));
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(children: [
                                                                  Text(
                                                                      searchedUsers[index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          true,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          decoration: TextDecoration
                                                                              .underline,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Montserrat')),
                                                                  searchedUsers[
                                                                              index]
                                                                          .userStatus
                                                                      ? Padding(
                                                                          padding: EdgeInsets.all(
                                                                              5),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/verified.png",
                                                                              height: 15,
                                                                              matchTextDirection: true,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ))
                                                                      : SizedBox()
                                                                ]),
                                                                Text(
                                                                  "@" +
                                                                      searchedUsers[
                                                                              index]
                                                                          .username,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontFamily:
                                                                          'Montserrat'),
                                                                ),
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                      },
                                    )),
                              ],
                            ),
                          ),
          ),
        ],
      )),
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
                    textCapitalization: TextCapitalization.words,
                    controller: _searchController,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.teal)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.teal)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter a name or username',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      prefixIcon: Icon(Icons.search, color: Colors.teal),
                    ),
                    onEditingComplete: () async {
                      id.clear();
                      searchedUsers.clear();
                      setState(() {
                        searching = true;
                      });
                      await retrieveUsers(_searchController.text);

                      await getSearchData().then((value) {
                        setState(() {
                          searched = true;
                        });
                      });
                    },
                  ),
                ]),
              ))
        ]);
  }

  retrieveUsers(String keyword) async {
    setState(() {
      keyword = keyword.toLowerCase();
    });

    final docSnap = FirebaseFirestore.instance
        .collection('users')
        .where('first name', isGreaterThanOrEqualTo: keyword)
        .where('first name', isLessThan: keyword + "z");
    final docSnap2 = FirebaseFirestore.instance
        .collection('users')
        .where('last name', isGreaterThanOrEqualTo: keyword)
        .where('last name', isLessThan: keyword + "z");
    final docSnap3 = FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: keyword)
        .where('username', isLessThan: keyword + "z");

    await docSnap.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!id.contains(doc.id)) {
          id.add(doc.id);
        }
      });
    });
    await docSnap2.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!id.contains(doc.id)) {
          id.add(doc.id);
        }
      });
    });
    await docSnap3.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!id.contains(doc.id)) {
          id.add(doc.id);
        }
      });
    });
  }
}
