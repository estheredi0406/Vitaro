import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/core/utils/widget_testbed_screen.dart'; // Add this import

// 1. Import the generated file
import 'package:vitaro/firebase_options.dart';

// 2. Import Firebase Core
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 3. Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Initialize Firebase using the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VitaroApp());
}

class VitaroApp extends StatelessWidget {
  const VitaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitaro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // home: const LoadingPage(), // <-- Comment this out
      home: const WidgetTestbedScreen(), // <-- Add this line
    );
  }
}

// Create a temporary placeholder for the loading page
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Vitaro Loading...'), // Replace this with Vitaro logo
      ),
    );
  }
}
