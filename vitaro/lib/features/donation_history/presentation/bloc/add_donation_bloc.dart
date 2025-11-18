import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';
import 'add_donation_event.dart';
import 'add_donation_state.dart';

class AddDonationBloc extends Bloc<AddDonationEvent, AddDonationState> {
  final DonationRepository donationRepository;

  AddDonationBloc({required this.donationRepository})
      : super(AddDonationInitial()) {
    on<SaveNewDonation>((event, emit) async {
      emit(AddDonationLoading());

      try {
        await donationRepository.addDonation(event.donation);
        emit(AddDonationSuccess());
      } catch (e) {
        emit(AddDonationFailure(message: e.toString()));
      }
    });
  }
}
