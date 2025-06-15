import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_getDeviceLocale()) {
    _loadLocale();
  }

  static Locale _getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;

    final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == 'hr',
        orElse: () => AppLocalizations.supportedLocales.first,
      ),
    );

    return supportedLocale;
  }

  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    emit(locale);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString('locale');

    if (savedLocaleCode != null) {
      final savedLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == savedLocaleCode,
        orElse: () => _getDeviceLocale(),
      );
      emit(savedLocale);
      return;
    }
    emit(_getDeviceLocale());
  }
}
