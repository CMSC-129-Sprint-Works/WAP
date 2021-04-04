import 'package:flutter/material.dart';
import 'package:wap/TermsAndConditions.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _newusernameController = TextEditingController();
  TextEditingController _newemailController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  bool accepted = false;
  bool usernameTaken = false;
  bool emailTaken = false;
  String pssword;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        title: Text('We Adopt Pets'),
        actions: [
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
              height: 60,
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(children: <Widget>[
          Text(
            'Register an Account',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka One',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildForm(),
          SizedBox(height: 20),
          readTC(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: () {
                  if (_key.currentState.validate()) {
                    print("OK");
                  }
                },
                color: Colors.teal[100],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text("Register",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Montserrat')),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              key: _key,
              child: Column(children: <Widget>[
                TextFormField(
                  //USERNAME
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username is required";
                    } else if (usernameTaken) {
                      return "Username is already used";
                    } else {
                      return null;
                    }
                  },
                  controller: _newusernameController,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[300],
                    filled: true,
                    hintText: 'Username',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //EMAIL
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email is required";
                    } else if (emailTaken) {
                      return "Email is already used";
                    } else {
                      return null;
                    }
                  },
                  controller: _newemailController,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[300],
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //PASSWORD
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password should be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  controller: _newpasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[300],
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //CONFIRM PASSWORD
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    } else if (_newpasswordController.text !=
                        _confirmpasswordController.text) {
                      return "Password does not match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  controller: _confirmpasswordController,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[300],
                    filled: true,
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                ),
              ]),
            )),
      ],
    );
  }

  Widget readTC() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('By clicking Register, you accept the ',
            style: TextStyle(fontFamily: 'Montserrat')),
        TextButton(
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) => TermsAndConditions(),
              );
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('Terms and Conditions of WAP App',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold)))
      ],
    );
  }
}
