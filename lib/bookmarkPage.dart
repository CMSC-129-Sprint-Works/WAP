import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wap/classtype.dart';
import 'package:wap/database.dart';
import 'package:wap/petprofilepage.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController controller = ScrollController();
  List<bool> _isChecked = [];
  List<Pet> pets = [];
  bool isLoading = true;

  @override
  void initState() {
    getUserBookmarks();
    super.initState();
  }

  getUserBookmarks() async {
    await DatabaseService(uid: auth.currentUser.uid)
        .getBookmarks()
        .then((value) {
      setState(() {
        value != null ? pets.addAll(value) : pets = [];
        pets.isNotEmpty
            ? _isChecked = List<bool>.filled(pets.length, false, growable: true)
            : _isChecked = [];
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  deletePet(List<int> selectedIndex) {
    final db = DatabaseService(uid: auth.currentUser.uid);
    selectedIndex.forEach((index) {
      db.removeBookmark(pets.elementAt(index - 1).petID);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 1,
        title: Text(
          "Bookmarks",
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
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                if (pets.length > 0) {
                                  _isChecked = List<bool>.filled(
                                      pets.length, true,
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
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.teal),
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
                    pets.isNotEmpty
                        ? Container(
                            height: size.height * 1,
                            child: ListView.builder(
                              controller: controller,
                              itemCount: pets.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 120,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withAlpha(100),
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
                                                pets[index]
                                                    .petPic), //GET FROM DB
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
                                                                  pet: pets[
                                                                      index],
                                                                  publicViewType:
                                                                      true,
                                                                )));
                                                  },
                                                  child: Text(
                                                      pets[index].petName,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        pets[index].petBreed,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                'Montserrat'),
                                                      ),
                                                      Text(
                                                        pets[index].petSex,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                        : Container(
                            height: size.height,
                            padding: EdgeInsets.all(60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child:
                                      Image.asset('assets/images/petBook.png'),
                                ),
                                Expanded(
                                    child: Text(
                                  "No bookmarks added yet",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black),
                                ))
                              ],
                            ),
                          ),
                  ],
                ),
              ),
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
                                "Do you really want to delete the selected bookmark/s?",
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
                                      deletePet(selectedIndex);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookmarkPage()));
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
