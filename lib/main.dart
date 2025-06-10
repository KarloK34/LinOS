import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linos/core/app_theme/app_theme.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/services/notifications_refresh_service.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/l10n/app_localizations.dart';
import 'package:linos/core/services/localization_service.dart';
import 'package:linos/core/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz_core;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");
  configureDependencies();

  final notificationService = getIt<NotificationService>();
  await notificationService.init();

  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz_core.setLocalLocation(tz_core.getLocation(currentTimeZone));

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NotificationRefreshService _notificationRefreshService;

  @override
  void initState() {
    super.initState();
    _notificationRefreshService = getIt<NotificationRefreshService>();
  }

  @override
  void dispose() {
    _notificationRefreshService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        _notificationRefreshService.initialize(context.read<LocaleCubit>());
        return MaterialApp.router(
          title: 'LinOS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: getIt<AppRouterConfig>().router,
          builder: (context, child) {
            final localizations = AppLocalizations.of(context);
            if (localizations != null) {
              getIt<LocalizationService>().updateLocalizations(localizations);
            }
            return child!;
          },
        );
      },
    );
  }
}
