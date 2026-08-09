import 'package:flutter/material.dart';

import '../models/current_weather_reading.dart';

class CurrentWeatherDisplayCard extends StatelessWidget {
  final String locationDisplayName;
  final CurrentWeatherReading currentWeatherReading;
  final int displayedTemperatureRounded;
  final String temperatureUnitSymbol;

  const CurrentWeatherDisplayCard({
    super.key,
    required this.locationDisplayName,
    required this.currentWeatherReading,
    required this.displayedTemperatureRounded,
    required this.temperatureUnitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          locationDisplayName,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          currentWeatherReading.conditionCode.toHumanReadableDescription(),
          style: const TextStyle(fontSize: 15, color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Icon(
          currentWeatherReading.conditionCode.toRepresentativeIcon(),
          size: 110,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 24)],
        ),
        Text(
          '$displayedTemperatureRounded°',
          style: const TextStyle(
            fontSize: 84,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        _buildWeatherDetailsGlassCard(),
      ],
    );
  }

  Widget _buildWeatherDetailsGlassCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleWeatherDetailColumn(
            iconData: Icons.thermostat_rounded,
            label: 'Gefühlt',
            value:
                '${currentWeatherReading.feelsLikeTemperatureInCelsius.round()}°',
          ),
          _buildVerticalDivider(),
          _buildSingleWeatherDetailColumn(
            iconData: Icons.water_drop_outlined,
            label: 'Feuchtigkeit',
            value: '${currentWeatherReading.relativeHumidityInPercent}%',
          ),
          _buildVerticalDivider(),
          _buildSingleWeatherDetailColumn(
            iconData: Icons.air_rounded,
            label: 'Wind',
            value:
                '${currentWeatherReading.windSpeedInKilometersPerHour.round()} km/h',
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildSingleWeatherDetailColumn({
    required IconData iconData,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white60),
        ),
      ],
    );
  }
}
