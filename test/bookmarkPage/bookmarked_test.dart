// ignore: unused_import
import 'dart:io';
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

      final Finder bookmark = find.byKey(Key('bookmarkPage2'));
      expect(bookmark, findsOneWidget);

      final Finder selectAll = find.byKey(Key('selectAll'));
      expect(selectAll, findsOneWidget);

      Finder deleteWarning = find.byKey(Key('deleteWarning3'));
      await tester.tap(deleteWarning);
      expect(find.text('Do you really want to delete the selected bookmark/s?'),
          findsOneWidget);
    },
  );
}
