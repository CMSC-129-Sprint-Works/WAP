import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/widgets.dart';
import 'package:wap/main.dart';
import 'package:wap/register_page1.dart';
//import 'package:wap/register_page1.dart'; //problem: unsaon pag access ana nga mga button :( ani nga page nga wala man sila naka individually naa sa class

PersonalRegisterPage register;
//PersonalRegisterPage
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      //--------------------------------------------------------------------------
      //for first name, last name, username, password,and confirm password textformfields using find.byKey
      final firstName = 'Rayna';
      await tester.enterText(find.byKey(Key('first name1')), firstName);

      final lastname = 'Baoy';
      await tester.enterText(find.byKey(Key("last name1")), lastname);

      final userName = 'Amber';
      await tester.enterText(find.byKey(Key("username1")), userName);

      final emailAdd = 'amber@gmail.com';
      await tester.enterText(find.byKey(Key("emailAdd1")), emailAdd);
      // Enter 'hi' into the TextField.

      //unsaon pag call sa _userRegister nga method from register_page1.dart?
      //   var actual = register._RegisterPageState._userRegister(emailAdd);    (checks if username = taken)
      //   var expected = true;
      //    expect(find.text(actual, expected);

      final passWord = '1234567';
      await tester.enterText(find.byKey(Key("password1")), passWord);
      //looking for lock icons
      expect(find.byIcon(Icons.lock), findsWidgets);

      final conPassWord = '1234567';
      await tester.enterText(find.byKey(Key("conPassword1")), conPassWord);

      //expected results
      expect(find.text(firstName), findsOneWidget);
      expect(find.text(lastname), findsOneWidget);
      expect(find.text(userName), findsWidgets);
      expect(find.text(emailAdd), findsWidgets);
      expect(find.text(passWord), findsWidgets);
      expect(find.text(conPassWord), findsWidgets);
      //--------------------------------------------------------------------------

      //check terms and conditions, both institutional and personal accounts
      final Finder termsAndConditions = find.byKey(Key('Terms'));
      await tester.tap(termsAndConditions);
      // print("termsAndConditions tapped");
      expect(find.text('Terms and Conditions of WAP App'), findsOneWidget);
    },
  );
}
