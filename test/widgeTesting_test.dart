import 'package:flutter_test/flutter_test.dart';
import 'package:wap/welcome.dart';

void main() {
testWidgets('WelcomePage has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
     await tester.pumpWidget(WelcomePage(title: 'T'));

    // Create the Finders.
    final titleFinder = find.text('T');
   
   

    expect(titleFinder, findsOneWidget);
    
  });
}
