import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/saved_city_location.dart';

class CitySearchService {
  static const String _baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<SavedCityLocation>> searchForCitiesByName(
    String searchQuery,
  ) async {
    if (searchQuery.trim().isEmpty) {
      return [];
    }

    final Uri requestUri = Uri.parse(_baseUrl).replace(
      queryParameters: {'name': searchQuery, 'count': '10', 'language': 'de'},
    );

    final http.Response response = await http.get(requestUri);

    if (response.statusCode != 200) {
      return [];
    }

    final Map<String, dynamic> decodedResponseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic>? searchResults =
        decodedResponseBody['results'] as List<dynamic>?;

    if (searchResults == null) {
      return [];
    }

    return searchResults.map((result) {
      final Map<String, dynamic> resultMap = result as Map<String, dynamic>;
      return SavedCityLocation(
        cityName: resultMap['name'] as String,
        latitude: (resultMap['latitude'] as num).toDouble(),
        longitude: (resultMap['longitude'] as num).toDouble(),
      );
    }).toList();
  }
}
