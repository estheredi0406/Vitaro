import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_state.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_event.dart'; // <--- ADDED THIS IMPORT
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

class FakeDonationRepository extends Fake implements DonationRepository {}

class FakeDonationHistoryBloc
    extends Bloc<DonationHistoryEvent, DonationHistoryState>
    implements DonationHistoryBloc {
  FakeDonationHistoryBloc() : super(DonationHistoryInitial()) {
    on<DonationHistoryEvent>((event, emit) {});
  }

  @override
  final DonationRepository donationRepository = FakeDonationRepository();

  void addTestState(DonationHistoryState newState) {
    emit(newState);
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Renders Donation History List correctly', (
    WidgetTester tester,
  ) async {
    // --- ARRANGE ---
    final mockBloc = FakeDonationHistoryBloc();

    final testDonations = [
      Donation(
        id: '1',
        location: 'Kigali Center',
        amountMl: 450,
        date: DateTime.now(),
        status: 'Completed',
      ),
      Donation(
        id: '2',
        location: 'Butare Clinic',
        amountMl: 300,
        date: DateTime.now(),
        status: 'Processing',
      ),
    ];

    mockBloc.addTestState(DonationHistoryLoaded(donations: testDonations));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DonationHistoryBloc>.value(
          value: mockBloc,
          child: const DonationHistoryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Kigali Center'), findsOneWidget);
    expect(find.text('Butare Clinic'), findsOneWidget);
    expect(find.text('Track'), findsNWidgets(2));
  });

  testWidgets('Renders Empty State when no donations exist', (
    WidgetTester tester,
  ) async {
    final mockBloc = FakeDonationHistoryBloc();
    mockBloc.addTestState(const DonationHistoryLoaded(donations: []));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DonationHistoryBloc>.value(
          value: mockBloc,
          child: const DonationHistoryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No donations yet. Add one!'), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
