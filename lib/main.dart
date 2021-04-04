import 'package:flutter/material.dart';
import 'package:wap/appInitializer.dart';
//import 'package:wap/regSuccess.dart';
//import 'package:wap/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}
