import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/hourly_forecast_entry.dart';

class HourlyForecastScrollList extends StatelessWidget {
  final List<HourlyForecastEntry> hourlyForecastEntries;

  const HourlyForecastScrollList({
    super.key,
    required this.hourlyForecastEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Stündlich'),
        const SizedBox(height: 12),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hourlyForecastEntries.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildSingleHourlyForecastTile(
                hourlyForecastEntries[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildSingleHourlyForecastTile(HourlyForecastEntry entry) {
    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.Hm().format(entry.forecastTime),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Icon(
            entry.conditionCode.toRepresentativeIcon(),
            color: Colors.white,
            size: 26,
          ),
          Text(
            '${entry.temperatureInCelsius.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
