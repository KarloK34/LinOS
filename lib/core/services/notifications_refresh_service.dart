import 'dart:async';
import 'dart:ui';
import 'package:injectable/injectable.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/services/notification_service.dart';
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart';

@lazySingleton
class NotificationRefreshService {
  static const String _notificationsKey = 'transit_stop_notifications_enabled';

  late final NotificationService _notificationService;
  late final FirebaseFavoriteStopsRepository _favoriteStopsRepository;
  StreamSubscription<Locale>? _localeSubscription;

  NotificationRefreshService() {
    _notificationService = getIt<NotificationService>();
    _favoriteStopsRepository = getIt<FirebaseFavoriteStopsRepository>();
  }

  void initialize(LocaleCubit localeCubit) {
    _localeSubscription = localeCubit.stream.listen((locale) {
      _onLanguageChanged();
    });
  }

  Future<void> _onLanguageChanged() async {
    try {
      await _notificationService.cancelAllNotifications();
      await refreshNotificationsIfEnabled();
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> refreshNotificationsIfEnabled() async {
    try {
      await _notificationService.cleanupExpiredNotifications();

      if (!await _shouldScheduleNotifications()) {
        return;
      }

      await _refreshAllFavoriteStopNotifications();
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<bool> _shouldScheduleNotifications() async {
    try {
      final hasSystemPermission = await _notificationService.areNotificationsEnabled();
      if (!hasSystemPermission) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final appSettingEnabled = prefs.getBool(_notificationsKey) ?? true;

      return appSettingEnabled;
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
      return false;
    }
  }

  Future<void> _refreshAllFavoriteStopNotifications() async {
    try {
      final tramStops = await _favoriteStopsRepository.getFavoriteTramStops();
      final busStops = await _favoriteStopsRepository.getFavoriteBusStops();

      for (final stop in [...tramStops, ...busStops]) {
        await _notificationService.scheduleNotificationsForFavoriteStop(stop);
      }
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> forceRefreshAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      await _refreshAllFavoriteStopNotifications();
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
    } catch (e, stackTrace) {
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  void dispose() {
    _localeSubscription?.cancel();
  }
}
