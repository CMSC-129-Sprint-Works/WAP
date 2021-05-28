import 'package:flutter_test/flutter_test.dart';
import 'package:wap/welcome_slider.dart';

void main() {
	


testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
     await tester.pumpWidget(WelcomeSliderPage(title: 'T', description: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final descriptionFinder = find.text('M');
   

    expect(titleFinder, findsWidgets);
    expect(descriptionFinder, findsWidgets);
  });
}
