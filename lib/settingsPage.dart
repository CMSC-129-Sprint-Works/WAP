import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';

import 'package:wap/home_page.dart';
import 'package:wap/login_page.dart';
import 'package:wap/messagepage.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/searchPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key1 = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  final _key3 = GlobalKey<FormState>();
  int _selectedIndex = 4;

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
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MessagePage()));
        }
        break;
      case 4:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 1,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.teal[500],
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
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[200],
                ),
                child: Image.asset(
                  'assets/images/wap_logo.png',
                  matchTextDirection: true,
                  fit: BoxFit.fill,
                  height: 90,
                ),
              ),
            ]),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.teal[500],
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow2(context, "Update User Credentials"),
            buildAccountOptionRow3(context, "Privacy and security"),
            buildAccountOptionRow4(context, "Disclaimer and Copyright"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Colors.teal[500],
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("New notifications", true),
            buildNotificationOptionRow("Account activity", true),
            SizedBox(
              height: 50,
            ),
            Center(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                color: Color(0xFF4DB6AC),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                    (route) =>
                        false, //if you want to disable back feature set to false
                  );
                },
                child: Text("SIGN OUT",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.2,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    )),
              ),
            )
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

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.teal[400],
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow2(BuildContext context, String title) {
    return GestureDetector(
      onTap: () async {
        await createPopUp(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal[500],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow3(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal[500],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow4(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        createDisclaimer(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal[500],
            ),
          ],
        ),
      ),
    );
  }

  createConfirm(BuildContext context, bool accepted, int goCode) {
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
                            accepted
                                ? Text(
                                    "Updated successfully, please login again",
                                    style: TextStyle(fontFamily: 'Montserrat'))
                                : goCode == 1
                                    ? Text(
                                        "Update unsuccessful, please enter correct password",
                                        style:
                                            TextStyle(fontFamily: 'Montserrat'))
                                    : Text(
                                        "Too many failed attempts, try again later",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Ok",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () async {
                                  if (accepted) {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushAndRemoveUntil<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            LoginPage(),
                                      ),
                                      (route) =>
                                          false, //if you want to disable back feature set to false
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.teal[200],
                          radius: 50,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.asset('assets/images/wap_logo.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  bool passwordChanged = false;

  changeUsername() async {
    print("ahm");
    return await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updateUsername(_userNameController.text);
  }

  changePassword() async {
    return await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .updatePassword(_newPasswordController.text)
        .then((value) => passwordChanged = true);
  }

  createPopUp3(BuildContext context, bool changeUname) {
    int goCode = 0;
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
                          Text("Security Check",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontFamily: 'Montserrat')),
                          SizedBox(height: 10),
                          Form(
                            key: _key3,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              obscuringCharacter: "*",
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please input a password";
                                } else {
                                  return null;
                                }
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                hintText: 'Type Current Password',
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Update",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  onPressed: () async {
                                    if (_key3.currentState.validate()) {
                                      try {
                                        await FirebaseAuth.instance.currentUser
                                            .reauthenticateWithCredential(
                                                EmailAuthProvider.credential(
                                                    email: FirebaseAuth.instance
                                                        .currentUser.email,
                                                    password:
                                                        _passwordController
                                                            .text));
                                      } catch (e) {
                                        print("${e.code}");
                                        if (e.code == 'wrong-password') {
                                          goCode = 1;
                                        } else if (e.code ==
                                            'too-many-requests') goCode = 2;
                                      }
                                      if (goCode == 1)
                                        createConfirm(context, false, 1);
                                      else if (goCode == 2)
                                        createConfirm(context, false, 2);
                                      else {
                                        changeUname
                                            ? await changeUsername()
                                            : await changePassword();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        createConfirm(context, true, 0);
                                      }
                                    }
                                  }),
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Back",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -50,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal[200],
                        radius: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.asset('assets/images/confused.png')),
                      ))
                ]),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  createPopUp2_2(BuildContext context) {
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
                          Text("Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontFamily: 'Montserrat')),
                          SizedBox(height: 10),
                          Form(
                            key: _key2,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password is required";
                                } else if (value.length < 6) {
                                  return "Password should be at least 6 characters";
                                } else if (value.length > 32) {
                                  return "Character limit reached (32 characters)";
                                } else {
                                  return null;
                                }
                              },
                              controller: _newPasswordController,
                              obscureText: true,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                hintText: 'Type New Password',
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Proceed",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  onPressed: () {
                                    if (_key2.currentState.validate()) {
                                      createPopUp3(context, false);
                                    }
                                  }),
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Cancel",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
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
                        backgroundColor: Colors.teal[200],
                        radius: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.asset('assets/images/confused.png')),
                      ))
                ]),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  createPopUp2(BuildContext context) {
    bool userNameTaken = false;
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
                          Text("Username",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontFamily: 'Montserrat')),
                          SizedBox(height: 10),
                          Form(
                            key: _key1,
                            autovalidateMode: AutovalidateMode.always,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Username is required";
                                } else if (value.length > 32) {
                                  return "Character limit reached (32 characters)";
                                } else if (userNameTaken == true) {
                                  return "Username is already used";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) async {
                                if (userNameTaken == true)
                                  userNameTaken = false;
                              },
                              controller: _userNameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.teal[200])),
                                hintText: 'Type New Username',
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Proceed",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  onPressed: () async {
                                    if (_key1.currentState.validate()) {
                                      final docSnap = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .where('username',
                                              isEqualTo:
                                                  _userNameController.text)
                                          .get();

                                      if (docSnap.size == 0) {
                                        Navigator.pop(context);

                                        createPopUp3(context, true);
                                      } else {
                                        setState(() {
                                          userNameTaken = true;
                                        });
                                      }
                                    }
                                  }),
                              MaterialButton(
                                  color: Colors.teal[100],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text("Cancel",
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
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
                        backgroundColor: Colors.teal[200],
                        radius: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.asset('assets/images/confused.png')),
                      ))
                ]),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  createPopUp(BuildContext context) {
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
                          MaterialButton(
                              color: Colors.teal[100],
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text("Change Username",
                                  style: TextStyle(fontFamily: 'Montserrat')),
                              onPressed: () {
                                Navigator.pop(context);
                                createPopUp2(context);
                              }),
                          SizedBox(height: 10),
                          MaterialButton(
                              color: Colors.teal[100],
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text("Change Password",
                                  style: TextStyle(fontFamily: 'Montserrat')),
                              onPressed: () {
                                Navigator.pop(context);
                                createPopUp2_2(context);
                              }),
                          SizedBox(height: 10),
                          MaterialButton(
                              color: Colors.teal[100],
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text("Cancel",
                                  style: TextStyle(fontFamily: 'Montserrat')),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -50,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal[200],
                        radius: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.asset('assets/images/confused.png')),
                      ))
                ]),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  createDisclaimer(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          insetPadding: EdgeInsets.all(10),
          child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 40),
                        Container(
                          alignment: Alignment.center,
                          child: Text("Disclaimer and Copyright Information",
                              style: TextStyle(
                                  fontFamily: 'Fredoka One',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController,
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                    title: Text(
                                        "The following definitions shall have the same meaning regardless of whether they appear in singular or in plural. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Text(
                                          "Definitions \n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "(a) Service refers to the Application. \n"
                                          "(b) You refer to the individual accessing the Service, or the company, or other legal entity. \n"
                                          "(c) Application means the software program provided by the Company downloaded by You on any electronic device named We Adopt Pets App. \n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Disclaimer",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "The information contained on the Service is for general information only. The Company assumes no responsibility for errors or omissions in the contents of the Service. In no event shall the Company be liable for any special, direct, indirect, consequential, or incidental relating to the use of the Service or the contents of the Service. The Company reserves the right to make additions, deletions, or modifications to the contents on the Service without prior notice to the users. The Company does not warrant that the Service is free of viruses or other harmful components.\n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Errors and Omissions Disclaimer",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "The information given by the Service is for general guidance on matters of interest only. Even if the Company takes every precaution to ensure that the content of the Service is both current and accurate, errors can occur. Plus, given the changing nature of laws, rules and regulations, there may be delays, omissions or inaccuracies in the information contained on the Service. The Company is not responsible for any errors or omissions, or for the results got from the use of this information.\n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Fair Use Disclaimer",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "The Company may use copyrighted material which has not always been specifically authorized by the copyright owner. If You wish to use copyrighted material from the Service for your own purposes that go beyond fair use, You must get permission from the copyright owner. \n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Indemnification",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "To the fullest extent permitted by law, you agree to indemnify and hold the company harmless from and against any claims, actions or demands, liabilities and settlements, losses, expenses, damages, and costs, including reasonable legal fees relating to your access or use or inability to access or use the Service.\n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Use at Your Own Risk Disclaimer",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "All information in the Service is provided as it is with no guarantee of completeness, accuracy, timeliness or of the results obtained from the use of this information, and without warranty of any kind, express or implied, including, but not limited to warranties of performance, merchantability and fitness for a particular purpose. The company will not be liable to you or anyone else for any decision made or action taken in reliance on the information given by the Service or for any consequential, special or similar damages, even if advised of the possibility of such damages.\n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Data collection and use",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "WAP App collects your Personal data in order to: \n"
                                          "(a) Record, support and facilitate your participation in relevant events such as pet adoption application. \n"
                                          "(b) Contact and communicate with you. \n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "The collection of Personal data by WAP App will be limited to what is necessary for the purposes of collection. If the Personal data is collected and processed for other purposes, your consent will be obtained before or at the time it is collected. \n\n"
                                          "WAP App will collect, process or disclose your Personal data only with your consent, except where required or permitted by law. \n"
                                          "WAP App keeps your Personal data only as long as needed for the purposes for which it is originally collected or to which you have subsequently consented and for legitimate purposes (such as legal compliance). \n\n"
                                          "WAP App does not sell, trade or transfer otherwise your personal data to any third parties. We will observe applicable law and take reasonable steps to ensure that any person or entity receiving or accessing your Personal data for the purposes described here above are obligated to protect and keep secure the Personal data.\n",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Contact Us",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "If you have any questions about this Disclaimer and Copyright information, You can contact Us: \n \n By email: weadoptpets@gmail.com \n \n Last updated: May 27, 2021",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Montserrat'),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ));
                                }),
                          ),
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                            color: Colors.teal[100],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: Text("Done",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal[200],
                      radius: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.asset('assets/images/wap_logo.png')),
                    ))
              ]),
        );
      },
      barrierDismissible: true,
    );
  }
}
