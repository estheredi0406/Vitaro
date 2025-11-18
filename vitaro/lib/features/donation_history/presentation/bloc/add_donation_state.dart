import 'package:equatable/equatable.dart';

abstract class AddDonationState extends Equatable {
  const AddDonationState();

  @override
  List<Object> get props => [];
}

class AddDonationInitial extends AddDonationState {}

class AddDonationLoading extends AddDonationState {}

class AddDonationSuccess extends AddDonationState {}

class AddDonationFailure extends AddDonationState {
  final String message;

  const AddDonationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
