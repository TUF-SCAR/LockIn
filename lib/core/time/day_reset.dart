DateTime lockInDayKey(DateTime now) {
  final reset = DateTime(now.year, now.month, now.day, 3);
  if (now.isBefore(reset)) {
    final yesterday = now.subtract(const Duration(days:  1));
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
