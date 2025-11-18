import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for User type

// Import the generated firebase options
import 'package:vitaro/firebase_options.dart';

// Import Member 1's Auth Screens & Service
import 'package:vitaro/core/services/auth_service.dart';
import 'package:vitaro/features/auth/presentation/screens/splash_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/login_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/create_account_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/forgot_password_screen.dart';

// Import Member 5's Donation Features
import 'package:vitaro/features/donation_history/data/datasources/donation_remote_datasource.dart';
import 'package:vitaro/features/donation_history/data/repositories/donation_repository_impl.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/add_donation_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

// Temporary Auth Repository Adapter
// This bridges Member 1's simple Auth logic with your Clean Architecture requirements
import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<String?> getCurrentUserId() async {
    // Uses Member 1's actual Firebase Auth service logic
    return _authService.currentUser?.uid;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VitaroApp());
}

class VitaroApp extends StatelessWidget {
  const VitaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We keep your MultiRepositoryProvider to ensure Donation History works
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseFirestore>(
          create: (context) => FirebaseFirestore.instance,
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider<DonationRemoteDataSource>(
          create: (context) => DonationRemoteDataSourceImpl(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        RepositoryProvider<DonationRepository>(
          create: (context) => DonationRepositoryImpl(
            remoteDataSource: context.read<DonationRemoteDataSource>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AddDonationBloc>(
            create: (context) => AddDonationBloc(
              donationRepository: context.read<DonationRepository>(),
            ),
          ),
          BlocProvider<DonationHistoryBloc>(
            create: (context) => DonationHistoryBloc(
              donationRepository: context.read<DonationRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Vitaro',
          debugShowCheckedModeBanner: false,
          // THEME: Use the AppTheme you or Member 1 defined
          // theme: AppTheme.lightTheme,

          // ROUTING: Merging Member 1's Routes
          initialRoute: '/auth-check', // Start with the Auth Wrapper
          routes: {
            '/auth-check': (context) => const AuthWrapper(),
            '/login': (context) => const LoginScreen(),
            '/create-account': (context) => const CreateAccountScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            // When logged in, go to Donation History (or Dashboard when Member 2 merges)
            '/home': (context) => const DonationHistoryScreen(),
          },
        ),
      ),
    );
  }
}

/// Auth Wrapper (From Member 1's Logic)
/// Decides whether to show Login or Home
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const DonationHistoryScreen(); // Or HomeScreen()
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}