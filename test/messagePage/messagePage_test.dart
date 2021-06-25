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

      //text finders
      Finder textMessage = find.byKey(Key('Messagepage'));
      expect(textMessage, findsOneWidget);

      Finder directMessage = find.byKey(Key('forDirect'));
      expect(directMessage, findsOneWidget);
      Finder directMessage1 = find.byKey(Key('messages1'));
      expect(directMessage1, findsOneWidget);

      Finder applicationRequest = find.byKey(Key('application'));
      expect(applicationRequest, findsOneWidget);
      Finder applicationRequest1 = find.byKey(Key('application1'));
      expect(applicationRequest1, findsOneWidget);

      Finder privateMessage = find.byKey(Key('private messages'));
      expect(privateMessage, findsOneWidget);

      Finder applicationMessage = find.byKey(Key('Application Messages'));
      expect(applicationMessage, findsOneWidget);

      Finder deleteWarning = find.byKey(Key('deleteWarning'));
      await tester.tap(deleteWarning);
      expect(find.text('Do you really want to delete this conversation?'),
          findsOneWidget);
    },
  );
}
