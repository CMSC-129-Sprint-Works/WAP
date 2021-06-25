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

      //TEXT FINDERS
      expect(find.text('Login to WAP APP'), findsOneWidget);
      expect(find.text('New to WAP App'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('New to WAP App?'), findsOneWidget);
      expect(find.text('Create an Account'), findsOneWidget);

      //entering email add
      final emailAdd = 'amber@gmail.com';
      await tester.enterText(find.byKey(Key('usernameforLogin')), emailAdd);
      expect(find.text(emailAdd), findsWidgets);

      //logging in with empty username
      final emptyEmailAdd = ' ';
      await tester.enterText(
          find.byKey(Key('usernameforLogin')), emptyEmailAdd);
      expect(find.text('Username is required'), findsWidgets);

      //entering password
      final enterPassword = '123456';
      await tester.enterText(
          find.byKey(Key('passwordValidator')), enterPassword);
      expect(find.text(emailAdd), findsWidgets);

      //entering password less than 6 digits or characters
      final enterFewPassword = '1234';
      await tester.enterText(
          find.byKey(Key('passwordValidator')), enterFewPassword);
      expect(
          find.text('Password should be at least 6 characters'), findsWidgets);

      //logging in with empty password
      final emptypword = ' ';
      await tester.enterText(find.byKey(Key('usernameforLogin')), emptypword);
      expect(find.text('Password is required'), findsWidgets);

      //clicking forgot password
      final Finder passForgot = find.byKey(Key('passwordforgotten'));
      await tester.tap(passForgot);
      await tester.pump();
      expect(find.byKey(Key('Enter your email')), findsWidgets);

      // Expect to find the item on screen after forgot password
      final resetEmail = 'amber@gmail.com';
      await tester.enterText(find.byKey(Key('Enter your email')), resetEmail);
      expect(find.text(resetEmail), findsWidgets);

      final Finder reset = find.byKey(Key('reset link'));
      await tester.tap(reset);
      await tester.pump();

      // Expect to find the item on screen after clicking Skip
      expect(find.text('A password reset link is already sent to your email.'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      //clicking create account
      final Finder createAccount = find.text('Create an Account');
      await tester.tap(createAccount);
      await tester.pump();
      expect(find.text('Personal Account'), findsOneWidget);
    },
  );
}
