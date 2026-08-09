import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('Wetter App zeigt Startbildschirm an', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WeatherApp());

    expect(find.text('Hallo Wetter-App!'), findsOneWidget);
  });
}
