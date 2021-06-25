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
      await tester.pumpAndSettle();

      final Finder profile1 = find.byKey(Key('Profile1'));
      expect(profile1, findsWidgets); //finding the word "Profile"

      expect(find.byIcon(Icons.bookmark),
          findsWidgets); //checking the existence of bookmark icon
      expect(find.byIcon(Icons.grid_on_rounded),
          findsWidgets); //checking the existence of grid_on_roundeds (I found 2)

      //clicking skip Button in edit profile page of the Personal user account
      final Finder skipButton2 = find.byKey(Key('clickSkip2'));
      await tester.tap(skipButton2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      // Expect to find the item on screen after clicking Skip
      expect(skipButton2, findsOneWidget);

      final Finder submitButton = find.byKey(Key(' submitButton1'));
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(submitButton, findsNothing);

      //--------------------------------------------------------------------------
      //for nickname, address, contact,and description textformfields
      final nickname = 'ambre';
      await tester.enterText(find.byKey(Key('nickName1')), nickname);
      expect(find.text(nickname), findsOneWidget);

      final address = 'cebu';
      await tester.enterText(find.byKey(Key('address1')), address);
      expect(find.text(address), findsOneWidget);

      final contact = '09364455431';
      await tester.enterText(find.byKey(Key('contact1')), contact);
      expect(find.text(contact), findsOneWidget);

      final descript = 'I am a cat lover.';
      await tester.enterText(find.byKey(Key('description1')), descript);
      expect(find.text(descript), findsOneWidget);

      //for profile picture for personal
      final Finder petProfilePic = find.byKey(Key('profilePic1'));
      await tester.tap(petProfilePic);
      expect(petProfilePic, findsOneWidget);

      //--------------------------------------------------------------------------

      //for Institutional Set Up Profile

      final Finder profile2 = find.byKey(Key('Profile2'));
      expect(profile2, findsWidgets); //finding the word "Profile"

      final Finder skipButton3 = find.byKey(Key('clickSkip3'));
      await tester.tap(skipButton3);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      // Expect to find the item on screen after clicking Skip
      expect(skipButton2, findsOneWidget);

      final Finder submitButton2 = find.byKey(Key(' submitButton2'));
      await tester.tap(submitButton2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(submitButton, findsNothing);

      //--------------------------------------------------------------------------
      //for nickname, address, contact,and description textformfields

      final address2 = 'cebu';
      await tester.enterText(find.byKey(Key('address2')), address);
      expect(find.text(address2), findsOneWidget);

      final contact2 = '09364455431';
      await tester.enterText(find.byKey(Key('contact2')), contact);
      expect(find.text(contact2), findsOneWidget);

      final descript2 = 'I am a cat lover.';
      await tester.enterText(find.byKey(Key('description2')), descript);
      expect(find.text(descript2), findsOneWidget);

      //for profile picture for personal
      final Finder petProfilePic1 = find.byKey(Key('profilePic2'));
      await tester.tap(petProfilePic1);
      expect(petProfilePic1, findsOneWidget);
    },
  );
}
