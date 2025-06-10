import 'dart:async';
import 'dart:ui';
import 'package:injectable/injectable.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/locale/cubit/locale_cubit.dart';
import 'package:linos/core/services/notification_service.dart';
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart';

@lazySingleton
class NotificationRefreshService {
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

      await _refreshAllFavoriteStopNotifications();
    } catch (e) {
      // Handle any errors that occur during the refresh
    }
  }

  Future<void> _refreshAllFavoriteStopNotifications() async {
    try {
      final tramStops = await _favoriteStopsRepository.getFavoriteTramStops();
      final busStops = await _favoriteStopsRepository.getFavoriteBusStops();

      for (final stop in [...tramStops, ...busStops]) {
        await _notificationService.scheduleNotificationsForFavoriteStop(stop);
      }
    } catch (e) {
      // Handle any errors that occur during the refresh
    }
  }

  void dispose() {
    _localeSubscription?.cancel();
  }
}
