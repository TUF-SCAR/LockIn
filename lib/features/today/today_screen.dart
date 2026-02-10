import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/time/day_reset.dart';
import '../../core/notifications/notification_service.dart';

enum SessionState { notStarted, running, ended }

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  SessionState lunchState = SessionState.notStarted;
  SessionState gymState = SessionState.notStarted;

  String currentDayKey = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  int _toInt(SessionState s) => s.index;
  SessionState _fromInt(int v) => SessionState.values[v];

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final dayKey = lockInDayKeyString(DateTime.now());

    final savedDayKey = prefs.getString('day_key') ?? '';
    if (savedDayKey != dayKey) {
      // New day (based on 3AM reset) -> reset states
      await prefs.setString('day_key', dayKey);
      await prefs.setInt('lunch_state', SessionState.notStarted.index);
      await prefs.setInt('gym_state', SessionState.notStarted.index);
    }

    final lunch = prefs.getInt('lunch_state') ?? SessionState.notStarted.index;
    final gym = prefs.getInt('gym_state') ?? SessionState.notStarted.index;

    setState(() {
      currentDayKey = dayKey;
      lunchState = _fromInt(lunch);
      gymState = _fromInt(gym);
      loading = false;
    });
  }

  Future<void> _saveStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lunch_state', _toInt(lunchState));
    await prefs.setInt('gym_state', _toInt(gymState));
  }

  void startLunch() async {
    if (lunchState == SessionState.notStarted) {
      setState(() => lunchState = SessionState.running);
      await _saveStates();
    }
  }

  Future<void> endLunch() async {
    if (lunchState == SessionState.running) {
      setState(() => lunchState = SessionState.ended);
      await _saveStates();

      final now = DateTime.now();
      final isAziDay = now.weekday == DateTime.tuesday ||
          now.weekday == DateTime.wednesday ||
          now.weekday == DateTime.thursday;

      if (isAziDay) {
        await NotificationService.instance.requestPermissionIfNeeded();
        await NotificationService.instance.showAzifastNow();
      }
    }
  }

  void startGym() async {
    if (gymState == SessionState.notStarted) {
      setState(() => gymState = SessionState.running);
      await _saveStates();
    }
  }

  void endGym() async {
    if (gymState == SessionState.running) {
      setState(() => gymState = SessionState.ended);
      await _saveStates();
    }
  }

  String labelFor(SessionState state) {
    switch (state) {
      case SessionState.notStarted:
        return 'Not started';
      case SessionState.running:
        return 'In progress';
      case SessionState.ended:
        return 'Completed';
    }
  }

  String demonLineFor(SessionState state, String name) {
    switch (state) {
      case SessionState.notStarted:
        return '😈 $name: not started. Lock in.';
      case SessionState.running:
        return '👹 $name: in progress. Finish it.';
      case SessionState.ended:
        return '🔥 $name: completed. W.';
    }
  }

  bool isAzifastDay(DateTime now) {
    // Tue=2, Wed=3, Thu=4 in Dart
    return now.weekday == DateTime.tuesday ||
        now.weekday == DateTime.wednesday ||
        now.weekday == DateTime.thursday;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('LockIn')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Day key: $currentDayKey (reset @ 03:00 AM)'),
            const SizedBox(height: 16),

            Text('Lunch: ${labelFor(lunchState)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: lunchState == SessionState.notStarted ? startLunch : null,
              child: const Text('Start Lunch'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: lunchState == SessionState.running ? endLunch : null,
              child: const Text('End Lunch'),
            ),

            const SizedBox(height: 32),

            Text('Gym: ${labelFor(gymState)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: gymState == SessionState.notStarted ? startGym : null,
              child: const Text('Start Gym'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: gymState == SessionState.running ? endGym : null,
              child: const Text('End Gym'),
            ),

            const SizedBox(height: 32),

            OutlinedButton(
              onPressed: () {
                final now = DateTime.now();
                final azifastDue = isAzifastDay(now);

                final summary = [
                  'Day key: $currentDayKey (reset @ 03:00 AM)',
                  '',
                  demonLineFor(lunchState, 'Lunch'),
                  demonLineFor(gymState, 'Gym'),
                  '',
                  azifastDue
                      ? '💊 Azifast is scheduled today (Tue/Wed/Thu) after you press End Lunch.'
                      : '💊 No Azifast today.',
                  '',
                  '🧴 BPO/Azibrite blackout: (coming next phase)',
                ].join('\n');

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Today's Summary"),
                    content: Text(summary),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Show Today's Summary"),
            ),
          ],
        ),
      ),
    );
  }
}
