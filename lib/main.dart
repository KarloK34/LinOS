import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linos/core/app_theme/app_theme.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/l10n/app_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  configureDependencies();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          title: 'LinOS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: getIt<AppRouterConfig>().router,
        );
      },
    );
  }
}
