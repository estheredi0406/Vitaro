import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Model to represent the donor's specific data shown on the dashboard
class DashboardUser extends Equatable {
  final String id;
  final String name;
  final String bloodType;
  final bool isEligible;
  final DateTime? nextEligibilityDate;
  final double hemoglobin;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int pulse;
  final String profileImageUrl;

  const DashboardUser({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.isEligible,
    this.nextEligibilityDate,
    required this.hemoglobin,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.pulse,
    required this.profileImageUrl,
  });

  // Factory to create a DashboardUser from a Firestore document
  factory DashboardUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DashboardUser(
      id: doc.id,
      name: data['name'] ?? 'John Doe',
      bloodType: data['bloodType'] ?? 'O+',
      isEligible: data['isEligible'] ?? false,
      nextEligibilityDate: (data['nextEligibilityDate'] as Timestamp?)
          ?.toDate(),
      hemoglobin: (data['hemoglobin'] as num?)?.toDouble() ?? 14.0,
      bloodPressureSystolic:
          (data['bloodPressureSystolic'] as num?)?.toInt() ?? 120,
      bloodPressureDiastolic:
          (data['bloodPressureDiastolic'] as num?)?.toInt() ?? 80,
      pulse: (data['pulse'] as num?)?.toInt() ?? 72,
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  // Helper for displaying blood pressure
  String get bloodPressureDisplay =>
      '$bloodPressureSystolic/$bloodPressureDiastolic';

  @override
  List<Object?> get props => [
    id,
    name,
    bloodType,
    isEligible,
    nextEligibilityDate,
    hemoglobin,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    pulse,
    profileImageUrl,
  ];
}
