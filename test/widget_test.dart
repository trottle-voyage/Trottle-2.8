import 'package:flutter_test/flutter_test.dart';
import 'package:trottle/app.dart';

void main() {
  testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TrottleApp());
    expect(find.text('Trottle'), findsOneWidget);
    expect(find.text('Trottle 2.8'), findsOneWidget);
  });
}
