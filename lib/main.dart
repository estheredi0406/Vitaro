import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';

// 1. Import the generated file
import 'package:vitaro/firebase_options.dart';

// 2. Import Firebase Core and Auth
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 3. Import auth service
import 'package:vitaro/core/services/auth_service.dart';

// 4. Import screens
import 'package:vitaro/features/auth/presentation/screens/splash_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/login_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/create_account_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:vitaro/features/home/presentation/screens/home_screen.dart';

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
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/auth-check': (context) => const AuthWrapper(),
      },
    );
  }
}

/// Auth Wrapper to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // If user is logged in, show home screen
        // If user is not logged in, show login screen
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in - show home screen
          return const HomeScreen();
        } else {
          // User is not logged in - show login screen
          return const LoginScreen();
        }
      },
    );
  }
}
