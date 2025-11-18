import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'donation_history_event.dart';
import 'donation_history_state.dart';

class DonationHistoryBloc
    extends Bloc<DonationHistoryEvent, DonationHistoryState> {
  final DonationRepository donationRepository;

  DonationHistoryBloc({required this.donationRepository})
      : super(DonationHistoryInitial()) {
    on<FetchDonationHistory>((event, emit) async {
      emit(DonationHistoryLoading());
      try {
        final donations = await donationRepository.getDonationHistory();
        emit(DonationHistoryLoaded(donations: donations));
      } catch (e) {
        emit(DonationHistoryError(message: e.toString()));
      }
    });
  }
}
