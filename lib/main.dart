import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/app_theme/app_theme.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/navigation/app_routes.dart';
import 'package:linos/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider(create: (context) => LocaleCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'LinOS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: state,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRoutes.router,
        );
      },
    );
  }
}
