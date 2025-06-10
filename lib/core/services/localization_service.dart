import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/l10n/app_localizations.dart';

@lazySingleton
class LocalizationService extends ChangeNotifier {
  AppLocalizations? _localizations;

  void initialize(AppLocalizations localizations) {
    _localizations = localizations;
  }

  AppLocalizations get l10n {
    if (_localizations == null) {
      throw Exception('LocalizationService not initialized. Call initialize() first.');
    }
    return _localizations!;
  }

  bool get isInitialized => _localizations != null;

  void updateLocalizations(AppLocalizations localizations) {
    final bool languageChanged = _localizations?.localeName != localizations.localeName;
    _localizations = localizations;

    if (languageChanged && _localizations != null) {
      notifyListeners();
    }
  }

  String getNotificationMessage(VehicleType vehicleType, String stopName, String time) {
    if (vehicleType == VehicleType.tram) {
      return l10n.notification_tramMessage(stopName, time);
    } else {
      return l10n.notification_busMessage(stopName, time);
    }
  }

  String get notificationChannelName => l10n.notification_channelName;

  String get notificationChannelDescription => l10n.notification_channelDescription;
}
