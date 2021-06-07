import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wap/main.dart';
//import 'package:wap/register_page1.dart'; //problem: unsaon pag access ana nga mga button :( ani nga page nga wala man sila naka individually naa sa class

//PersonalRegisterPage
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Register an Account'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('OK'), findsWidgets);

      //for first name, last name, username, password,and confirm password textformfields
      final firstName = 'Rayna';
      await tester.enterText(find.byKey(Key('first name')), firstName);

      final lastname = 'Baoy';
      await tester.enterText(find.byKey(Key("last name")), lastname);

      final userName = 'Amber';
      await tester.enterText(find.byKey(Key("username")), userName);

      final emailAdd = 'amber@gmail.com';
      await tester.enterText(find.byKey(Key("emailAdd")), emailAdd);

      final passWord = '1234567';
      await tester.enterText(find.byKey(Key("password")), passWord);
      expect(find.byIcon(Icons.lock), findsOneWidget);

      final conPassWord = '1234567';
      await tester.enterText(find.byKey(Key("conPassword")), conPassWord);

      //expected results
      expect(find.text(firstName), findsOneWidget);
      expect(find.text(lastname), findsOneWidget);
      expect(find.text(userName), findsOneWidget);
      expect(find.text(passWord), findsOneWidget);
      expect(find.text(conPassWord), findsOneWidget);

      //for terms and conditions
      final Finder termsAndConditions = find.byKey(Key('Terms'));
      await tester.tap(termsAndConditions);
      print("termsAndConditions tapped");
    },
  );
}

/*      app.main();
      tester.pumpAndSettle();

      //finders for email, password, and login
      var result = LoginPage.validateSubjectName('#abc');
      expect(result, null);
      final createAnAccountField =
          find.byKey(Key("create an account"));

      tester.tap(createAnAccountField);
    });
  


      final lastName = find.byKey(Key("last name"));
      final userName = find.byKey(Key("username"));
      final emailAdd = find.byKey(Key("emailAdd"));
      final passWord = find.byKey(Key("password"));
      final conPassWord = find.byKey(Key("con password"));
*/
//for Tapped Button
/*
  final Finder signInEmailField = find.byKey(Key('signInEmailField'));
  final Finder signInSaveButton = find.byKey(Key('signInSaveButton'));

  await tester.pumpWidget(MyApp());


  await tester.pumpAndSettle();

  await tester.enterText(signInEmailField, "");

  await tester.tap(signInSaveButton);

  await tester.pumpAndSettle(Duration(seconds: 1));
  
  expect(
      find.byWidgetPredicate((widget) =>
      widget is Text &&
          widget.data.contains("Enter an email")  ),
      findsOneWidget);

  await tester.pumpAndSettle(Duration(seconds: 1));
});


*/
