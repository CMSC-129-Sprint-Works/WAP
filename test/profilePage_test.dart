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

      expect(find.text('Profile'), findsWidgets); //finding the word "Profile"

      //clicking edit profile icon
      final Finder editProfileButton = find.byKey(Key('editProfile'));
      await tester.tap(editProfileButton);
      expect(find.byIcon(Icons.bookmark),
          findsOneWidget); //checking the existence of bookmark icon
      expect(find.byIcon(Icons.grid_on_rounded),
          findsWidgets); //checking the existence of grid_on_roundeds (I found 2)

      //--------------------------------------------------------------------------
      //for nickname, address, contact, emailAdd textformfields
      final nickname = 'ambre';
      await tester.enterText(find.byKey(Key("nickname")), nickname);
      expect(find.text(nickname), findsOneWidget);

      final address = 'cebu';
      await tester.enterText(find.byKey(Key("address")), address);
      expect(find.text(address), findsOneWidget);

      final contact = '09364455431';
      await tester.enterText(find.byKey(Key("contact")), contact);
      expect(find.text(contact), findsOneWidget);

      final emailAdd = 'amber1@gmail.com';
      await tester.enterText(find.byKey(Key("emailAddProfilePage")), emailAdd);
      expect(find.text(emailAdd), findsOneWidget);
      //--------------------------------------------------------------------------
    },
  );
}
