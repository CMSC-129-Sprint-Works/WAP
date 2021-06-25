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

      Finder deleteWarning = find.byKey(Key('deleteWarning1'));
      await tester.tap(deleteWarning);
      expect(find.text('Do you really want to delete this conversation?'),
          findsOneWidget);
    },
  );
}
