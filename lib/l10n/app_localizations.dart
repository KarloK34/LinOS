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
  /// **'Don\'t have an account? Register'**
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

  /// No description provided for @homePage_noSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available.'**
  String get homePage_noSuggestions;

  /// No description provided for @homePage_noPopularDestinations.
  ///
  /// In en, this message translates to:
  /// **'No popular destinations available.'**
  String get homePage_noPopularDestinations;

  /// No description provided for @homePage_navigationError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while starting navigation.'**
  String get homePage_navigationError;

  /// No description provided for @homePage_noDestinationError.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination to start navigation.'**
  String get homePage_noDestinationError;

  /// No description provided for @homePage_locationError.
  ///
  /// In en, this message translates to:
  /// **'Unable to access your location. Please check your device settings.'**
  String get homePage_locationError;

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

  /// No description provided for @ticketsPage_purchasedTicketsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your purchased tickets will appear here.'**
  String get ticketsPage_purchasedTicketsSubtitle;

  /// No description provided for @ticketsPage_title.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get ticketsPage_title;

  /// No description provided for @ticketsPage_activeTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Tickets'**
  String get ticketsPage_activeTicketsTitle;

  /// No description provided for @ticketsPage_purchaseTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Tickets'**
  String get ticketsPage_purchaseTicketsTitle;

  /// No description provided for @ticketsPage_purchasedTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Purchases'**
  String get ticketsPage_purchasedTicketsTitle;

  /// No description provided for @ticketsPage_noActiveTickets.
  ///
  /// In en, this message translates to:
  /// **'No active tickets'**
  String get ticketsPage_noActiveTickets;

  /// No description provided for @ticketsPage_purchasePrompt.
  ///
  /// In en, this message translates to:
  /// **'Purchase a ticket to get started'**
  String get ticketsPage_purchasePrompt;

  /// No description provided for @ticketsPage_viewTicketHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'View All History ({count} more)'**
  String ticketsPage_viewTicketHistoryLabel(Object count);

  /// No description provided for @ticketsPage_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get ticketsPage_refresh;

  /// No description provided for @activeTicketCard_validUntilLabel.
  ///
  /// In en, this message translates to:
  /// **'Valid until:'**
  String get activeTicketCard_validUntilLabel;

  /// No description provided for @activeTicketCard_ticketIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID:'**
  String get activeTicketCard_ticketIdLabel;

  /// No description provided for @activeTicketCard_tapToEnlarge.
  ///
  /// In en, this message translates to:
  /// **'Tap to enlarge'**
  String get activeTicketCard_tapToEnlarge;

  /// No description provided for @activeTicketCard_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get activeTicketCard_expired;

  /// No description provided for @activeTicketCard_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTicketCard_active;

  /// No description provided for @qrCodeModal_title.
  ///
  /// In en, this message translates to:
  /// **'Ticket QR Code'**
  String get qrCodeModal_title;

  /// No description provided for @qrCodeModal_instructions.
  ///
  /// In en, this message translates to:
  /// **'Show this code to the conductor when boarding'**
  String get qrCodeModal_instructions;

  /// No description provided for @qrCodeModal_ticketIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID:'**
  String get qrCodeModal_ticketIdPrefix;

  /// No description provided for @balanceCard_selectAmountMessage.
  ///
  /// In en, this message translates to:
  /// **'Select amount to add to your balance:'**
  String get balanceCard_selectAmountMessage;

  /// No description provided for @balanceCard_balanceAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Added {amount} € to your balance'**
  String balanceCard_balanceAddedMessage(Object amount);

  /// No description provided for @purchaseButtons_confirmPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get purchaseButtons_confirmPurchaseTitle;

  /// No description provided for @purchaseButtons_confirmPurchaseMessage.
  ///
  /// In en, this message translates to:
  /// **'Purchase {ticketType} for {price} €?'**
  String purchaseButtons_confirmPurchaseMessage(
    Object price,
    Object ticketType,
  );

  /// No description provided for @purchaseButtons_purchaseSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Ticket purchased successfully!'**
  String get purchaseButtons_purchaseSuccessMessage;

  /// No description provided for @purchaseButtons_validForDays.
  ///
  /// In en, this message translates to:
  /// **'Valid for {days} day'**
  String purchaseButtons_validForDays(Object days);

  /// No description provided for @purchaseButtons_validForDaysPlural.
  ///
  /// In en, this message translates to:
  /// **'Valid for {days} days'**
  String purchaseButtons_validForDaysPlural(Object days);

  /// No description provided for @purchaseButtons_validForHours.
  ///
  /// In en, this message translates to:
  /// **'Valid for {hours} hour'**
  String purchaseButtons_validForHours(Object hours);

  /// No description provided for @purchaseButtons_validForHoursPlural.
  ///
  /// In en, this message translates to:
  /// **'Valid for {hours} hours'**
  String purchaseButtons_validForHoursPlural(Object hours);

  /// No description provided for @purchaseButtons_validForMinutes.
  ///
  /// In en, this message translates to:
  /// **'Valid for {minutes} minutes'**
  String purchaseButtons_validForMinutes(Object minutes);

  /// No description provided for @ticketHistory_title.
  ///
  /// In en, this message translates to:
  /// **'Ticket History'**
  String get ticketHistory_title;

  /// No description provided for @ticketHistory_noTicketHistory.
  ///
  /// In en, this message translates to:
  /// **'No ticket history'**
  String get ticketHistory_noTicketHistory;

  /// No description provided for @ticketHistory_errorLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get ticketHistory_errorLoadingHistory;

  /// No description provided for @ticketHistory_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get ticketHistory_loading;

  /// No description provided for @ticketHistoryPage_title.
  ///
  /// In en, this message translates to:
  /// **'Ticket History'**
  String get ticketHistoryPage_title;

  /// No description provided for @ticketHistoryPage_filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get ticketHistoryPage_filterLabel;

  /// No description provided for @ticketHistoryPage_sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get ticketHistoryPage_sortNewest;

  /// No description provided for @ticketHistoryPage_sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get ticketHistoryPage_sortOldest;

  /// No description provided for @ticketHistoryPage_sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get ticketHistoryPage_sortPriceHigh;

  /// No description provided for @ticketHistoryPage_sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get ticketHistoryPage_sortPriceLow;

  /// No description provided for @ticketHistoryPage_ticketsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ticket'**
  String ticketHistoryPage_ticketsCount(Object count);

  /// No description provided for @ticketHistoryPage_ticketsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} tickets'**
  String ticketHistoryPage_ticketsCountPlural(Object count);

  /// No description provided for @ticketHistoryPage_totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent: {amount} €'**
  String ticketHistoryPage_totalSpent(Object amount);

  /// No description provided for @ticketHistoryPage_noTicketsFound.
  ///
  /// In en, this message translates to:
  /// **'No tickets found'**
  String get ticketHistoryPage_noTicketsFound;

  /// No description provided for @ticketHistoryPage_adjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get ticketHistoryPage_adjustFilters;

  /// No description provided for @ticketHistoryPage_clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get ticketHistoryPage_clearFilters;

  /// No description provided for @ticketHistoryPage_purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased: '**
  String get ticketHistoryPage_purchased;

  /// No description provided for @ticketHistoryPage_validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until: '**
  String get ticketHistoryPage_validUntil;

  /// No description provided for @ticketHistoryPage_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get ticketHistoryPage_duration;

  /// No description provided for @ticketHistoryPage_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ticketHistoryPage_status;

  /// No description provided for @ticketHistoryPage_used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get ticketHistoryPage_used;

  /// No description provided for @timeFormat_days.
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h'**
  String timeFormat_days(Object days, Object hours);

  /// No description provided for @timeFormat_hours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String timeFormat_hours(Object hours, Object minutes);

  /// No description provided for @timeFormat_minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String timeFormat_minutes(Object minutes);

  /// No description provided for @timeFormat_seconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String timeFormat_seconds(Object seconds);

  /// No description provided for @timeFormat_daysSingle.
  ///
  /// In en, this message translates to:
  /// **'{days} day'**
  String timeFormat_daysSingle(Object days);

  /// No description provided for @timeFormat_daysPlural.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String timeFormat_daysPlural(Object days);

  /// No description provided for @timeFormat_hoursSingle.
  ///
  /// In en, this message translates to:
  /// **'{hours} hour'**
  String timeFormat_hoursSingle(Object hours);

  /// No description provided for @timeFormat_hoursPlural.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours'**
  String timeFormat_hoursPlural(Object hours);

  /// No description provided for @error_insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance. Please add funds to your account.'**
  String get error_insufficientBalance;

  /// No description provided for @error_purchaseTicketFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to purchase ticket: {error}'**
  String error_purchaseTicketFailed(Object error);

  /// No description provided for @error_addBalanceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add balance: {error}'**
  String error_addBalanceFailed(Object error);

  /// No description provided for @error_loadUserDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data: {error}'**
  String error_loadUserDataFailed(Object error);

  /// No description provided for @error_loadingTickets.
  ///
  /// In en, this message translates to:
  /// **'Error loading tickets'**
  String get error_loadingTickets;

  /// No description provided for @error_useTicketFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to use ticket: {error}'**
  String error_useTicketFailed(Object error);

  /// No description provided for @button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get button_close;

  /// No description provided for @button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get button_retry;

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

  /// No description provided for @auth_error_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get auth_error_userNotFound;

  /// No description provided for @auth_error_wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided.'**
  String get auth_error_wrongPassword;

  /// No description provided for @auth_error_emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use.'**
  String get auth_error_emailAlreadyInUse;

  /// No description provided for @auth_error_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address is invalid.'**
  String get auth_error_invalidEmail;

  /// No description provided for @auth_error_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get auth_error_weakPassword;

  /// No description provided for @auth_error_userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user has been disabled.'**
  String get auth_error_userDisabled;

  /// No description provided for @auth_error_tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get auth_error_tooManyRequests;

  /// No description provided for @auth_error_default.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get auth_error_default;

  /// No description provided for @forgotPassword_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password.'**
  String get forgotPassword_description;

  /// No description provided for @forgotPassword_successMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful. Please check your email for a new login link.'**
  String get forgotPassword_successMessage;

  /// No description provided for @forgotPassword_resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPassword_resetButton;

  /// No description provided for @registerPage_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get registerPage_loginButton;

  /// No description provided for @searchBar_startSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get searchBar_startSearchHint;

  /// No description provided for @searchBar_searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searchBar_searching;

  /// No description provided for @searchBar_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while searching. Please try again.'**
  String get searchBar_error;

  /// No description provided for @topUpBalance.
  ///
  /// In en, this message translates to:
  /// **'Top Up Balance'**
  String get topUpBalance;

  /// No description provided for @singleRide.
  ///
  /// In en, this message translates to:
  /// **'Single Ride'**
  String get singleRide;

  /// No description provided for @dailyPass.
  ///
  /// In en, this message translates to:
  /// **'Daily Pass'**
  String get dailyPass;

  /// No description provided for @weeklyPass.
  ///
  /// In en, this message translates to:
  /// **'Weekly Pass'**
  String get weeklyPass;

  /// No description provided for @monthlyPass.
  ///
  /// In en, this message translates to:
  /// **'Monthly Pass'**
  String get monthlyPass;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @error_connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get error_connectionTimeout;

  /// No description provided for @error_noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get error_noInternet;

  /// No description provided for @error_sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get error_sessionExpired;

  /// No description provided for @error_accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied. You don\'t have permission for this action.'**
  String get error_accessDenied;

  /// No description provided for @error_resourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get error_resourceNotFound;

  /// No description provided for @error_serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_serverError;

  /// No description provided for @error_requestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed. Please try again.'**
  String get error_requestFailed;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_title;

  /// No description provided for @location_services_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them.'**
  String get location_services_disabled;

  /// No description provided for @location_permissions_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get location_permissions_denied;

  /// No description provided for @location_permissions_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get location_permissions_denied_forever;

  /// No description provided for @location_failed_to_get.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location. Please check your device settings.'**
  String get location_failed_to_get;

  /// No description provided for @homePage_fixLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'Fix Location Error'**
  String get homePage_fixLocationFirst;

  /// No description provided for @homePage_selectDestinationFirst.
  ///
  /// In en, this message translates to:
  /// **'Select Destination First'**
  String get homePage_selectDestinationFirst;

  /// No description provided for @homePage_loadingLocation.
  ///
  /// In en, this message translates to:
  /// **'Loading Location...'**
  String get homePage_loadingLocation;

  /// No description provided for @button_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get button_settings;

  /// No description provided for @linesPage_showVehicles.
  ///
  /// In en, this message translates to:
  /// **'Show Live Vehicles'**
  String get linesPage_showVehicles;

  /// No description provided for @linesPage_hideVehicles.
  ///
  /// In en, this message translates to:
  /// **'Hide Vehicles'**
  String get linesPage_hideVehicles;
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
