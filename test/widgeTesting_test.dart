import 'package:flutter_test/flutter_test.dart';
import 'package:wap/welcome.dart';

void main() {
testWidgets('WelcomePage has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
     await tester.pumpWidget(_WelcomePageState(title: 'T', child: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final childFinder = find.text('M');
   

    expect(titleFinder, findsOneWidget);
    expect(childFinder, findsOneWidget);
  });
}
