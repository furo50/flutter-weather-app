import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/weather_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE');
  runApp(const WeatherApp());
}

class MouseDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wetter App',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MouseDragScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F80ED),
        brightness: Brightness.dark,
      ),
      home: const WeatherHomeScreen(),
    );
  }
}
