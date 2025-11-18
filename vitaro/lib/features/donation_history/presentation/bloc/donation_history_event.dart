import 'package:equatable/equatable.dart';

abstract class DonationHistoryEvent extends Equatable {
  const DonationHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchDonationHistory extends DonationHistoryEvent {}
