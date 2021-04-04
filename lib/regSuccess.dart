import 'package:flutter/material.dart';

class regSuccess extends StatefulWidget {
  @override
  _regSuccessState createState() => _regSuccessState();
}

class _regSuccessState extends State<regSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.teal[200],
        body: Container(
          margin: EdgeInsets.only(top: 60),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Text("Let's set up your PAWfile!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Fredoka One')),
                      margin: EdgeInsets.symmetric(vertical: 150)),
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/images/setUpPets.png',
                        matchTextDirection: true,
                        fit: BoxFit.fill,
                        height: 250,
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ));
  }
}
