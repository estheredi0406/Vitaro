import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vitaro/firebase_options.dart';

// --- MEMBER 1: Auth Features ---
import 'package:vitaro/core/services/auth_service.dart';
import 'package:vitaro/features/auth/presentation/screens/splash_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/login_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/create_account_screen.dart';
import 'package:vitaro/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';
import 'package:vitaro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vitaro/features/auth/presentation/bloc/auth_state.dart' show AuthState, AuthStatus;
import 'package:vitaro/features/auth/presentation/bloc/auth_event.dart';

// --- MEMBER 2: Dashboard & Centers Features ---
import 'package:vitaro/features/dashboard/presentation/dashboard_screen.dart';
import 'package:vitaro/features/centers/presentation/find_centers_screen.dart';

// --- MEMBER 3: Donation History ---
import 'package:vitaro/features/donation_history/data/datasources/donation_remote_datasource.dart';
import 'package:vitaro/features/donation_history/data/repositories/donation_repository_impl.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/add_donation_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

// --- MEMBER 4: Emergency Features ---
// Corrected Import: Pointing to Data Repository directly as no Domain layer exists
import 'package:vitaro/features/emergency/data/repositories/emergency_repository.dart';
import 'package:vitaro/features/emergency/presentation/screens/emergency_alerts_screen.dart';
import 'package:vitaro/features/emergency/data/services/fcm_service.dart';

// --- MEMBER 5: Profile Features ---
import 'package:vitaro/features/profile/data/repositories/profile_repository.dart';
import 'package:vitaro/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vitaro/features/profile/presentation/screens/profile_screen.dart';
import 'package:vitaro/features/profile/presentation/screens/edit_profile_screen.dart';

// Temporary Auth Repository Adapter
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<String?> getCurrentUserId() async {
    return _authService.currentUser?.uid;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM Service
  FCMService.setNavigatorKey(navigatorKey);
  await FCMService().initialize();

  runApp(const VitaroApp());
}

class VitaroApp extends StatelessWidget {
  const VitaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // --- Firebase Core ---
        RepositoryProvider<FirebaseFirestore>(
          create: (context) => FirebaseFirestore.instance,
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),

        // --- Profile Repository ---
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(),
        ),

        // --- Donation Repositories ---
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

        // --- Emergency Repository (Member 4) ---
        // Note: Member 4's class doesn't take arguments in constructor
        RepositoryProvider<EmergencyRepository>(
          create: (context) => EmergencyRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // --- Auth BLoC ---
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(AuthCheckRequested()),
          ),

          // --- Donation BLoCs ---
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

          // --- Emergency BLoC REMOVED ---
          // Member 4 used StreamBuilder in the UI, so no BLoC is needed here.

          // --- Profile BLoC ---
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Vitaro',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),

          // ROUTING
          initialRoute: '/auth-check',
          routes: {
            '/auth-check': (context) => const AuthWrapper(),
            '/login': (context) => const LoginScreen(),
            '/create-account': (context) => const CreateAccountScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),

            // Main App Entry Point (Bottom Navigation)
            '/home': (context) => const MainContainer(),

            // Feature Routes
            '/edit-profile': (context) => const EditProfileScreen(),
            '/emergency': (context) => const EmergencyAlertsScreen(),
            '/emergency-alerts': (context) => const EmergencyAlertsScreen(),
          },
        ),
      ),
    );
  }
}

/// Auth Wrapper (From Member 1's Logic)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const SplashScreen();
          case AuthStatus.authenticated:
            return const MainContainer();
          case AuthStatus.unauthenticated:
          case AuthStatus.error:
            return const LoginScreen();
        }
      },
    );
  }
}

// *** MAIN CONTAINER (Bottom Nav Logic) ***
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // The list of screens for the bottom navigation
  final List<Widget> _pages = [
    const DashboardScreen(), // Index 0: Dashboard
    const FindCentersScreen(initialIndex: 1), // Index 1: Map
    const DonationHistoryScreen(), // Index 2: History
    const ProfileScreen(), // Index 3: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD32F2F), // Vitaro Red
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
