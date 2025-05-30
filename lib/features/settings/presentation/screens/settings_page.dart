import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(AppRouterConfig.login);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settingsPage_myProfileTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(context.l10n.settingsPage_profileSettingsTitle),
                      subtitle: Text(context.l10n.settingsPage_profileSettingsSubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text(context.l10n.settingsPage_linkedCardsTitle),
                      subtitle: Text(context.l10n.settingsPage_linkedCardsSubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.history),
                      title: Text(context.l10n.settingsPage_purchaseHistoryTitle),
                      subtitle: Text(context.l10n.settingsPage_purchaseHistorySubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(context.l10n.settingsPage_logoutTitle),
                      subtitle: Text(context.l10n.settingsPage_logoutSubtitle),
                      onTap: () {
                        context.read<AuthCubit>().signOut();
                      },
                    ),
                  ],
                ),
                Divider(height: 16.0, thickness: 1.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settingsPage_languageRegionTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text(context.l10n.settingsPage_appLanguageTitle),
                      subtitle: Text(context.l10n.settingsPage_appLanguageSubtitle),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(context.l10n.settingsPage_changeLanguageTitle),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(context.l10n.settingsPage_changeLanguageSubtitle),
                                  SizedBox(height: 16.0),
                                  DropdownButton<Locale>(
                                    value: context.locale,
                                    items: context.supportedLocales.map((Locale locale) {
                                      return DropdownMenuItem<Locale>(
                                        value: locale,
                                        child: Text(locale.languageCode.toUpperCase()),
                                      );
                                    }).toList(),
                                    onChanged: (Locale? newValue) {
                                      if (newValue != null && newValue != context.locale) {
                                        context.read<LocaleCubit>().changeLocale(newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.currency_exchange),
                      title: Text(context.l10n.settingsPage_currencyTitle),
                      subtitle: Text(context.l10n.settingsPage_currencySubtitle),
                      onTap: () {},
                    ),
                  ],
                ),
                Divider(height: 16.0, thickness: 1.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settingsPage_notificationsTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(context.l10n.settingsPage_delayNotificationsTitle),
                      subtitle: Text(context.l10n.settingsPage_delayNotificationsSubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_notifications),
                      title: Text(context.l10n.settingsPage_scheduleChangesNotificationsTitle),
                      subtitle: Text(context.l10n.settingsPage_scheduleChangesNotificationsSubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.volume_up),
                      title: Text(context.l10n.settingsPage_soundAlertsTitle),
                      subtitle: Text(context.l10n.settingsPage_soundAlertsSubtitle),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.directions),
                      title: Text(context.l10n.settingsPage_specificLineNotificationsTitle),
                      subtitle: Text(context.l10n.settingsPage_specificLineNotificationsSubtitle),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
