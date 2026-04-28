import 'package:flutter/material.dart';
import 'core/notifications/notification_service.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const LockInApp());
}
