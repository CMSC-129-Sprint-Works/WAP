// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/widgets.dart';
import 'package:wap/main.dart';
import 'package:wap/addPost.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());

      //text finders
      final Finder addPost = find.byKey(Key('addPost'));
      expect(addPost, findsOneWidget);

      final Finder uploadPost = find.byKey(Key('uploadPost'));
      expect(uploadPost, findsOneWidget);

      //finder for icons and check if it works
      final Finder photoIcon = find.byIcon(Icons.photo);
      await tester.tap(photoIcon);
      expect(photoIcon, findsNothing);

      final Finder cameraIcon = find.byIcon(Icons.camera_alt);
      await tester.tap(cameraIcon);
      expect(cameraIcon, findsNothing);

      final Finder tagFacesIcon = find.byIcon(Icons.tag_faces);
      await tester.tap(tagFacesIcon);
      expect(tagFacesIcon, findsNothing);

      final Finder caption = find.byKey(Key('caption'));
      expect(caption, findsOneWidget);
    },
  );
}
