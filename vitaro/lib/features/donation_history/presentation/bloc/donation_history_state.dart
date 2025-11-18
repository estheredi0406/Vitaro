import 'package:equatable/equatable.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';

abstract class DonationHistoryState extends Equatable {
  const DonationHistoryState();

  @override
  List<Object> get props => [];
}

class DonationHistoryInitial extends DonationHistoryState {}

class DonationHistoryLoading extends DonationHistoryState {}

class DonationHistoryLoaded extends DonationHistoryState {
  final List<Donation> donations;

  const DonationHistoryLoaded({required this.donations});

  @override
  List<Object> get props => [donations];
}

class DonationHistoryError extends DonationHistoryState {
  final String message;

  const DonationHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
