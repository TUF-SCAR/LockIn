import 'package:shared_preferences/shared_preferences.dart';

DateTime lockInDayKey(DateTime now) {
  final reset = DateTime(now.year, now.month, now.day, 3);
  if (now.isBefore(reset)) {
    final yesterday = now.subtract(const Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day);
  }
  return DateTime(now.year, now.month, now.day);
}

String lockInDayKeyString(DateTime now) {
  final key = lockInDayKey(now);
  final mm = key.month.toString().padLeft(2, '0');
  final dd = key.day.toString().padLeft(2, '0');
  return '${key.year}-$mm-$dd';
}

class DayReset {
  /// DEBUG helper: wipes today's stored day marker + lunch/gym states.
  /// Next load behaves like a fresh day (based on 3AM day boundary).
  static Future<void> forceResetToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('day_key');
    await prefs.remove('lunch_state');
    await prefs.remove('gym_state');
  }
}
