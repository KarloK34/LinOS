import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/services/notifications_refresh_service.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:app_settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/services/notification_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const String _notificationsKey = 'transit_stop_notifications_enabled';

  SettingsCubit() : super(const SettingsInitial());

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appSetting = prefs.getBool(_notificationsKey) ?? true;
      final notificationService = getIt<NotificationService>();

      final hasPermission = await notificationService.areNotificationsEnabled();
      final isEnabled = appSetting && hasPermission;

      emit(
        SettingsLoaded(
          transitStopNotificationsEnabled: isEnabled,
          hasSystemPermission: hasPermission,
          appSettingEnabled: appSetting,
        ),
      );
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(SettingsError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  Future<void> toggleTransitStopNotifications(bool enabled) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    if (enabled) {
      final permissionResult = await _requestNotificationPermission();
      if (!permissionResult) {
        return;
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, enabled);

      final notificationService = getIt<NotificationService>();
      final hasPermission = await notificationService.areNotificationsEnabled();

      emit(
        currentState.copyWith(
          transitStopNotificationsEnabled: enabled && hasPermission,
          appSettingEnabled: enabled,
          hasSystemPermission: hasPermission,
        ),
      );

      await _handleNotificationToggle(enabled);
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(SettingsError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  Future<bool> _requestNotificationPermission() async {
    try {
      final notificationService = getIt<NotificationService>();

      final granted = await notificationService.requestPermissions();

      if (!granted) {
        emit(const SettingsPermissionDenied());
        return false;
      }

      return true;
    } catch (e) {
      emit(const SettingsPermissionDenied());
      return false;
    }
  }

  Future<void> openAppSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
    await Future.delayed(const Duration(seconds: 1));
    await loadSettings();
  }

  Future<void> _handleNotificationToggle(bool enabled) async {
    final notificationRefreshService = getIt<NotificationRefreshService>();

    if (enabled) {
      await notificationRefreshService.forceRefreshAllNotifications();
    } else {
      await notificationRefreshService.cancelAllNotifications();
    }
  }
}
