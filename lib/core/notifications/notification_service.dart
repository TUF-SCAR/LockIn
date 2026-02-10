import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationService {
  static const String azifastChannelId = 'azifast_channel';
  static const int azifastId = 1001;

  static const String actionTaken = 'AZI_TAKEN';
  static const String actionSnooze = 'AZI_SNOOZE';
  static const String actionSkip = 'AZI_SKIP';

  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) async {
        final actionId = resp.actionId;
        if (actionId == null || actionId.isEmpty) return;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('azifast_last_action', actionId);
        await prefs.setString('azifast_last_action_time', DateTime.now().toIso8601String());

        if (actionId == actionSnooze) {
          // We'll schedule a reminder later (Phase 2C)
        }
      },
    );
  }

  Future<bool> requestPermissionIfNeeded() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;

    final granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> showAzifastNow() async {
    const androidDetails = AndroidNotificationDetails(
      azifastChannelId,
      'Azifast reminders',
      channelDescription: 'Reminders to take Azifast after lunch on Tue/Wed/Thu',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(actionTaken, 'Taken'),
        AndroidNotificationAction(actionSnooze, 'Snooze 15m'),
        AndroidNotificationAction(actionSkip, 'Skip'),
      ],
    );

    const details = NotificationDetails(android: androidDetails);

    await plugin.show(
      azifastId,
      '💊 Azifast 500mg',
      'After lunch dose. Choose: Taken / Snooze / Skip',
      details,
    );
  }
}
