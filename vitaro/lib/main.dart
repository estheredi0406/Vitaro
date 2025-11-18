import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/firebase_options.dart';

// --- CORE / SHARED IMPORTS ---
// Ensure you have these files or the imports point to where Member 5 put them.
// If 'app_theme.dart' is missing, just comment that line out and remove 'theme:' in MaterialApp.

// --- AUTH FEATURES (Member 1's area, mocked for now) ---
import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';

// --- DONATION HISTORY FEATURES (Member 3's area) ---
import 'package:vitaro/features/donation_history/data/datasources/donation_remote_datasource.dart';
import 'package:vitaro/features/donation_history/data/repositories/donation_repository_impl.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/add_donation_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

// -----------------------------------------------------------------------------
// MOCK AUTH REPOSITORY
// This is a temporary placeholder. Member 1 will replace this with real Firebase Auth.
// We need this so your part (Member 3) works without waiting for them.
// -----------------------------------------------------------------------------
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String?> getCurrentUserId() async {
    // Simulating a logged-in user.
    // In real app, this returns the actual Firebase UID.
    return 'TEST_USER_ID_123';
  }

  // Add other methods if your abstract class requires them,
  // returning Future.value() or null.
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
    // MultiRepositoryProvider injects the "Engines" (Logic/Data classes)
    // so the UI can access them anywhere.
    return MultiRepositoryProvider(
      providers: [
        // 1. External Services
        RepositoryProvider<FirebaseFirestore>(
          create: (context) => FirebaseFirestore.instance,
        ),

        // 2. Auth Repository (Mock for now)
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),

        // 3. Data Source (Needs Firestore)
        RepositoryProvider<DonationRemoteDataSource>(
          create: (context) => DonationRemoteDataSourceImpl(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),

        // 4. Donation Repository (Needs Data Source AND Auth)
        RepositoryProvider<DonationRepository>(
          create: (context) => DonationRepositoryImpl(
            remoteDataSource: context.read<DonationRemoteDataSource>(),
            authRepository: context
                .read<AuthRepository>(), // <--- FIXED: Now correctly passed
          ),
        ),
      ],

      // MultiBlocProvider injects the "State Managers"
      child: MultiBlocProvider(
        providers: [
          // Bloc for Adding a Donation
          BlocProvider<AddDonationBloc>(
            create: (context) => AddDonationBloc(
              donationRepository: context.read<DonationRepository>(),
              // Removed 'authRepository' here because the Bloc doesn't need it directly,
              // the Repository handles it.
            ),
          ),

          // Bloc for Viewing History (Ensure this file exists!)
          BlocProvider<DonationHistoryBloc>(
            create: (context) => DonationHistoryBloc(
              donationRepository: context.read<DonationRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Vitaro',
          // theme: AppTheme.lightTheme, // Uncomment if you have the theme file
          debugShowCheckedModeBanner: false,

          // Set the starting screen to your work
          home: const DonationHistoryScreen(),
        ),
      ),
    );
  }
}
