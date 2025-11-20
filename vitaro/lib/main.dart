import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

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

// *** YOUR FEATURES (Member 2) ***
import 'package:vitaro/features/dashboard/presentation/dashboard_screen.dart';
import 'package:vitaro/features/centers/presentation/find_centers_screen.dart';

// Temporary Auth Repository Adapter
import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<String?> getCurrentUserId() async {
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
          // THEME: Use your team's theme if available
          theme: ThemeData(
            primarySwatch: Colors.red,
            useMaterial3: true,
          ),

          // ROUTING
          initialRoute: '/auth-check',
          routes: {
            '/auth-check': (context) => const AuthWrapper(),
            '/login': (context) => const LoginScreen(),
            '/create-account': (context) => const CreateAccountScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            // Use MainContainer as the 'home' screen once logged in
            '/home': (context) => const MainContainer(), 
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
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in -> Show YOUR Dashboard/Main Container
          return const MainContainer(); 
        } else {
          // User is logged out -> Show Login
          return const LoginScreen();
        }
      },
    );
  }
}

// *** YOUR MAIN CONTAINER (Bottom Nav Logic) ***
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // The list of screens for the bottom navigation
  final List<Widget> _pages = [
    const DashboardScreen(),             // Index 0: Your Dashboard
    const FindCentersScreen(initialIndex: 1), // Index 1: Your Map (defaulting to Map tab)
    const DonationHistoryScreen(),       // Index 2: Member 5's History
    const Center(child: Text("Profile")), // Index 3: Placeholder for Profile
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
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}