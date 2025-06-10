import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:linos/features/settings/presentation/cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              context.go(AppRouterConfig.login);
            }
          },
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              final errorMessage = AppErrorHandler.getLocalizedMessage(context, state.errorKey);
              AppErrorHandler.showErrorSnackBar(context, errorMessage);
            }
          },
        ),
      ],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileSection(),
                Divider(height: 16.0, thickness: 1.0),
                _LanguageSection(),
                Divider(height: 16.0, thickness: 1.0),
                _NotificationsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.settingsPage_notificationsTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsPermissionDenied) {
              _showPermissionDeniedDialog(context);
            }
          },
          builder: (context, state) {
            final isEnabled = state is SettingsLoaded ? state.transitStopNotificationsEnabled : false;
            final isLoading = state is SettingsInitial;
            final hasPermission = state is SettingsLoaded ? state.hasSystemPermission : true;

            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: isEnabled && hasPermission ? context.theme.colorScheme.primary : Colors.grey,
                  ),
                  title: Text(context.l10n.settingsPage_transitStopNotificationsTitle),
                  subtitle: Text(_getSubtitleText(context, isEnabled, hasPermission)),
                  trailing: isLoading
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Switch(
                          padding: EdgeInsets.zero,
                          value: isEnabled,
                          onChanged: (value) {
                            value
                                ? context.read<SettingsCubit>().toggleTransitStopNotifications(true)
                                : context.read<SettingsCubit>().toggleTransitStopNotifications(false);
                          },
                        ),
                ),

                if (state is SettingsLoaded && !state.hasSystemPermission && state.appSettingEnabled)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.settingsPage_permissionRequired,
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.read<SettingsCubit>().openAppSettings(),
                          child: Text(context.l10n.settingsPage_openSettings),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _getSubtitleText(BuildContext context, bool isEnabled, bool hasPermission) {
    if (!hasPermission && isEnabled) {
      return context.l10n.settingsPage_permissionDenied;
    } else if (!isEnabled) {
      return context.l10n.settingsPage_notificationsDisabled;
    } else {
      return context.l10n.settingsPage_transitStopNotificationsSubtitle;
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.settingsPage_permissionDeniedTitle),
        content: Text(context.l10n.settingsPage_permissionDeniedMessage),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(context.l10n.cancelButton)),
          TextButton(
            onPressed: () {
              context.pop();
              context.read<SettingsCubit>().openAppSettings();
            },
            child: Text(context.l10n.settingsPage_openSettings),
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.settingsPage_changeLanguageTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.settingsPage_changeLanguageSubtitle),
            SizedBox(height: 16.0),
            ...context.supportedLocales.map(
              (locale) => RadioListTile<Locale>(
                title: Text(_getLanguageName(locale, context)),
                value: locale,
                groupValue: context.locale,
                onChanged: (Locale? newValue) {
                  if (newValue != null && newValue != context.locale) {
                    context.read<LocaleCubit>().changeLocale(newValue);
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => context.pop(), child: Text(context.l10n.cancelButton))],
      ),
    );
  }

  String _getLanguageName(Locale locale, BuildContext context) {
    switch (locale.languageCode) {
      case 'en':
        return context.l10n.settingsPage_languageEnglish;
      case 'hr':
        return context.l10n.settingsPage_languageCroatian;
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.settingsPage_myProfileTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(context.l10n.settingsPage_profileSettingsTitle),
          subtitle: Text(context.l10n.settingsPage_profileSettingsSubtitle),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text(context.l10n.settingsPage_purchaseHistoryTitle),
          subtitle: Text(context.l10n.settingsPage_purchaseHistorySubtitle),
          onTap: () {
            context.go(AppRouterConfig.ticketsHistory);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(context.l10n.settingsPage_logoutTitle),
          subtitle: Text(context.l10n.settingsPage_logoutSubtitle),
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.settingsPage_logoutTitle),
        content: Text(context.l10n.settingsPage_logoutConfirmation),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(context.l10n.cancelButton)),
          TextButton(
            onPressed: () {
              context.pop();
              context.read<AuthCubit>().signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.button_logOut),
          ),
        ],
      ),
    );
  }
}
