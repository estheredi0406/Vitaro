import 'package:equatable/equatable.dart';

class Donation extends Equatable {
  final String id;
  final String location;
  final int amountMl;
  final DateTime date;
  final String bloodType;
  final String status; // <--- ADDED THIS

  const Donation({
    this.id = '',
    required this.location,
    required this.amountMl,
    required this.date,
    this.bloodType = 'Unknown',
    this.status = 'Completed', // Default value
  });

  @override
  List<Object?> get props => [id, location, amountMl, date, bloodType, status];
}
