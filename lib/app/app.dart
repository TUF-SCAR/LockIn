import 'package:flutter/material.dart';
import '../features/today/today_screen.dart';

class LockInApp extends StatelessWidget {
  const LockInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LockIn',
      debugShowCheckedModeBanner: false,
      home: const TodayScreen(),
    );
  }
}
