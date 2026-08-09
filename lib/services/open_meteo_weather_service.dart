import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_weather_forecast.dart';

class WeatherDataFetchException implements Exception {
  final String message;

  const WeatherDataFetchException(this.message);

  @override
  String toString() => 'WeatherDataFetchException: $message';
}

class OpenMeteoWeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<LocationWeatherForecast> fetchForecastForCoordinates({
    required double latitude,
    required double longitude,
    required String locationDisplayName,
  }) async {
    final Uri requestUri = _buildForecastRequestUri(
      latitude: latitude,
      longitude: longitude,
    );

    final http.Response response = await http.get(requestUri);

    if (response.statusCode != 200) {
      throw WeatherDataFetchException(
        'Open-Meteo antwortete mit Statuscode ${response.statusCode}',
      );
    }

    final Map<String, dynamic> decodedResponseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    return LocationWeatherForecast.fromOpenMeteoJson(
      json: decodedResponseBody,
      locationDisplayName: locationDisplayName,
    );
  }

  Uri _buildForecastRequestUri({
    required double latitude,
    required double longitude,
  }) {
    return Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'timezone': 'auto',
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code',
        'hourly': 'temperature_2m,weather_code',
        'daily': 'temperature_2m_min,temperature_2m_max,weather_code',
      },
    );
  }
}
