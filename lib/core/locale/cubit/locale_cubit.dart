import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(AppLocalizations.supportedLocales.first) {
    _loadLocale();
  }

  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    emit(locale);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale') ?? AppLocalizations.supportedLocales.first.languageCode;
    emit(Locale(code));
  }
}
