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
    
    // Helper to safely read the date from multiple possible field names
    DateTime parseDate() {
      // Try 'donationDate' (from Booking flow), then 'date' (from old flow), then 'scheduledAt'
      final rawDate = json['donationDate'] ?? json['date'] ?? json['scheduledAt'];
      
      if (rawDate is Timestamp) {
        return rawDate.toDate();
      }
      return DateTime.now(); // Fallback to 'now' if missing (prevents crash)
    }

    return DonationModel(
      id: id,
      // Try 'centerName' (from Booking flow) first, then 'location'
      location: json['centerName'] ?? json['location'] ?? 'Unknown Center',
      amountMl: (json['amountMl'] ?? 450) as int, // Default to 450ml if missing
      date: parseDate(),
      bloodType: json['bloodType'] ?? 'Unknown',
      status: json['status'] ?? 'Processing',
    );
  }

  // Convert Model -> Firestore Data (JSON)
  Map<String, dynamic> toFirestore() {
    return {
      'location': location,
      'centerName': location, // Save both for compatibility
      'amountMl': amountMl,
      'date': Timestamp.fromDate(date),
      'donationDate': Timestamp.fromDate(date), // Save both for compatibility
      'bloodType': bloodType,
      'status': status,
    };
  }
}