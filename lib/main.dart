import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/notification_service.dart';
import 'firebase_options.dart';

import 'screens/home.dart';

Future<void> main() async {
  NotificationService notificationService = NotificationService();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await notificationService.initializePlatformNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Home(),
    );
  }
}
