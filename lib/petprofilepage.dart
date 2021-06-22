import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wap/applicationRequest.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/classtype.dart';

class PetProfilePage extends StatefulWidget {
  final Pet pet;
  final bool publicViewType;
  final String ownerID;
  const PetProfilePage(
      {@required this.pet, @required this.publicViewType, this.ownerID});
  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  int selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController controller = ScrollController();
  String myFirstName, myLastName, myUserName, username1;

  initState() {
    super.initState();
    ;
  }

  getMyData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    myFirstName = shared.getString('firstname');
    myLastName = shared.getString('lastname');
    myUserName = shared.getString('username');

    final dbGet = DatabaseService(uid: widget.ownerID);
    dynamic holder = await dbGet.getUsername();
    username1 = holder.toString();
  }

  getChatRoomID(String u1, String u2) {
    String petid = widget.pet.petID;
    if (u1.substring(0, 1).codeUnitAt(0) > u2.substring(0, 1).codeUnitAt(0)) {
      return "$u2\_$u1\_$petid";
    } else {
      return "$u1\_$u2\_$petid";
    }
  }

  savePet() async {
    final db = DatabaseService(uid: auth.currentUser.uid);
    db.addToBookmarks(widget.pet.petID);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(
          "Pet Profile",
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
          child: Stack(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                //for pic
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                  ),
                  Container(
		    key: Key("petProfilePic"),
                    margin: EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 2.25,
                    width: MediaQuery.of(context).size.width / 1.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(widget.pet.petPic),
                          fit: BoxFit.contain),
                      border: Border.all(
                        color: Colors.teal[100],
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Text("Hi! I am",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20)),
              ),
              SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Center(
                  child: Text(widget.pet.petName,
                      style: TextStyle(
                          fontFamily: 'Fredoka One',
                          fontSize: 35,
                          //fontWeight: FontWeight.bold,
                          color: Colors.teal[400])),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Center(
                  child: Text(widget.pet.petOthers,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: Colors.black54),
                      textAlign: TextAlign.center),
                ),
              ),
              SizedBox(height: 15),
              widget.publicViewType
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Adopt");
                            createAdoption(context);
                          },
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              height: 45,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/adopt.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("Adopt",
				      key: Key("adoptButton"),
                                      style: TextStyle(
                                          fontFamily: 'Fredoka One',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[50]
                                          //decoration: TextDecoration.underline
                                          )),
                                ],
                              )),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () async {
                            await savePet();
                            createBookmarked(context);
                          },
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              height: 45,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/bookmark.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text("Save",
				      key: Key("saveButton"),
                                      style: TextStyle(
                                          fontFamily: 'Fredoka One',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[50]
                                          //decoration: TextDecoration.underline
                                          )),
                                ],
                              )),
                        )
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          print("Edit");
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 5),
                            height: 45,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/adopt.png'),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text("Edit",
	   			      key: Key("edit"),
                                      style: TextStyle(
                                          fontFamily: 'Fredoka One',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[50])),
                                )
                              ],
                            )),
                      )),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: (size.width * 0.33),
                      child: TextButton(
                          onPressed: () {
                            print("About Me"); //FROM DB
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Text("About Me",
			      key: Key("aboutMe"),
                              style: TextStyle(
                                color: Colors.teal,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                    Container(
                      width: (size.width * 0.33),
                      child: TextButton(
                          onPressed: () {
                            print("Needs"); //FROM DB
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Text("Special Needs",
			      key: Key("needs"),
                              style: TextStyle(
                                color: Colors.teal,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                    Container(
                      width: (size.width * 0.33),
                      child: TextButton(
                          onPressed: () {
                            print("Characteristics"); //FROM DB
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                          child: Text("Characteristics",
			      key: Key("char"),
                              style: TextStyle(
                                color: Colors.teal,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ))),
                    ),
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
                SizedBox(height: 10),
              ]),
              IndexedStack(
                index: selectedIndex,
                children: [
                  getAboutMe(size),
                  getNeeds(size),
                  getCharacteristics(size),
                ],
              ),
            ])
      ])),
    );
  }

  getAboutMe(size) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.teal[300],
            width: 3,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Breed: ",
		    key: Key("breed"),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(widget.pet.petBreed,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Age: ",
		    key: Key("age"),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 33),
                  Text(widget.pet.petAge,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Sex: ",
		     key: Key("sex"),
		     style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 40),
                  Text(widget.pet.petSex,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Medical History: ",
		    key: Key("medicalHistory"),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(children: [
                Text(widget.pet.petMedHis,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
              ])
            ],
          ),
        ));
  }

  getNeeds(size) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.teal[300],
            width: 3,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(children: [
                Text(widget.pet.petNeeds,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
              ]),
              SizedBox(height: 10)
            ],
          ),
        ));
  }

  getCharacteristics(size) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.teal[300],
            width: 3,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(children: [
                Text(widget.pet.petCharacteristics,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
              ]),
              SizedBox(height: 10)
            ],
          ),
        ));
  }

  createBookmarked(BuildContext context) {
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
                            Text("Saved in Bookmarks",
				key: Key("savedInBookmarks"),
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Done",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 55,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.asset('assets/images/wink.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  createPending(BuildContext context) {
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
                            Text("Application Pending",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Okay",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 55,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.asset('assets/images/wink.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }

  createAdoption(BuildContext context) {
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
                            Text("Do you want to send an adoption application?",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("Yes",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () async {
                                      await getMyData();
                                      dynamic chatroomID = await getChatRoomID(
                                          myUserName, username1);
                                      Map<String, dynamic> chatRoomInfoMap = {
                                        "pet name": widget.pet.petName,
                                        "pet ID": widget.pet.petID,
                                        "application status": "Pending",
                                        "users": [myUserName, username1],
                                      };
                                      if (await DatabaseService()
                                              .createApplicationRequest(
                                                  chatroomID,
                                                  chatRoomInfoMap) !=
                                          "existing") {
                                        var lastMessageTs = DateTime.now();
                                        Map<String, dynamic> messageInfoMap = {
                                          "message": myUserName +
                                              " sent an adoption application request",
                                          "sentBy": myUserName,
                                          "ts": lastMessageTs,
                                          "message status": true,
                                        };
                                        String messID = randomAlphaNumeric(12);
                                        await DatabaseService()
                                            .addMessage2(chatroomID, messID,
                                                messageInfoMap)
                                            .then((value) {
                                          Map<String, dynamic>
                                              lastMessageInfoMap = {
                                            "lastMessageSeen": false,
                                            "lastMessage": myUserName +
                                                " sent an adoption application request",
                                            "lastMessageSendTs": lastMessageTs,
                                            "lastMessageSentby": myUserName,
                                          };

                                          DatabaseService()
                                              .updateLastMessageSent2(
                                                  chatroomID,
                                                  lastMessageInfoMap);
                                        });
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ApplicationRequest(
                                                      petID: widget.pet.petID,
                                                      ownerID: widget.ownerID,
                                                      petName:
                                                          widget.pet.petName,
                                                    )));
                                      } else {
                                        Navigator.pop(context);
                                        createPending(context);
                                      }
                                    }),
                                MaterialButton(
                                    color: Colors.teal[100],
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text("No",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
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
                          radius: 55,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child:
                                  Image.asset('assets/images/adoptButton.png')),
                        ))
                  ]),
            ));
      },
      barrierDismissible: true,
    );
  }
}
