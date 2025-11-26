import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DonorProfile extends Equatable {
  const DonorProfile({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.hemoglobin,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.pulse,
    this.lastDonationDate,
    this.nextEligibilityDate,
  });

  factory DonorProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return DonorProfile(
      id: doc.id,
      name: data['name'] as String? ?? 'Donor',
      bloodType: data['bloodType'] as String? ?? 'O+',
      hemoglobin: (data['hemoglobin'] as num?)?.toDouble() ?? 14.0,
      bloodPressureSystolic:
          (data['bloodPressureSystolic'] as num?)?.toInt() ?? 120,
      bloodPressureDiastolic:
          (data['bloodPressureDiastolic'] as num?)?.toInt() ?? 80,
      pulse: (data['pulse'] as num?)?.toInt() ?? 70,
      lastDonationDate: (data['lastDonationDate'] as Timestamp?)?.toDate(),
      nextEligibilityDate: (data['nextEligibilityDate'] as Timestamp?)
          ?.toDate(),
    );
  }

  final String id;
  final String name;
  final String bloodType;
  final double hemoglobin;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int pulse;
  final DateTime? lastDonationDate;
  final DateTime? nextEligibilityDate;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bloodType': bloodType,
      'hemoglobin': hemoglobin,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'pulse': pulse,
      'lastDonationDate': lastDonationDate != null
          ? Timestamp.fromDate(lastDonationDate!)
          : null,
      'nextEligibilityDate': nextEligibilityDate != null
          ? Timestamp.fromDate(nextEligibilityDate!)
          : null,
    }..removeWhere((key, value) => value == null);
  }

  DonorProfile copyWith({
    DateTime? lastDonationDate,
    DateTime? nextEligibilityDate,
  }) {
    return DonorProfile(
      id: id,
      name: name,
      bloodType: bloodType,
      hemoglobin: hemoglobin,
      bloodPressureSystolic: bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic,
      pulse: pulse,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
      nextEligibilityDate: nextEligibilityDate ?? this.nextEligibilityDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    bloodType,
    hemoglobin,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    pulse,
    lastDonationDate,
    nextEligibilityDate,
  ];
}
