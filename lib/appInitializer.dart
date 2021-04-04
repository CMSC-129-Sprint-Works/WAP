import 'package:wap/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wap/splash_screen.dart';

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(snapshot);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User user = snapshot.data;
                  if (user == null) {
                    return Splash();
                  } else {
                    return HomePage();
                  }
                }
                return loading();
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading();
      },
    );
  }
}

somethingWentWrong(snapshot) {
  return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
}

loading() {
  return Scaffold(body: Center(child: Text("Connecting to the app...")));
}
