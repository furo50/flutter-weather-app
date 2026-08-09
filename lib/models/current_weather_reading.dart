import 'weather_condition_code.dart';

class CurrentWeatherReading {
  final double temperatureInCelsius;
  final double feelsLikeTemperatureInCelsius;
  final double windSpeedInKilometersPerHour;
  final int relativeHumidityInPercent;
  final WeatherConditionCode conditionCode;

  const CurrentWeatherReading({
    required this.temperatureInCelsius,
    required this.feelsLikeTemperatureInCelsius,
    required this.windSpeedInKilometersPerHour,
    required this.relativeHumidityInPercent,
    required this.conditionCode,
  });

  factory CurrentWeatherReading.fromOpenMeteoJson(Map<String, dynamic> json) {
    return CurrentWeatherReading(
      temperatureInCelsius: (json['temperature_2m'] as num).toDouble(),
      feelsLikeTemperatureInCelsius: (json['apparent_temperature'] as num)
          .toDouble(),
      windSpeedInKilometersPerHour: (json['wind_speed_10m'] as num).toDouble(),
      relativeHumidityInPercent: (json['relative_humidity_2m'] as num).toInt(),
      conditionCode: WeatherConditionCode(json['weather_code'] as int),
    );
  }
}
