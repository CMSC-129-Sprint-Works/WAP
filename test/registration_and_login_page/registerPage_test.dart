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

      expect(find.text('Register an Account'), findsWidgets);
      expect(find.text('Register'), findsWidgets);
      expect(find.text('OK'), findsWidgets);
      //--------------------------------------------------------------------------
      //for first name, last name, username, password,and confirm password textformfields using find.byKey
      //for personal account
      final firstName = 'Rayna';
      await tester.enterText(find.byKey(Key('forPersonal')), firstName);

      final lastname = 'Baoy';
      await tester.enterText(find.byKey(Key('lastName1')), lastname);

      final userName = 'Amber';
      await tester.enterText(find.byKey(Key("userName1")), userName);

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
      //for Insitutional Account
      final firstName1 = 'We Adopt Pets';
      await tester.enterText(find.byKey(Key('institutionName1')), firstName1);

      final userName1 = 'Amber';
      await tester.enterText(find.byKey(Key("userName1")), userName1);

      final emailAdd1 = 'amber@gmail.com';
      await tester.enterText(find.byKey(Key("emailAdd2")), emailAdd1);
      // Enter 'hi' into the TextField.

      //unsaon pag call sa _userRegister nga method from register_page1.dart?
      //   var actual = register._RegisterPageState._userRegister(emailAdd);    (checks if username = taken)
      //   var expected = true;
      //    expect(find.text(actual, expected);

      final passWord1 = '1234567';
      await tester.enterText(find.byKey(Key("password2")), passWord1);
      //looking for lock icons
      expect(find.byIcon(Icons.lock), findsWidgets);

      final conPassWord1 = '1234567';
      await tester.enterText(find.byKey(Key("conPassword2")), conPassWord1);

      //expected results
      expect(find.text(firstName), findsOneWidget);
      expect(find.text(lastname), findsOneWidget);
      expect(find.text(userName), findsWidgets);
      expect(find.text(emailAdd), findsWidgets);
      expect(find.text(passWord), findsWidgets);
      expect(find.text(conPassWord), findsWidgets);

      //check terms and conditions, both institutional and personal accounts
      final Finder termsAndConditions = find.byKey(Key('TC1'));
      await tester.tap(termsAndConditions);
      // print("termsAndConditions tapped");
      expect(find.text('Terms and Conditions of WAP App'), findsOneWidget);

      final Finder termsAndConditions1 = find.byKey(Key('TC2'));
      await tester.tap(termsAndConditions1);
      // print("termsAndConditions tapped");
      expect(find.text('Terms and Conditions of WAP App'), findsOneWidget);
    },
  );
}
