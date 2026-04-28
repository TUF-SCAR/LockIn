import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String azifastChannelId = 'azifast_channel';
  static const int azifastId = 1001;

  static const String actionTaken = 'AZI_TAKEN';
  static const String actionSnooze = 'AZI_SNOOZE';
  static const String actionSkip = 'AZI_SKIP';

  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  bool _tzReady = false;

  Future<void> init() async {
    // Timezone init (needed for zonedSchedule)
    _initTimeZonesOnce();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) async {
        final actionId = resp.actionId;
        if (actionId == null || actionId.isEmpty) return;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('azifast_last_action', actionId);
        await prefs.setString(
          'azifast_last_action_time',
          DateTime.now().toIso8601String(),
        );

        if (actionId == actionSnooze) {
          await requestPermissionIfNeeded();
          await scheduleAzifastSnooze(minutes: 15);
        }
      },
    );
  }

  void _initTimeZonesOnce() {
    if (_tzReady) return;
    tz.initializeTimeZones();
    // Good default for India (Asia/Kolkata)
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    _tzReady = true;
  }

  Future<bool> requestPermissionIfNeeded() async {
    final android =
    plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;

    final granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  AndroidNotificationDetails _azifastAndroidDetails() {
    return const AndroidNotificationDetails(
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
  }

  Future<void> showAzifastNow() async {
    final details = NotificationDetails(android: _azifastAndroidDetails());
    await plugin.show(
      azifastId,
      '💊 Azifast 500mg',
      'After lunch dose. Choose: Taken / Snooze / Skip',
      details,
    );
  }

  Future<void> scheduleAzifastSnooze({required int minutes}) async {
    _initTimeZonesOnce();

    final when = tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));
    final details = NotificationDetails(android: _azifastAndroidDetails());

    // Use a different id so it doesn't overwrite the immediate one
    const snoozeId = 1002;

    await plugin.zonedSchedule(
      snoozeId,
      '💊 Azifast 500mg (Snoozed)',
      'Reminder after $minutes minutes. Choose: Taken / Snooze / Skip',
      when,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
