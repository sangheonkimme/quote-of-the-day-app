import 'package:flutter_test/flutter_test.dart';
import 'package:daily_wisdom_flutter/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyWisdomApp());

    // Verify app title is shown
    expect(find.text('Daily Wisdom'), findsOneWidget);
  });
}
