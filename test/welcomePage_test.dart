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

      //text finders

      expect(find.text('Welcome to WAP App'), findsOneWidget);
      expect(find.text('Mission'), findsOneWidget);
      expect(
          find.text(
              'WAP Application aims to create a virtual community that ensures the protection and welfare of cats and dogs by helping them find secure and responsible adoptive homes.'),
          findsOneWidget);

      expect(find.text('Vision'), findsOneWidget);
      expect(
          find.text(
              'Imagine a world in which every single pet can have the best protection and welfare that they deserve. That’s our commitment.'),
          findsOneWidget);

      //clicking Next Button
      final Finder nextButton1 = find.byKey(Key('clickNext1'));
      await tester.tap(nextButton1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(Key('clickNext')), findsOneWidget);

      //clicking skip Button
      final Finder skipButton1 = find.byKey(Key('clickSkip1'));
      await tester.tap(skipButton1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      // Expect to find the item on screen after clicking Skip
      expect(find.text('Login to WAP APP'), findsOneWidget);

      //clicking done Button
      final Finder doneButton1 = find.byKey(Key('clickDone1'));
      await tester.tap(doneButton1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      // Expect to find the item on screen after clicking Done
      expect(find.text('Login to WAP APP'), findsOneWidget);
    },
  );
}
