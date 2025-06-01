import 'package:flutter/material.dart';
import 'package:linos/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextDirection get textDirection => Directionality.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  AppLocalizations get l10n => AppLocalizations.of(this)!;
  Locale get locale => Localizations.localeOf(this);
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
  String get localeCode => locale.languageCode;
  String get localeCountryCode => locale.countryCode ?? '';
  String get localeLanguageCode => locale.languageCode;
}
