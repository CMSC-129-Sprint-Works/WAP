import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:wap/message_convo.dart';
import 'package:wap/messagepage.dart';
import 'package:wap/petprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/searchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicProfilePage extends StatefulWidget {
  final String userID;
  const PublicProfilePage(this.userID);
  @override
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-----------------------------ACCESSORS + INDECES----------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController controller = ScrollController();
  int tabSelectedIndex = 0;
  int navBarSelectedIndex = 2;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //-----------------------------USER DETAILS VARIABLE--------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  bool following = false;
  String accountType;
  String userName = "WAP USER";
  String fullName = "WAP USER";
  String firstName = "WAP";
  String lastName = "USER";
  String bio = " ";
  String address = "The user has not set this yet.";
  String contact = "The user has not set this yet.";
  String nickname = "The user has not set this yet.";
  String email = "The user has not set this yet.";
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  String myFirstName, myLastName, myUserName, username1;

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

  List<dynamic> posts = [];
  List<bool> _isLiked = [];
  List<int> likes = [];
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
    searchFollowing();
    getMyData();
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

  getMyData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    myFirstName = shared.getString('firstname');
    myLastName = shared.getString('lastname');
    myUserName = shared.getString('username');

    dynamic holder = await DatabaseService(uid: widget.userID).getUsername();
    username1 = holder.toString();
  }

  getChatRoomID(String u1, String u2) {
    if (u1.substring(0, 1).codeUnitAt(0) > u2.substring(0, 1).codeUnitAt(0)) {
      return "$u2\_$u1";
    } else {
      return "$u1\_$u2";
    }
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    accountType = await DatabaseService(uid: widget.userID).getAccountType();
    fullName = await DatabaseService(uid: widget.userID).getName();
    firstName = await DatabaseService(uid: widget.userID).getFName();
    lastName = await DatabaseService(uid: widget.userID).getLName();
    userName = await DatabaseService(uid: widget.userID).getUsername();
    email = await DatabaseService(uid: widget.userID).getEmail();
    userName = await DatabaseService(uid: widget.userID).getUsername();
    bio = await DatabaseService(uid: widget.userID).getBio();
    nickname = await DatabaseService(uid: widget.userID).getNickname();
    address = await DatabaseService(uid: widget.userID).getAddress();
    contact = await DatabaseService(uid: widget.userID).getContact();
  }

  getUserPic() async {
    pic = await DatabaseService(uid: widget.userID).getPicture();
  }

  getUserPets() async {
    return await DatabaseService(uid: widget.userID)
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
    });
  }

  getUserPosts() async {
    return await DatabaseService(uid: widget.userID)
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

  searchFollowing() async {
    final CollectionReference userslist =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot un = await userslist.doc(auth.currentUser.uid).get();
    List<dynamic> followingList = un.get('following');
    setState(() {
      following = followingList.contains(widget.userID);
    });
  }

  addFollowing() async {
    final User user = auth.currentUser;
    DatabaseService(uid: user.uid).addFollowing(widget.userID);
  }

  removeFollowing() async {
    final User user = auth.currentUser;
    DatabaseService(uid: user.uid).removeFollowing(widget.userID);
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
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text(
          firstName + "'s Profile",
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                fullName,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 1),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      //GET FROM DB
                                                      '@' + userName,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
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
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                            child: MaterialButton(
                              onPressed: () async {
                                setState(() {
                                  following = !following;
                                });
                                following
                                    ? await addFollowing()
                                    : await removeFollowing();
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.teal,
                                  content: !following
                                      ? Text(
                                          "Oh no! You unfollowed " + firstName)
                                      : Text(
                                          "Yay! You're following " + firstName),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.teal[50],
                              child: Center(
                                child: Text(
                                  following ? 'Unfollow' : 'Follow',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: MaterialButton(
                              onPressed: () {
                                dynamic chatroomID =
                                    getChatRoomID(myUserName, username1);

                                Map<String, dynamic> chatRoomInfoMap = {
                                  "users": [myUserName, username1],
                                };
                                DatabaseService().createChatRoom(
                                    chatroomID, chatRoomInfoMap);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MessageConvo(widget.userID)));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.teal[50],
                              child: Center(
                                child: Text(
                                  'Send Message',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                          onPressed: () {
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
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
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
                          child: Icon(Icons.mail_outline_rounded,
                              color: Colors.white)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Contact Details",
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
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10)),
            child: Text(firstName + "'s Pet List",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[50])),
          ),
          SizedBox(height: 15),
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
                      height: size.height * 0.5,
                      child: ListView.builder(
                        controller: controller,
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            pets.length >= 4 ? pets.length + 1 : pets.length,
                        itemBuilder: (context, index) {
                          return (index == pets.length && pets.length >= 4)
                              ? noMorePets
                                  ? Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.8,
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "No more pets to show",
                                            style: TextStyle(
                                                color: Colors.teal[500]),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                          width: size.width * 0.8,
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
                                        ),
                                      ],
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
                                        CircleAvatar(
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
                                                                    true,
                                                                ownerID: widget
                                                                    .userID,
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
                  : Container(),
        ],
      ),
    );
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
}
