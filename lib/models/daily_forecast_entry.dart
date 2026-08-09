import 'weather_condition_code.dart';

class DailyForecastEntry {
  final DateTime forecastDate;
  final double minimumTemperatureInCelsius;
  final double maximumTemperatureInCelsius;
  final WeatherConditionCode conditionCode;

  const DailyForecastEntry({
    required this.forecastDate,
    required this.minimumTemperatureInCelsius,
    required this.maximumTemperatureInCelsius,
    required this.conditionCode,
  });

  static List<DailyForecastEntry> fromOpenMeteoJson(Map<String, dynamic> json) {
    final List<dynamic> dates = json['time'] as List<dynamic>;
    final List<dynamic> minimumTemperatures =
        json['temperature_2m_min'] as List<dynamic>;
    final List<dynamic> maximumTemperatures =
        json['temperature_2m_max'] as List<dynamic>;
    final List<dynamic> weatherCodes = json['weather_code'] as List<dynamic>;

    return List.generate(dates.length, (index) {
      return DailyForecastEntry(
        forecastDate: DateTime.parse(dates[index] as String),
        minimumTemperatureInCelsius: (minimumTemperatures[index] as num)
            .toDouble(),
        maximumTemperatureInCelsius: (maximumTemperatures[index] as num)
            .toDouble(),
        conditionCode: WeatherConditionCode(weatherCodes[index] as int),
      );
    });
  }
}
