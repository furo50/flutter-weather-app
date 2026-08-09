import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_city_location.dart';

class AppSettingsStorageService {
  static const String _fahrenheitPreferenceKey = 'displays_fahrenheit';
  static const String _savedCitiesPreferenceKey = 'saved_cities';

  Future<void> saveTemperatureUnitPreference(bool displaysFahrenheit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_fahrenheitPreferenceKey, displaysFahrenheit);
  }

  Future<bool> loadTemperatureUnitPreference() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_fahrenheitPreferenceKey) ?? false;
  }

  Future<void> saveCityLocations(List<SavedCityLocation> cityLocations) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> encodedCities = cityLocations
        .map((city) => jsonEncode(city.toJson()))
        .toList();
    await preferences.setStringList(_savedCitiesPreferenceKey, encodedCities);
  }

  Future<List<SavedCityLocation>> loadCityLocations() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String>? encodedCities = preferences.getStringList(
      _savedCitiesPreferenceKey,
    );

    if (encodedCities == null) {
      return [];
    }

    return encodedCities
        .map(
          (encodedCity) => SavedCityLocation.fromJson(
            jsonDecode(encodedCity) as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
