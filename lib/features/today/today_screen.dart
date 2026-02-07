import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LockIn')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Start Lunch')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: const Text('End Lunch')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('Start Gym')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: const Text('End Gym')),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: () {}, child: const Text("Show Today's Summary")),
          ],
        ),
      ),
    );
  }
}
