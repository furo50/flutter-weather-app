import 'weather_condition_code.dart';

class HourlyForecastEntry {
  final DateTime forecastTime;
  final double temperatureInCelsius;
  final WeatherConditionCode conditionCode;

  const HourlyForecastEntry({
    required this.forecastTime,
    required this.temperatureInCelsius,
    required this.conditionCode,
  });

  static List<HourlyForecastEntry> fromOpenMeteoJson(
    Map<String, dynamic> json,
  ) {
    final List<dynamic> timestamps = json['time'] as List<dynamic>;
    final List<dynamic> temperatures = json['temperature_2m'] as List<dynamic>;
    final List<dynamic> weatherCodes = json['weather_code'] as List<dynamic>;

    return List.generate(timestamps.length, (index) {
      return HourlyForecastEntry(
        forecastTime: DateTime.parse(timestamps[index] as String),
        temperatureInCelsius: (temperatures[index] as num).toDouble(),
        conditionCode: WeatherConditionCode(weatherCodes[index] as int),
      );
    });
  }
}
