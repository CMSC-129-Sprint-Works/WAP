import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wap/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back),
          findsOneWidget); //checking the existence of arrowBack (I found 1)

      final Finder petProfilePic = find.byKey(Key('petProfilePic'));
      tester.element(petProfilePic);
      expect(petProfilePic, null);

      expect(find.text('Hi! I am'), findsOneWidget); //finder sa text

      //for adopt button
      final Finder adoptButton = find.byKey(Key('adoptButton'));
      await tester.tap(adoptButton);
      expect(adoptButton, findsOneWidget);

      //for save button
      final Finder saveButton = find.byKey(Key('saveButton'));
      await tester.tap(saveButton);
      expect(saveButton, findsOneWidget);

      //for save button
      final Finder editButton = find.byKey(Key('edit'));
      await tester.tap(editButton);
      expect(editButton, findsOneWidget);

      //for save button
      final Finder aboutMeButton = find.byKey(Key('aboutMe'));
      await tester.tap(aboutMeButton);
      expect(aboutMeButton, findsOneWidget);

      //for save in bookmarks
      final Finder saved = find.byKey(Key('savedInBookmarks'));
      await tester.tap(saved);
      expect(saved, findsOneWidget);

      //--------------------------------------------------------------------------
      //All About Me fields
      final breed = 'aspin';
      await tester.enterText(find.byKey(Key("breed")), breed);
      expect(find.text(breed), findsOneWidget);

      final age = '2 years old';
      await tester.enterText(find.byKey(Key("age")), age);
      expect(find.text(age), findsOneWidget);

      final sex = 'male';
      await tester.enterText(find.byKey(Key("sex")), sex);
      expect(find.text(sex), findsOneWidget);

      final medical = 'none';
      await tester.enterText(find.byKey(Key("medicalHistory")), medical);
      expect(find.text(medical), findsOneWidget);

      final needs = 'love and care';
      await tester.enterText(find.byKey(Key("needs")), needs);
      expect(find.text(needs), findsOneWidget);

      final characteristics = 'none';
      await tester.enterText(find.byKey(Key("char")), characteristics);
      expect(find.text(characteristics), findsOneWidget);

      //--------------------------------------------------------------------------
    },
  );
}
