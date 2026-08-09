import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/daily_forecast_entry.dart';

class DailyForecastVerticalList extends StatelessWidget {
  final List<DailyForecastEntry> dailyForecastEntries;

  const DailyForecastVerticalList({
    super.key,
    required this.dailyForecastEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '7-Tage-Vorhersage',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(dailyForecastEntries.length, (index) {
              return _buildSingleDailyForecastRow(
                dailyForecastEntries[index],
                isLastRow: index == dailyForecastEntries.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleDailyForecastRow(
    DailyForecastEntry entry, {
    required bool isLastRow,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        border: isLastRow
            ? null
            : Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              DateFormat.EEEE('de_DE').format(entry.forecastDate),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Icon(
            entry.conditionCode.toRepresentativeIcon(),
            color: Colors.white,
            size: 22,
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${entry.minimumTemperatureInCelsius.round()}° / '
              '${entry.maximumTemperatureInCelsius.round()}°',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
