// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/widgets.dart';
import 'package:wap/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());

      //going to AddPostPage
      final Finder goToAddPostPage = find.byKey(Key('goToAddPostPage'));
      // Tap the add button.
      await tester.tap(goToAddPostPage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
    },
  );
}
