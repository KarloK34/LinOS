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
  String get homePage_navigationError =>
      'An error occurred while starting navigation.';

  @override
  String get homePage_noDestinationError =>
      'Please select a destination to start navigation.';

  @override
  String get homePage_locationError =>
      'Unable to access your location. Please check your device settings.';

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
  String get schedulePage_originColumn => 'Origin';

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
  String get ticketsPage_purchasedTicketsSubtitle =>
      'Your purchased tickets will appear here.';

  @override
  String get ticketsPage_title => 'Tickets';

  @override
  String get ticketsPage_activeTicketsTitle => 'Active Tickets';

  @override
  String get ticketsPage_purchaseTicketsTitle => 'Purchase Tickets';

  @override
  String get ticketsPage_purchasedTicketsTitle => 'Recent Purchases';

  @override
  String get ticketsPage_noActiveTickets => 'No active tickets';

  @override
  String get ticketsPage_purchasePrompt => 'Purchase a ticket to get started';

  @override
  String ticketsPage_viewTicketHistoryLabel(Object count) {
    return 'View All History ($count more)';
  }

  @override
  String get ticketsPage_refresh => 'Refresh';

  @override
  String get activeTicketCard_validUntilLabel => 'Valid until:';

  @override
  String get activeTicketCard_ticketIdLabel => 'Ticket ID:';

  @override
  String get activeTicketCard_tapToEnlarge => 'Tap to enlarge';

  @override
  String get activeTicketCard_expired => 'Expired';

  @override
  String get activeTicketCard_active => 'Active';

  @override
  String get qrCodeModal_title => 'Ticket QR Code';

  @override
  String get qrCodeModal_instructions =>
      'Show this code to the conductor when boarding';

  @override
  String get qrCodeModal_ticketIdPrefix => 'Ticket ID:';

  @override
  String get balanceCard_selectAmountMessage =>
      'Select amount to add to your balance:';

  @override
  String balanceCard_balanceAddedMessage(Object amount) {
    return 'Added $amount € to your balance';
  }

  @override
  String get purchaseButtons_confirmPurchaseTitle => 'Confirm Purchase';

  @override
  String purchaseButtons_confirmPurchaseMessage(
    Object price,
    Object ticketType,
  ) {
    return 'Purchase $ticketType for $price €?';
  }

  @override
  String get purchaseButtons_purchaseSuccessMessage =>
      'Ticket purchased successfully!';

  @override
  String purchaseButtons_validForDays(Object days) {
    return 'Valid for $days day';
  }

  @override
  String purchaseButtons_validForDaysPlural(Object days) {
    return 'Valid for $days days';
  }

  @override
  String purchaseButtons_validForHours(Object hours) {
    return 'Valid for $hours hour';
  }

  @override
  String purchaseButtons_validForHoursPlural(Object hours) {
    return 'Valid for $hours hours';
  }

  @override
  String purchaseButtons_validForMinutes(Object minutes) {
    return 'Valid for $minutes minutes';
  }

  @override
  String get ticketHistory_title => 'Ticket History';

  @override
  String get ticketHistory_noTicketHistory => 'No ticket history';

  @override
  String get ticketHistory_errorLoadingHistory => 'Error loading history';

  @override
  String get ticketHistory_loading => 'Loading...';

  @override
  String get ticketHistoryPage_title => 'Ticket History';

  @override
  String get ticketHistoryPage_filterLabel => 'Filter:';

  @override
  String get ticketHistoryPage_sortNewest => 'Newest First';

  @override
  String get ticketHistoryPage_sortOldest => 'Oldest First';

  @override
  String get ticketHistoryPage_sortPriceHigh => 'Price: High to Low';

  @override
  String get ticketHistoryPage_sortPriceLow => 'Price: Low to High';

  @override
  String ticketHistoryPage_ticketsCount(Object count) {
    return '$count ticket';
  }

  @override
  String ticketHistoryPage_ticketsCountPlural(Object count) {
    return '$count tickets';
  }

  @override
  String ticketHistoryPage_totalSpent(Object amount) {
    return 'Total spent: $amount €';
  }

  @override
  String get ticketHistoryPage_noTicketsFound => 'No tickets found';

  @override
  String get ticketHistoryPage_adjustFilters => 'Try adjusting your filters';

  @override
  String get ticketHistoryPage_clearFilters => 'Clear Filters';

  @override
  String get ticketHistoryPage_purchased => 'Purchased: ';

  @override
  String get ticketHistoryPage_validUntil => 'Valid Until: ';

  @override
  String get ticketHistoryPage_duration => 'Duration';

  @override
  String get ticketHistoryPage_status => 'Status';

  @override
  String get ticketHistoryPage_used => 'Used';

  @override
  String timeFormat_days(Object days, Object hours) {
    return '${days}d ${hours}h';
  }

  @override
  String timeFormat_hours(Object hours, Object minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String timeFormat_minutes(Object minutes) {
    return '${minutes}m';
  }

  @override
  String timeFormat_seconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String timeFormat_daysSingle(Object days) {
    return '$days day';
  }

  @override
  String timeFormat_daysPlural(Object days) {
    return '$days days';
  }

  @override
  String timeFormat_hoursSingle(Object hours) {
    return '$hours hour';
  }

  @override
  String timeFormat_hoursPlural(Object hours) {
    return '$hours hours';
  }

  @override
  String get error_insufficientBalance =>
      'Insufficient balance. Please add funds to your account.';

  @override
  String error_purchaseTicketFailed(Object error) {
    return 'Failed to purchase ticket: $error';
  }

  @override
  String error_addBalanceFailed(Object error) {
    return 'Failed to add balance: $error';
  }

  @override
  String error_loadUserDataFailed(Object error) {
    return 'Failed to load user data: $error';
  }

  @override
  String get error_loadingTickets => 'Error loading tickets';

  @override
  String error_useTicketFailed(Object error) {
    return 'Failed to use ticket: $error';
  }

  @override
  String get button_close => 'Close';

  @override
  String get button_retry => 'Retry';

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

  @override
  String get topUpBalance => 'Top Up Balance';

  @override
  String get singleRide => 'Single Ride';

  @override
  String get dailyPass => 'Daily Pass';

  @override
  String get weeklyPass => 'Weekly Pass';

  @override
  String get monthlyPass => 'Monthly Pass';

  @override
  String get all => 'All';

  @override
  String get error_connectionTimeout =>
      'Connection timeout. Please check your internet connection.';

  @override
  String get error_noInternet =>
      'No internet connection. Please check your network settings.';

  @override
  String get error_sessionExpired => 'Session expired. Please log in again.';

  @override
  String get error_accessDenied =>
      'Access denied. You don\'t have permission for this action.';

  @override
  String get error_resourceNotFound => 'Resource not found.';

  @override
  String get error_serverError => 'Server error. Please try again later.';

  @override
  String get error_requestFailed => 'Request failed. Please try again.';

  @override
  String get error_title => 'Error';

  @override
  String get location_services_disabled =>
      'Location services are disabled. Please enable them.';

  @override
  String get location_permissions_denied => 'Location permissions are denied.';

  @override
  String get location_permissions_denied_forever =>
      'Location permissions are permanently denied, we cannot request permissions.';

  @override
  String get location_failed_to_get =>
      'Failed to get location. Please check your device settings.';

  @override
  String get homePage_fixLocationFirst => 'Fix Location Error';

  @override
  String get homePage_selectDestinationFirst => 'Select Destination First';

  @override
  String get homePage_loadingLocation => 'Loading Location...';

  @override
  String get button_settings => 'Settings';

  @override
  String get linesPage_showVehicles => 'Show Live Vehicles';

  @override
  String get linesPage_hideVehicles => 'Hide Vehicles';

  @override
  String get schedulePage_errorLoadingSchedule =>
      'Error loading schedule. Please try again.';

  @override
  String get schedulePage_selectStopToViewSchedule =>
      'Select a stop to view the schedule.';

  @override
  String notification_departureTitle(String stopName) {
    return '$stopName';
  }

  @override
  String notification_tramMessage(String stopName, String time) {
    return 'Tram arriving at $stopName at $time';
  }

  @override
  String notification_busMessage(String stopName, String time) {
    return 'Bus arriving at $stopName at $time';
  }

  @override
  String get notification_channelName => 'Departure Alerts';

  @override
  String get notification_channelDescription =>
      'Notifications for upcoming public transport departures';
}
