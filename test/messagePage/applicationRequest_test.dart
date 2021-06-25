// ignore: unused_import
import 'dart:io';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ignore: unused_import
import 'package:flutter/widgets.dart';
import 'package:wap/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "full app test",
    (tester) async {
      await tester.pumpWidget(MyApp());

      //for "Do you want to accept this adoption application?
      //The pet profile will automatically be deleted after this."
      Finder deleteWarning = find.byKey(Key('deleteWarning3'));
      await tester.tap(deleteWarning);
      expect(find.text('Do you really want to delete the selected bookmark/s?'),
          findsOneWidget);

      //Do you want to deny this adoption application?
      Finder warning1 = find.byKey(Key('deleteWarning4'));
      await tester.tap(warning1);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      //Do you want to cancel this adoption application?
      Finder warning2 = find.byKey(Key('cancelWarning'));
      await tester.tap(warning2);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    },
  );
}
