import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/services/localization_service.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz_core;
import 'package:flutter_timezone/flutter_timezone.dart';

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz_core.setLocalLocation(tz_core.getLocation(currentTimeZone.identifier));

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      // Here you can handle navigation or other actions based on the payload
    }
  }

  Future<void> scheduleNotificationsForFavoriteStop(TransitStop favoriteStop) async {
    await cancelNotificationsForStop(favoriteStop.id);

    final TransitStopSchedule schedule = favoriteStop.schedule;
    final DateTime now = DateTime.now();
    final DateTime oneHourFromNow = now.add(const Duration(hours: 1));
    final tz_core.TZDateTime tzNow = tz_core.TZDateTime.from(now, tz_core.local);

    final localizationService = getIt<LocalizationService>();

    for (final entry in schedule.departureTimes) {
      final String time = entry.toIso8601String().substring(11, 16); // Extract HH:mm from ISO string
      final List<String> timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      DateTime departureDateTime = DateTime(now.year, now.month, now.day, hour, minute);

      if (departureDateTime.isBefore(now)) {
        departureDateTime = departureDateTime.add(const Duration(days: 1));
      }

      if (departureDateTime.isAfter(now) && departureDateTime.isBefore(oneHourFromNow)) {
        final tz_core.TZDateTime scheduledTime = tz_core.TZDateTime.from(departureDateTime, tz_core.local);
        final tz_core.TZDateTime notificationTime = scheduledTime.subtract(const Duration(minutes: 1));

        if (notificationTime.isAfter(tzNow)) {
          final int notificationId = ('${favoriteStop.id}_${hour}_$minute').hashCode;

          final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
            'linos_departures_channel',
            localizationService.notificationChannelName,
            channelDescription: localizationService.notificationChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            icon: '@mipmap/ic_launcher',
          );
          final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

          final message = localizationService.getNotificationMessage(favoriteStop.vehicleType, favoriteStop.name, time);

          await flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            favoriteStop.name,
            message,
            notificationTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: "stopId=${favoriteStop.id}&time=$time",
            matchDateTimeComponents: DateTimeComponents.time,
          );
        }
      }
    }
  }

  Future<void> cancelNotificationsForStop(String stopId) async {
    final List<PendingNotificationRequest> pendingRequests = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    for (final request in pendingRequests) {
      if (request.payload?.contains('stopId=$stopId') ?? false) {
        await flutterLocalNotificationsPlugin.cancel(request.id);
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cleanupExpiredNotifications() async {
    final List<PendingNotificationRequest> pendingRequests = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    final DateTime now = DateTime.now();

    for (final request in pendingRequests) {
      if (request.payload?.contains('time=') ?? false) {
        final timeMatch = RegExp(r'time=(\d{2}:\d{2})').firstMatch(request.payload!);
        if (timeMatch != null) {
          final timeString = timeMatch.group(1)!;
          final timeParts = timeString.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);

          final departureTime = DateTime(now.year, now.month, now.day, hour, minute);
          if (departureTime.isBefore(now)) {
            await flutterLocalNotificationsPlugin.cancel(request.id);
          }
        }
      }
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final settings = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();

      return settings ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
