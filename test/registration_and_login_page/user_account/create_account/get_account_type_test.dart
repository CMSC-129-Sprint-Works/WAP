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

      //get Account type personal/institutional
      final Finder personalAccount = find.byKey(Key('Personal'));
      await tester.tap(personalAccount);
      expect(personalAccount, findsOneWidget);

      final Finder institutionalAccount = find.byKey(Key('Institution'));
      await tester.tap(institutionalAccount);
      expect(institutionalAccount, findsOneWidget);
    },
  );
}
