import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';

// 1. Import the generated file
import 'package:vitaro/firebase_options.dart';

// 2. Import Firebase Core
import 'package:firebase_core/firebase_core.dart';

// 3. Import screens
import 'package:vitaro/features/auth/presentation/screens/splash_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/login_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/create_account_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/forgot_password_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
