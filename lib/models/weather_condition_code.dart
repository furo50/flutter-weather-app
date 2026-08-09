import 'package:flutter/material.dart';

class WeatherConditionCode {
  final int numericCode;

  const WeatherConditionCode(this.numericCode);

  String toHumanReadableDescription() {
    switch (numericCode) {
      case 0:
        return 'Klarer Himmel';
      case 1:
        return 'Überwiegend klar';
      case 2:
        return 'Teilweise bewölkt';
      case 3:
        return 'Bedeckt';
      case 45:
      case 48:
        return 'Nebel';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'Nieselregen';
      case 61:
        return 'Leichter Regen';
      case 63:
        return 'Mäßiger Regen';
      case 65:
        return 'Starker Regen';
      case 66:
      case 67:
        return 'Gefrierender Regen';
      case 71:
        return 'Leichter Schneefall';
      case 73:
        return 'Mäßiger Schneefall';
      case 75:
        return 'Starker Schneefall';
      case 77:
        return 'Schneegriesel';
      case 80:
      case 81:
      case 82:
        return 'Regenschauer';
      case 85:
      case 86:
        return 'Schneeschauer';
      case 95:
        return 'Gewitter';
      case 96:
      case 99:
        return 'Gewitter mit Hagel';
      default:
        return 'Unbekannte Wetterlage';
    }
  }

  IconData toRepresentativeIcon() {
    switch (numericCode) {
      case 0:
      case 1:
        return Icons.wb_sunny_rounded;
      case 2:
        return Icons.wb_cloudy_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain_rounded;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop_rounded;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  bool representsFriendlyWeather() {
    return numericCode == 0 || numericCode == 1 || numericCode == 2;
  }

  bool representsPrecipitation() {
    return const [
      51,
      53,
      55,
      56,
      57,
      61,
      63,
      65,
      66,
      67,
      71,
      73,
      75,
      77,
      80,
      81,
      82,
      85,
      86,
    ].contains(numericCode);
  }

  bool representsThunderstorm() {
    return numericCode == 95 || numericCode == 96 || numericCode == 99;
  }
}
