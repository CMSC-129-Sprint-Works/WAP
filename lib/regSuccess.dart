import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wap/setUpProfile.dart';

class RegisterSuccess extends StatefulWidget {
  @override
  _RegisterSuccessState createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[400],
        body: Container(
            margin: EdgeInsets.only(top: 40),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(children: <Widget>[
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
                  height: 100,
                ),
              ),
              SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: Text('Great!',
                    style: TextStyle(
                        fontFamily: 'Shrikhand',
                        fontStyle: FontStyle.italic,
                        color: Colors.brown[600],
                        fontSize: 20)),
              ),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Let us set up your',
                      style: TextStyle(
                        fontFamily: 'Shrikhand',
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey[50],
                        shadows: [
                          Shadow(color: Colors.orange[900], blurRadius: 5)
                        ],
                      )),
                  Text('PAWfile',
                      style: TextStyle(
                        fontFamily: 'Shrikhand',
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey[50],
                        shadows: [
                          Shadow(color: Colors.orange[900], blurRadius: 5)
                        ],
                      )),
                  Image.asset('assets/images/excited.png', height: 250),
                  SizedBox(height: 40),
                  SpinKitThreeBounce(
                    color: Colors.white,
                    size: 30.0,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetupProfilePage()));
                    },
                    color: Colors.teal[100],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text("Proceed",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'Montserrat')),
                  ),
                ),
              ),
            ])));
  }
}
