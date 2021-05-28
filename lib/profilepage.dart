import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wap/database.dart';
import 'package:wap/editprofile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String un = "";
  String thisname = "";
  //String bio = "";

  void getUserData() async {
    final User user = auth.currentUser;
    dynamic uname = await DatabaseService(uid: user.uid).getUsername();
 //   dynamic name1 = await DatabaseService(uid: user.uid).getName();
    // dynamic bio1 = await DatabaseService(uid: user.uid).getBio();
    thisname = name1;
    un = uname;
    //bio = bio1;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getUserData();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[100],
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 1,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.teal[500],
              fontFamily: 'Montserrat',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.teal,
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile())),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        //width: (size.width - 100) * 0.3,
                        child: Stack(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 15),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1, color: Colors.teal),
                              ),
                              child: Image.asset('assets/images/confused.png',
                                  matchTextDirection: true, fit: BoxFit.fill),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 50) * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    thisname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          //GET FROM DB
                                          '@' + un,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 5),
                    child: Text(
                      "BIO",
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 0.5,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.teal,
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
                          selectedIndex = 0;
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
                        setState(() {
                          selectedIndex = 1;
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
                          selectedIndex = 2;
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
                          color: selectedIndex == 0
                              ? Colors.teal[800]
                              : Colors.transparent)),
                  Container(
                      height: 3,
                      width: (size.width * 0.33),
                      decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? Colors.teal[800]
                              : Colors.transparent)),
                  Container(
                      height: 3,
                      width: (size.width * 0.33),
                      decoration: BoxDecoration(
                          color: selectedIndex == 2
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
              index: selectedIndex,
              children: [
                Text("Display Posts"),
                Text("Display Pet List"),
                Text("Display About Me"),
              ],
            ),
          ],
        ));
  }
}
