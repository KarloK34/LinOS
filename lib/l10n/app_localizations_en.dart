// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'LinOS';

  @override
  String get loginPage_title => 'Login';

  @override
  String get loginPage_loginButton => 'Login';

  @override
  String get loginPage_forgotPasswordButton => 'Forgot Password?';

  @override
  String get loginPage_createAccountButton =>
      'Don\'t have an account? Register';

  @override
  String get loginPage_error_invalidCredentials => 'Invalid email or password.';

  @override
  String get mainPage_unknownPage => 'Unknown Page';

  @override
  String get mainPage_homeLabel => 'Home';

  @override
  String get mainPage_ticketsLabel => 'Tickets';

  @override
  String get mainPage_linesLabel => 'Lines';

  @override
  String get mainPage_scheduleLabel => 'Schedule';

  @override
  String get mainPage_settingsLabel => 'Settings';

  @override
  String get homePage_searchHint => 'Where do you want to go?';

  @override
  String get homePage_popularDestinationsTitle => 'Popular Destinations';

  @override
  String get homePage_popularDestinationsSubtitle =>
      'Quick access to frequently visited places';

  @override
  String get homePage_osijekCitadelTitle => 'Osijek Citadel';

  @override
  String get homePage_osijekCitadelSubtitle => 'Historical site';

  @override
  String get homePage_kingTomislavSquareTitle => 'King Tomislav Square';

  @override
  String get homePage_kingTomislavSquareSubtitle => 'Beautiful park';

  @override
  String get homePage_shoppingCenterTitle => 'Shopping Center';

  @override
  String get homePage_shoppingCenterSubtitle => 'Local shops and restaurants';

  @override
  String get homePage_startNavigationButton => 'Start Navigation';

  @override
  String get homePage_noSuggestions => 'No suggestions available.';

  @override
  String get homePage_noPopularDestinations =>
      'No popular destinations available.';

  @override
  String get linesPage_tramLinesTitle => 'Tram Lines';

  @override
  String get linesPage_busLinesTitle => 'Bus Lines';

  @override
  String get linesPage_realTimeButton => 'Real-time Positions';

  @override
  String get linesPage_viewScheduleButton => 'View Schedule';

  @override
  String get schedulePage_tramScheduleTitle => 'Tram Schedule';

  @override
  String get schedulePage_busScheduleTitle => 'Bus Schedule';

  @override
  String get schedulePage_favoriteStopsTitle => 'Favorite Stops';

  @override
  String get schedulePage_addFavoriteButton => 'Add Favorite';

  @override
  String get schedulePage_selectStopLabel => 'Select Stop';

  @override
  String get schedulePage_tramLineColumn => 'Tram Line';

  @override
  String get schedulePage_destinationColumn => 'Destination';

  @override
  String get schedulePage_departureTimeColumn => 'Departure Time';

  @override
  String get settingsPage_myProfileTitle => 'My Profile';

  @override
  String get settingsPage_profileSettingsTitle => 'Profile Settings';

  @override
  String get settingsPage_profileSettingsSubtitle =>
      'Manage your profile settings';

  @override
  String get settingsPage_linkedCardsTitle => 'Linked Cards';

  @override
  String get settingsPage_linkedCardsSubtitle => 'Manage your linked cards';

  @override
  String get settingsPage_purchaseHistoryTitle => 'Purchase History';

  @override
  String get settingsPage_purchaseHistorySubtitle =>
      'View your purchase history';

  @override
  String get settingsPage_logoutTitle => 'Log out';

  @override
  String get settingsPage_logoutSubtitle => 'Log out of your account';

  @override
  String get settingsPage_languageRegionTitle => 'Language & Region';

  @override
  String get settingsPage_appLanguageTitle => 'App Language';

  @override
  String get settingsPage_appLanguageSubtitle =>
      'Select your preferred language';

  @override
  String get settingsPage_currencyTitle => 'Currency';

  @override
  String get settingsPage_currencySubtitle => 'Select your preferred currency';

  @override
  String get settingsPage_notificationsTitle => 'Notifications';

  @override
  String get settingsPage_delayNotificationsTitle => 'Delay Notifications';

  @override
  String get settingsPage_delayNotificationsSubtitle =>
      'Receive notifications about delays';

  @override
  String get settingsPage_scheduleChangesNotificationsTitle =>
      'Schedule Changes Notifications';

  @override
  String get settingsPage_scheduleChangesNotificationsSubtitle =>
      'Receive notifications about schedule changes';

  @override
  String get settingsPage_soundAlertsTitle => 'Sound Alerts';

  @override
  String get settingsPage_soundAlertsSubtitle =>
      'Enable sound alerts for notifications';

  @override
  String get settingsPage_specificLineNotificationsTitle =>
      'Specific Line Notifications';

  @override
  String get settingsPage_specificLineNotificationsSubtitle =>
      'Receive notifications for specific lines';

  @override
  String get settingsPage_changeLanguageTitle => 'Change Language';

  @override
  String get settingsPage_changeLanguageSubtitle =>
      'Select your preferred application language.';

  @override
  String get ticketsPage_generatedTicketCodeTitle => 'Generated Ticket Code';

  @override
  String get ticketsPage_currentBalanceTitle => 'Current Balance';

  @override
  String get ticketsPage_balanceLabel => 'Balance';

  @override
  String get ticketsPage_buyDigitalTicketButton => 'Buy Digital Ticket';

  @override
  String get ticketsPage_topUpBalanceButton => 'Top Up Balance';

  @override
  String get ticketsPage_purchasedTicketsTitle => 'Purchased Tickets';

  @override
  String get ticketsPage_purchasedTicketsSubtitle =>
      'Your purchased tickets will appear here.';

  @override
  String get ticketsPage_viewTicketHistoryButton => 'View Ticket History';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get registerButton => 'Register';

  @override
  String get registerPage_title => 'Create Account';

  @override
  String get validation_emailCannotBeEmpty => 'Email cannot be empty.';

  @override
  String get validation_enterValidEmail => 'Enter a valid email address.';

  @override
  String get validation_passwordCannotBeEmpty => 'Password cannot be empty.';

  @override
  String get validation_passwordTooShort =>
      'Password must be at least 6 characters long.';

  @override
  String get validation_confirmPasswordCannotBeEmpty =>
      'Confirm Password cannot be empty.';

  @override
  String get validation_passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get validation_fixFormErrors => 'Please fix the form errors.';

  @override
  String get validation_unexpectedErrorPrefix =>
      'An unexpected error occurred: ';

  @override
  String get auth_error_userNotFound => 'No user found with this email.';

  @override
  String get auth_error_wrongPassword => 'Wrong password provided.';

  @override
  String get auth_error_emailAlreadyInUse => 'Email is already in use.';

  @override
  String get auth_error_invalidEmail => 'Email address is invalid.';

  @override
  String get auth_error_weakPassword => 'Password is too weak.';

  @override
  String get auth_error_userDisabled => 'This user has been disabled.';

  @override
  String get auth_error_tooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get auth_error_default => 'An error occurred. Please try again.';

  @override
  String get forgotPassword_title => 'Forgot Password';

  @override
  String get forgotPassword_description =>
      'Enter your email to reset your password.';

  @override
  String get forgotPassword_successMessage =>
      'Password reset successful. Please check your email for a new login link.';

  @override
  String get forgotPassword_resetButton => 'Reset Password';

  @override
  String get registerPage_loginButton => 'Already have an account? Login';

  @override
  String get searchBar_startSearchHint => 'Start typing to search...';

  @override
  String get searchBar_searching => 'Searching...';

  @override
  String get searchBar_error =>
      'An error occurred while searching. Please try again.';
}
