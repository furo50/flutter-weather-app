import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeviceLocationUnavailableException implements Exception {
  final String message;

  const DeviceLocationUnavailableException(this.message);

  @override
  String toString() => 'DeviceLocationUnavailableException: $message';
}

class ResolvedDeviceLocation {
  final double latitude;
  final double longitude;
  final String humanReadableLocationName;

  const ResolvedDeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.humanReadableLocationName,
  });
}

class DeviceLocationService {
  Future<ResolvedDeviceLocation> determineCurrentDeviceLocation() async {
    final bool areLocationServicesEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!areLocationServicesEnabled) {
      throw const DeviceLocationUnavailableException(
        'Standortdienste sind auf diesem Gerät deaktiviert.',
      );
    }

    LocationPermission currentPermissionStatus =
        await Geolocator.checkPermission();

    if (currentPermissionStatus == LocationPermission.denied) {
      currentPermissionStatus = await Geolocator.requestPermission();

      if (currentPermissionStatus == LocationPermission.denied) {
        throw const DeviceLocationUnavailableException(
          'Standortberechtigung wurde vom Nutzer abgelehnt.',
        );
      }
    }

    if (currentPermissionStatus == LocationPermission.deniedForever) {
      throw const DeviceLocationUnavailableException(
        'Standortberechtigung wurde dauerhaft verweigert.',
      );
    }

    final Position currentPosition = await Geolocator.getCurrentPosition();

    final String resolvedLocationName = await _resolveHumanReadableLocationName(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );

    return ResolvedDeviceLocation(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      humanReadableLocationName: resolvedLocationName,
    );
  }

  Future<String> _resolveHumanReadableLocationName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return 'Unbekannter Ort';
      }

      final Placemark firstPlacemark = placemarks.first;
      return firstPlacemark.locality?.isNotEmpty == true
          ? firstPlacemark.locality!
          : 'Unbekannter Ort';
    } catch (error) {
      // ignore: avoid_print
      print('Fehler beim Reverse-Geocoding: $error');
      return 'Unbekannter Ort';
    }
  }
}
