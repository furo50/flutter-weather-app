class SavedCityLocation {
  final String cityName;
  final double latitude;
  final double longitude;

  const SavedCityLocation({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {'cityName': cityName, 'latitude': latitude, 'longitude': longitude};
  }

  factory SavedCityLocation.fromJson(Map<String, dynamic> json) {
    return SavedCityLocation(
      cityName: json['cityName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
