import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';
// Later import BLoC providers and router here

void main() async {
  // Add Firebase init here later
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const VitaroApp());
}

class VitaroApp extends StatelessWidget {
  const VitaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Later, we will wrap this with MultiBlocProvider
    return MaterialApp(
      title: 'Vitaro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(), // From your Figma
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
