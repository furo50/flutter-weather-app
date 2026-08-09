import 'package:flutter/material.dart';

import '../models/weather_condition_code.dart';

class WeatherAdaptiveBackgroundGradient extends StatelessWidget {
  final WeatherConditionCode currentConditionCode;
  final bool isCurrentlyNighttime;
  final Widget child;

  const WeatherAdaptiveBackgroundGradient({
    super.key,
    required this.currentConditionCode,
    required this.isCurrentlyNighttime,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _determineGradientColorsForCurrentWeather(),
        ),
      ),
      child: child,
    );
  }

  List<Color> _determineGradientColorsForCurrentWeather() {
    if (isCurrentlyNighttime) {
      return const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)];
    }

    if (currentConditionCode.representsThunderstorm()) {
      return const [Color(0xFF232526), Color(0xFF414345)];
    }

    if (currentConditionCode.representsPrecipitation()) {
      return const [Color(0xFF4B6CB7), Color(0xFF182848)];
    }

    if (currentConditionCode.representsFriendlyWeather()) {
      return const [Color(0xFF56CCF2), Color(0xFF2F80ED)];
    }

    return const [Color(0xFF757F9A), Color(0xFFD7DDE8)];
  }
}
