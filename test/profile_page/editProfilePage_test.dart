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

      final Finder profile1 = find.byKey(Key('editProfile1'));
      expect(profile1, findsWidgets); //finding the word "Profile"

      //clicking edit profile icon
      final Finder editProfileButton = find.byKey(Key('editPublicDetails1'));
      await tester.tap(editProfileButton);
      expect(editProfileButton, null);

      final Finder submitButton = find.byKey(Key('updateButton'));
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(submitButton, findsNothing);

      //--------------------------------------------------------------------------
      //for nickname, address, contact,and description textformfields
      expect(find.text('Names'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      final firstname = 'ambre';
      await tester.enterText(find.byKey(Key('firstNameEdit')), firstname);
      expect(find.text(firstname), findsOneWidget);

      final lastname = 'gomez';
      await tester.enterText(find.byKey(Key('lastNameEdit')), lastname);
      expect(find.text(lastname), findsOneWidget);

      final othername = 'bre';
      await tester.enterText(find.byKey(Key('otherNameEdit')), othername);
      expect(find.text(othername), findsOneWidget);

      final address = 'cebu';
      await tester.enterText(find.byKey(Key('addressEdit')), address);
      expect(find.text(address), findsOneWidget);

      final contact = '09364455431';
      await tester.enterText(find.byKey(Key('contactEdit')), contact);
      expect(find.text(contact), findsOneWidget);

      final descript = 'Hello world';
      await tester.enterText(find.byKey(Key('bio')), descript);
      expect(find.text(descript), findsOneWidget);

      //--------------------------------------------------------------------------

      //for institutional
      expect(find.text('Donation Details'), findsOneWidget);
      expect(find.text(' Verify your Account'), findsOneWidget);
    },
  );
}
