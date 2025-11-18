import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/firebase_options.dart';

import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';

import 'package:vitaro/features/donation_history/data/datasources/donation_remote_datasource.dart';
import 'package:vitaro/features/donation_history/data/repositories/donation_repository_impl.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/add_donation_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String?> getCurrentUserId() async {
    return 'TEST_USER_ID_123';
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
          home: const DonationHistoryScreen(),
        ),
      ),
    );
  }
}
