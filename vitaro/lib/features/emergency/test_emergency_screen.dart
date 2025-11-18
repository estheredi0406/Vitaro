import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'presentation/screens/emergency_alerts_screen.dart';
import 'data/services/fcm_service.dart';
import 'data/services/alert_notification_service.dart'; // ← ADD THIS

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM (skip on web)
  if (!kIsWeb) {
    final fcmService = FCMService();
    await fcmService.initialize();
  }

  // Initialize alert notification listener ← ADD THESE 2 LINES
  final alertNotificationService = AlertNotificationService();
  await alertNotificationService.initialize();

  runApp(const TestEmergencyApp());
}

class TestEmergencyApp extends StatelessWidget {
  const TestEmergencyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Emergency Alerts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const EmergencyAlertsScreen(),
    );
  }
}
