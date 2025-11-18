import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_bloc.dart';
import 'package:vitaro/features/donation_history/presentation/bloc/donation_history_state.dart';
import 'package:vitaro/features/donation_history/presentation/screens/donation_history_screen.dart';

// 1. Create a Mock Repository
class MockDonationRepository extends Fake implements DonationRepository {}

// 2. Create a Fake Bloc
class FakeDonationHistoryBloc
    extends Bloc<DonationHistoryEvent, DonationHistoryState>
    implements DonationHistoryBloc {
  FakeDonationHistoryBloc() : super(DonationHistoryInitial()) {
    on<DonationHistoryEvent>((event, emit) {});
  }

  @override
  final DonationRepository donationRepository = MockDonationRepository();

  // *** THE FIX ***
  // We create a public method to call the protected 'emit' function
  void addTestState(DonationHistoryState newState) {
    emit(newState);
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Displays donation history list when data is loaded',
      (WidgetTester tester) async {
    // Setup
    final mockBloc = FakeDonationHistoryBloc();
    final testDonations = [
      Donation(
          id: '1',
          location: 'Kigali Center',
          amountMl: 450,
          date: DateTime.now(),
          status: 'Completed'),
    ];

    // Inject the state using our new helper method
    mockBloc.addTestState(DonationHistoryLoaded(donations: testDonations));

    // Build the App
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DonationHistoryBloc>.value(
          value: mockBloc,
          child: const DonationHistoryScreen(),
        ),
      ),
    );

    // Wait for UI to settle
    await tester.pumpAndSettle();

    // Verify the text appears on screen
    expect(find.text('Kigali Center'), findsOneWidget);
    expect(find.text('Track'), findsOneWidget);
  });
}
