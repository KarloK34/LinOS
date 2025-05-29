// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get app_title => 'LinOS';

  @override
  String get loginPage_title => 'Prijava';

  @override
  String get loginPage_usernameHint => 'Korisničko ime';

  @override
  String get loginPage_passwordHint => 'Lozinka';

  @override
  String get loginPage_loginButton => 'Prijavi se';

  @override
  String get loginPage_forgotPasswordButton => 'Zaboravljena lozinka?';

  @override
  String get loginPage_createAccountButton => 'Registriraj se';

  @override
  String get loginPage_error_invalidCredentials =>
      'Nevažeće korisničko ime ili lozinka.';

  @override
  String get mainPage_unknownPage => 'Nepoznata stranica';

  @override
  String get mainPage_homeLabel => 'Početna';

  @override
  String get mainPage_ticketsLabel => 'Karte';

  @override
  String get mainPage_linesLabel => 'Linije';

  @override
  String get mainPage_scheduleLabel => 'Vozni red';

  @override
  String get mainPage_settingsLabel => 'Postavke';

  @override
  String get homePage_searchHint => 'Kamo želite ići?';

  @override
  String get homePage_popularDestinationsTitle => 'Popularna odredišta';

  @override
  String get homePage_popularDestinationsSubtitle =>
      'Brzi pristup često posjećenim mjestima';

  @override
  String get homePage_osijekCitadelTitle => 'Osječka Tvrđa';

  @override
  String get homePage_osijekCitadelSubtitle => 'Povijesno mjesto';

  @override
  String get homePage_kingTomislavSquareTitle => 'Trg kralja Tomislava';

  @override
  String get homePage_kingTomislavSquareSubtitle => 'Prekrasan park';

  @override
  String get homePage_shoppingCenterTitle => 'Trgovački centar';

  @override
  String get homePage_shoppingCenterSubtitle => 'Lokalne trgovine i restorani';

  @override
  String get homePage_startNavigationButton => 'Pokreni navigaciju';

  @override
  String get linesPage_tramLinesTitle => 'Tramvajske linije';

  @override
  String get linesPage_busLinesTitle => 'Autobusne linije';

  @override
  String get linesPage_realTimeButton => 'Položaji u stvarnom vremenu';

  @override
  String get linesPage_viewScheduleButton => 'Pogledaj vozni red';

  @override
  String get schedulePage_tramScheduleTitle => 'Vozni red tramvaja';

  @override
  String get schedulePage_busScheduleTitle => 'Vozni red autobusa';

  @override
  String get schedulePage_favoriteStopsTitle => 'Omiljene stanice';

  @override
  String get schedulePage_addFavoriteButton => 'Dodaj omiljenu';

  @override
  String get schedulePage_selectStopLabel => 'Odaberi stanicu';

  @override
  String get schedulePage_tramLineColumn => 'Tramvajska linija';

  @override
  String get schedulePage_destinationColumn => 'Odredište';

  @override
  String get schedulePage_departureTimeColumn => 'Vrijeme polaska';

  @override
  String get settingsPage_myProfileTitle => 'Moj profil';

  @override
  String get settingsPage_profileSettingsTitle => 'Postavke profila';

  @override
  String get settingsPage_profileSettingsSubtitle =>
      'Upravljajte postavkama svog profila';

  @override
  String get settingsPage_linkedCardsTitle => 'Povezane kartice';

  @override
  String get settingsPage_linkedCardsSubtitle =>
      'Upravljajte svojim povezanim karticama';

  @override
  String get settingsPage_purchaseHistoryTitle => 'Povijest kupovine';

  @override
  String get settingsPage_purchaseHistorySubtitle =>
      'Pregledajte svoju povijest kupovine';

  @override
  String get settingsPage_logoutTitle => 'Odjava';

  @override
  String get settingsPage_logoutSubtitle => 'Odjavite se sa svog računa';

  @override
  String get settingsPage_languageRegionTitle => 'Jezik i regija';

  @override
  String get settingsPage_appLanguageTitle => 'Jezik aplikacije';

  @override
  String get settingsPage_appLanguageSubtitle => 'Odaberite željeni jezik';

  @override
  String get settingsPage_currencyTitle => 'Valuta';

  @override
  String get settingsPage_currencySubtitle => 'Odaberite željenu valutu';

  @override
  String get settingsPage_notificationsTitle => 'Obavijesti';

  @override
  String get settingsPage_delayNotificationsTitle => 'Obavijesti o kašnjenju';

  @override
  String get settingsPage_delayNotificationsSubtitle =>
      'Primajte obavijesti o kašnjenjima';

  @override
  String get settingsPage_scheduleChangesNotificationsTitle =>
      'Obavijesti o promjenama voznog reda';

  @override
  String get settingsPage_scheduleChangesNotificationsSubtitle =>
      'Primajte obavijesti o promjenama voznog reda';

  @override
  String get settingsPage_soundAlertsTitle => 'Zvučna upozorenja';

  @override
  String get settingsPage_soundAlertsSubtitle =>
      'Omogućite zvučna upozorenja za obavijesti';

  @override
  String get settingsPage_specificLineNotificationsTitle =>
      'Obavijesti za određene linije';

  @override
  String get settingsPage_specificLineNotificationsSubtitle =>
      'Primajte obavijesti za određene linije';

  @override
  String get settingsPage_changeLanguageTitle => 'Promijeni jezik';

  @override
  String get settingsPage_changeLanguageSubtitle =>
      'Odaberite željeni jezik aplikacije.';

  @override
  String get ticketsPage_generatedTicketCodeTitle => 'Generirani kod karte';

  @override
  String get ticketsPage_currentBalanceTitle => 'Trenutno stanje';

  @override
  String get ticketsPage_balanceLabel => 'Stanje';

  @override
  String get ticketsPage_buyDigitalTicketButton => 'Kupi digitalnu kartu';

  @override
  String get ticketsPage_topUpBalanceButton => 'Nadoplati stanje';

  @override
  String get ticketsPage_purchasedTicketsTitle => 'Kupljene karte';

  @override
  String get ticketsPage_purchasedTicketsSubtitle =>
      'Vaše kupljene karte pojavit će se ovdje.';

  @override
  String get ticketsPage_viewTicketHistoryButton => 'Pogledaj povijest karata';

  @override
  String get cancelButton => 'Otkaži';

  @override
  String get confirmButton => 'Potvrdi';
}
