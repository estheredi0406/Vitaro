import 'package:equatable/equatable.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';

abstract class AddDonationEvent extends Equatable {
  const AddDonationEvent();

  @override
  List<Object> get props => [];
}

class SaveNewDonation extends AddDonationEvent {
  final Donation donation;

  const SaveNewDonation({required this.donation});

  @override
  List<Object> get props => [donation];
}
