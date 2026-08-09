import 'package:flutter/material.dart';

import '../models/location_weather_forecast.dart';
import '../models/saved_city_location.dart';
import '../services/app_settings_storage_service.dart';
import '../services/device_location_service.dart';
import '../services/open_meteo_weather_service.dart';
import '../widgets/city_search_dialog.dart';
import '../widgets/current_weather_display_card.dart';
import '../widgets/daily_forecast_vertical_list.dart';
import '../widgets/hourly_forecast_scroll_list.dart';
import '../widgets/weather_adaptive_background_gradient.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final DeviceLocationService _deviceLocationService = DeviceLocationService();
  final OpenMeteoWeatherService _openMeteoWeatherService =
      OpenMeteoWeatherService();
  final AppSettingsStorageService _appSettingsStorageService =
      AppSettingsStorageService();
  final PageController _cityPageController = PageController();

  bool _isDisplayingFahrenheit = false;
  List<SavedCityLocation> _savedCityLocations = [];
  Map<int, Future<LocationWeatherForecast>> _forecastRequestsByPageIndex = {};
  int _currentVisiblePageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedTemperatureUnitPreference();
    _initializeCityLocationsWithCurrentDeviceLocation();
  }

  @override
  void dispose() {
    _cityPageController.dispose();
    super.dispose();
  }

  Future<void> _initializeCityLocationsWithCurrentDeviceLocation() async {
    final List<SavedCityLocation> additionallySavedCities =
        await _appSettingsStorageService.loadCityLocations();

    SavedCityLocation? currentDeviceLocationAsCity;
    try {
      final ResolvedDeviceLocation resolvedDeviceLocation =
          await _deviceLocationService.determineCurrentDeviceLocation();
      currentDeviceLocationAsCity = SavedCityLocation(
        cityName: resolvedDeviceLocation.humanReadableLocationName,
        latitude: resolvedDeviceLocation.latitude,
        longitude: resolvedDeviceLocation.longitude,
      );
    } on DeviceLocationUnavailableException {
      currentDeviceLocationAsCity = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _savedCityLocations = [
        if (currentDeviceLocationAsCity != null) currentDeviceLocationAsCity,
        ...additionallySavedCities,
      ];
      _forecastRequestsByPageIndex = {};
    });
  }

  Future<void> _loadSavedTemperatureUnitPreference() async {
    final bool savedPreference = await _appSettingsStorageService
        .loadTemperatureUnitPreference();

    if (!mounted) {
      return;
    }

    setState(() {
      _isDisplayingFahrenheit = savedPreference;
    });
  }

  Future<LocationWeatherForecast> _forecastForPageIndex(
    int pageIndex, {
    bool forceReload = false,
  }) {
    if (!forceReload && _forecastRequestsByPageIndex.containsKey(pageIndex)) {
      return _forecastRequestsByPageIndex[pageIndex]!;
    }

    final SavedCityLocation cityLocation = _savedCityLocations[pageIndex];
    final Future<LocationWeatherForecast> newRequest = _openMeteoWeatherService
        .fetchForecastForCoordinates(
          latitude: cityLocation.latitude,
          longitude: cityLocation.longitude,
          locationDisplayName: cityLocation.cityName,
        );

    _forecastRequestsByPageIndex[pageIndex] = newRequest;
    return newRequest;
  }

  Future<void> _openCitySearchDialogAndAddSelectedCity() async {
    final SavedCityLocation? selectedCity = await showDialog<SavedCityLocation>(
      context: context,
      builder: (context) => const CitySearchDialog(),
    );

    if (selectedCity == null) {
      return;
    }

    setState(() {
      _savedCityLocations = [..._savedCityLocations, selectedCity];
    });

    await _appSettingsStorageService.saveCityLocations(
      _savedCityLocations
          .skip(_hasCurrentDeviceLocationAsFirstEntry() ? 1 : 0)
          .toList(),
    );
  }

  bool _hasCurrentDeviceLocationAsFirstEntry() {
    return _savedCityLocations.isNotEmpty;
  }

  bool _determineIfCurrentlyNighttime() {
    final int currentHour = DateTime.now().hour;
    return currentHour < 6 || currentHour >= 20;
  }

  double _convertToDisplayedTemperatureUnit(double temperatureInCelsius) {
    if (_isDisplayingFahrenheit) {
      return (temperatureInCelsius * 9 / 5) + 32;
    }
    return temperatureInCelsius;
  }

  void _toggleTemperatureUnit() {
    setState(() {
      _isDisplayingFahrenheit = !_isDisplayingFahrenheit;
    });
    _appSettingsStorageService.saveTemperatureUnitPreference(
      _isDisplayingFahrenheit,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_savedCityLocations.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C5364),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildPageIndicatorDots(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleTemperatureUnit,
            icon: Text(
              _isDisplayingFahrenheit ? '°F' : '°C',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        elevation: 0,
        onPressed: _openCitySearchDialogAndAddSelectedCity,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: PageView.builder(
        controller: _cityPageController,
        itemCount: _savedCityLocations.length,
        onPageChanged: (newPageIndex) {
          setState(() {
            _currentVisiblePageIndex = newPageIndex;
          });
        },
        itemBuilder: (context, pageIndex) {
          return _buildSingleCityWeatherPage(pageIndex);
        },
      ),
    );
  }

  Widget _buildPageIndicatorDots() {
    if (_savedCityLocations.length <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_savedCityLocations.length, (index) {
        final bool isActiveDot = index == _currentVisiblePageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActiveDot ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isActiveDot ? 0.9 : 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildSingleCityWeatherPage(int pageIndex) {
    return FutureBuilder<LocationWeatherForecast>(
      future: _forecastForPageIndex(pageIndex),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ColoredBox(
            color: Color(0xFF2C5364),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasError) {
          return ColoredBox(
            color: const Color(0xFF2C5364),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fehler beim Laden: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _forecastRequestsByPageIndex.remove(pageIndex);
                      }),
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final LocationWeatherForecast forecast = snapshot.data!;
        final double displayedCurrentTemperature =
            _convertToDisplayedTemperatureUnit(
              forecast.currentWeatherReading.temperatureInCelsius,
            );

        return WeatherAdaptiveBackgroundGradient(
          currentConditionCode: forecast.currentWeatherReading.conditionCode,
          isCurrentlyNighttime: _determineIfCurrentlyNighttime(),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                final Future<LocationWeatherForecast> reloadedForecast =
                    _forecastForPageIndex(pageIndex, forceReload: true);
                setState(() {
                  _forecastRequestsByPageIndex[pageIndex] = reloadedForecast;
                });
                await reloadedForecast;
              },
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 32),
                children: [
                  CurrentWeatherDisplayCard(
                    locationDisplayName: forecast.locationDisplayName,
                    currentWeatherReading: forecast.currentWeatherReading,
                    displayedTemperatureRounded: displayedCurrentTemperature
                        .round(),
                    temperatureUnitSymbol: _isDisplayingFahrenheit
                        ? '°F'
                        : '°C',
                  ),
                  const SizedBox(height: 32),
                  HourlyForecastScrollList(
                    hourlyForecastEntries:
                        forecast.upcomingHourlyForecastEntries,
                  ),
                  const SizedBox(height: 24),
                  DailyForecastVerticalList(
                    dailyForecastEntries: forecast.upcomingDailyForecastEntries,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
