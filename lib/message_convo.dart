// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/searchPage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
// ignore: unused_import
import 'package:wap/searchedUser.dart';
import 'package:wap/profilepage.dart';

class MessageConvo extends StatefulWidget {
  @override
  _MessageConvoState createState() => _MessageConvoState();
}

class _MessageConvoState extends State<MessageConvo> {
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
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Conversation",
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
      body: Column(),
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
