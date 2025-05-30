import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hr'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'LinOS'**
  String get app_title;

  /// No description provided for @loginPage_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginPage_title;

  /// No description provided for @loginPage_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginPage_loginButton;

  /// No description provided for @loginPage_forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginPage_forgotPasswordButton;

  /// No description provided for @loginPage_createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginPage_createAccountButton;

  /// No description provided for @loginPage_error_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get loginPage_error_invalidCredentials;

  /// No description provided for @mainPage_unknownPage.
  ///
  /// In en, this message translates to:
  /// **'Unknown Page'**
  String get mainPage_unknownPage;

  /// No description provided for @mainPage_homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainPage_homeLabel;

  /// No description provided for @mainPage_ticketsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get mainPage_ticketsLabel;

  /// No description provided for @mainPage_linesLabel.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get mainPage_linesLabel;

  /// No description provided for @mainPage_scheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get mainPage_scheduleLabel;

  /// No description provided for @mainPage_settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainPage_settingsLabel;

  /// No description provided for @homePage_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get homePage_searchHint;

  /// No description provided for @homePage_popularDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Destinations'**
  String get homePage_popularDestinationsTitle;

  /// No description provided for @homePage_popularDestinationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick access to frequently visited places'**
  String get homePage_popularDestinationsSubtitle;

  /// No description provided for @homePage_osijekCitadelTitle.
  ///
  /// In en, this message translates to:
  /// **'Osijek Citadel'**
  String get homePage_osijekCitadelTitle;

  /// No description provided for @homePage_osijekCitadelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Historical site'**
  String get homePage_osijekCitadelSubtitle;

  /// No description provided for @homePage_kingTomislavSquareTitle.
  ///
  /// In en, this message translates to:
  /// **'King Tomislav Square'**
  String get homePage_kingTomislavSquareTitle;

  /// No description provided for @homePage_kingTomislavSquareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Beautiful park'**
  String get homePage_kingTomislavSquareSubtitle;

  /// No description provided for @homePage_shoppingCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Center'**
  String get homePage_shoppingCenterTitle;

  /// No description provided for @homePage_shoppingCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local shops and restaurants'**
  String get homePage_shoppingCenterSubtitle;

  /// No description provided for @homePage_startNavigationButton.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get homePage_startNavigationButton;

  /// No description provided for @linesPage_tramLinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Tram Lines'**
  String get linesPage_tramLinesTitle;

  /// No description provided for @linesPage_busLinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Bus Lines'**
  String get linesPage_busLinesTitle;

  /// No description provided for @linesPage_realTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Real-time Positions'**
  String get linesPage_realTimeButton;

  /// No description provided for @linesPage_viewScheduleButton.
  ///
  /// In en, this message translates to:
  /// **'View Schedule'**
  String get linesPage_viewScheduleButton;

  /// No description provided for @schedulePage_tramScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Tram Schedule'**
  String get schedulePage_tramScheduleTitle;

  /// No description provided for @schedulePage_busScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Bus Schedule'**
  String get schedulePage_busScheduleTitle;

  /// No description provided for @schedulePage_favoriteStopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite Stops'**
  String get schedulePage_favoriteStopsTitle;

  /// No description provided for @schedulePage_addFavoriteButton.
  ///
  /// In en, this message translates to:
  /// **'Add Favorite'**
  String get schedulePage_addFavoriteButton;

  /// No description provided for @schedulePage_selectStopLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Stop'**
  String get schedulePage_selectStopLabel;

  /// No description provided for @schedulePage_tramLineColumn.
  ///
  /// In en, this message translates to:
  /// **'Tram Line'**
  String get schedulePage_tramLineColumn;

  /// No description provided for @schedulePage_destinationColumn.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get schedulePage_destinationColumn;

  /// No description provided for @schedulePage_departureTimeColumn.
  ///
  /// In en, this message translates to:
  /// **'Departure Time'**
  String get schedulePage_departureTimeColumn;

  /// No description provided for @settingsPage_myProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get settingsPage_myProfileTitle;

  /// No description provided for @settingsPage_profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get settingsPage_profileSettingsTitle;

  /// No description provided for @settingsPage_profileSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile settings'**
  String get settingsPage_profileSettingsSubtitle;

  /// No description provided for @settingsPage_linkedCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Linked Cards'**
  String get settingsPage_linkedCardsTitle;

  /// No description provided for @settingsPage_linkedCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your linked cards'**
  String get settingsPage_linkedCardsSubtitle;

  /// No description provided for @settingsPage_purchaseHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get settingsPage_purchaseHistoryTitle;

  /// No description provided for @settingsPage_purchaseHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your purchase history'**
  String get settingsPage_purchaseHistorySubtitle;

  /// No description provided for @settingsPage_logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsPage_logoutTitle;

  /// No description provided for @settingsPage_logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account'**
  String get settingsPage_logoutSubtitle;

  /// No description provided for @settingsPage_languageRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get settingsPage_languageRegionTitle;

  /// No description provided for @settingsPage_appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsPage_appLanguageTitle;

  /// No description provided for @settingsPage_appLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get settingsPage_appLanguageSubtitle;

  /// No description provided for @settingsPage_currencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsPage_currencyTitle;

  /// No description provided for @settingsPage_currencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred currency'**
  String get settingsPage_currencySubtitle;

  /// No description provided for @settingsPage_notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsPage_notificationsTitle;

  /// No description provided for @settingsPage_delayNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delay Notifications'**
  String get settingsPage_delayNotificationsTitle;

  /// No description provided for @settingsPage_delayNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about delays'**
  String get settingsPage_delayNotificationsSubtitle;

  /// No description provided for @settingsPage_scheduleChangesNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Changes Notifications'**
  String get settingsPage_scheduleChangesNotificationsTitle;

  /// No description provided for @settingsPage_scheduleChangesNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about schedule changes'**
  String get settingsPage_scheduleChangesNotificationsSubtitle;

  /// No description provided for @settingsPage_soundAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Alerts'**
  String get settingsPage_soundAlertsTitle;

  /// No description provided for @settingsPage_soundAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable sound alerts for notifications'**
  String get settingsPage_soundAlertsSubtitle;

  /// No description provided for @settingsPage_specificLineNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Specific Line Notifications'**
  String get settingsPage_specificLineNotificationsTitle;

  /// No description provided for @settingsPage_specificLineNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for specific lines'**
  String get settingsPage_specificLineNotificationsSubtitle;

  /// No description provided for @settingsPage_changeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get settingsPage_changeLanguageTitle;

  /// No description provided for @settingsPage_changeLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred application language.'**
  String get settingsPage_changeLanguageSubtitle;

  /// No description provided for @ticketsPage_generatedTicketCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Generated Ticket Code'**
  String get ticketsPage_generatedTicketCodeTitle;

  /// No description provided for @ticketsPage_currentBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get ticketsPage_currentBalanceTitle;

  /// No description provided for @ticketsPage_balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get ticketsPage_balanceLabel;

  /// No description provided for @ticketsPage_buyDigitalTicketButton.
  ///
  /// In en, this message translates to:
  /// **'Buy Digital Ticket'**
  String get ticketsPage_buyDigitalTicketButton;

  /// No description provided for @ticketsPage_topUpBalanceButton.
  ///
  /// In en, this message translates to:
  /// **'Top Up Balance'**
  String get ticketsPage_topUpBalanceButton;

  /// No description provided for @ticketsPage_purchasedTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchased Tickets'**
  String get ticketsPage_purchasedTicketsTitle;

  /// No description provided for @ticketsPage_purchasedTicketsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your purchased tickets will appear here.'**
  String get ticketsPage_purchasedTicketsSubtitle;

  /// No description provided for @ticketsPage_viewTicketHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'View Ticket History'**
  String get ticketsPage_viewTicketHistoryButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @registerPage_title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerPage_title;

  /// No description provided for @validation_emailCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty.'**
  String get validation_emailCannotBeEmpty;

  /// No description provided for @validation_enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validation_enterValidEmail;

  /// No description provided for @validation_passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get validation_passwordCannotBeEmpty;

  /// No description provided for @validation_passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get validation_passwordTooShort;

  /// No description provided for @validation_confirmPasswordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password cannot be empty.'**
  String get validation_confirmPasswordCannotBeEmpty;

  /// No description provided for @validation_passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validation_passwordsDoNotMatch;

  /// No description provided for @validation_fixFormErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the form errors.'**
  String get validation_fixFormErrors;

  /// No description provided for @validation_unexpectedErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: '**
  String get validation_unexpectedErrorPrefix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hr':
      return AppLocalizationsHr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
