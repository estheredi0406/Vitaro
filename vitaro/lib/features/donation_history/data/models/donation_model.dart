import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/donation.dart';

class DonationModel extends Donation {
  const DonationModel({
    required super.id,
    required super.location,
    required super.amountMl,
    required super.date,
    super.bloodType,
    super.status = 'Processing', // Default
  });

  // Convert generic Entity to Model
  factory DonationModel.fromEntity(Donation donation) {
    return DonationModel(
      id: donation.id,
      location: donation.location,
      amountMl: donation.amountMl,
      date: donation.date,
      bloodType: donation.bloodType,
      status: donation.status,
    );
  }

  // Convert Firestore Data (JSON) -> Model
  factory DonationModel.fromFirestore(Map<String, dynamic> json, String id) {
    return DonationModel(
      id: id,
      location: json['location'] ?? '',
      amountMl: json['amountMl'] ?? 0,
      date: (json['date'] as Timestamp).toDate(),
      bloodType: json['bloodType'] ?? 'Unknown',
      status: json['status'] ?? 'Processing',
    );
  }

  // Convert Model -> Firestore Data (JSON)
  Map<String, dynamic> toFirestore() {
    return {
      'location': location,
      'amountMl': amountMl,
      'date': Timestamp.fromDate(date),
      'bloodType': bloodType,
      'status': status,
    };
  }
}
