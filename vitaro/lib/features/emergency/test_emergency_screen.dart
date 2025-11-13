import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'presentation/screens/emergency_alerts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
