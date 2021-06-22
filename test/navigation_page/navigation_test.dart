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
      // Expect to find the item on screen.
      expect(find.text('Add Post'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap

      //going to HomePage
      Finder goToHomePage = find.bySemanticsLabel('Home');
      await tester.tap(goToHomePage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
      // Expect to find the item on screen.
      expect(find.text('Home'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap

      //going to SearchPage
      Finder goToSearchPage = find.bySemanticsLabel('Search');
      await tester.tap(goToSearchPage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
      // Expect to find the item on screen.
      expect(find.text('Search'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap

      //going to ProfilePage
      Finder goToProfilePage = find.bySemanticsLabel('Profile');
      await tester.tap(goToProfilePage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
      // Expect to find the item on screen.
      expect(find.text('Profile'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap

      //going to settingsPage
      Finder goToMessagesPage = find.bySemanticsLabel('Messages');
      await tester.tap(goToMessagesPage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
      // Expect to find the item on screen.
      expect(find.text('Message'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap

      //going to settingsPage
      Finder goToSettingsPage = find.bySemanticsLabel('Settings');
      await tester.tap(goToSettingsPage);
      // Rebuild the widget after the state has changed.
      await tester.pump();
      // Expect to find the item on screen.
      expect(find.text('Settings'),
          findsOneWidget); //makita ni niya sa screen nga text after ma tap
    },
  );
}
