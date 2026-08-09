import 'current_weather_reading.dart';
import 'daily_forecast_entry.dart';
import 'hourly_forecast_entry.dart';

class LocationWeatherForecast {
  final String locationDisplayName;
  final CurrentWeatherReading currentWeatherReading;
  final List<HourlyForecastEntry> upcomingHourlyForecastEntries;
  final List<DailyForecastEntry> upcomingDailyForecastEntries;

  const LocationWeatherForecast({
    required this.locationDisplayName,
    required this.currentWeatherReading,
    required this.upcomingHourlyForecastEntries,
    required this.upcomingDailyForecastEntries,
  });

  factory LocationWeatherForecast.fromOpenMeteoJson({
    required Map<String, dynamic> json,
    required String locationDisplayName,
  }) {
    return LocationWeatherForecast(
      locationDisplayName: locationDisplayName,
      currentWeatherReading: CurrentWeatherReading.fromOpenMeteoJson(
        json['current'] as Map<String, dynamic>,
      ),
      upcomingHourlyForecastEntries: HourlyForecastEntry.fromOpenMeteoJson(
        json['hourly'] as Map<String, dynamic>,
      ),
      upcomingDailyForecastEntries: DailyForecastEntry.fromOpenMeteoJson(
        json['daily'] as Map<String, dynamic>,
      ),
    );
  }
}
