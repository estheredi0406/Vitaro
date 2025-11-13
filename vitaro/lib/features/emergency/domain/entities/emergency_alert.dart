// This is the domain entity - pure business logic, no dependencies on Firebase
class EmergencyAlert {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String urgencyLevel;
  final String location;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int unitsNeeded;
  final String contactNumber;
  final String status;
  final List<String> respondedDonors;
  final String? description;

  EmergencyAlert({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.urgencyLevel,
    required this.location,
    required this.createdAt,
    required this.expiresAt,
    required this.unitsNeeded,
    required this.contactNumber,
    required this.status,
    required this.respondedDonors,
    this.description,
  });

  bool get isActive {
    return status == 'Active' && DateTime.now().isBefore(expiresAt);
  }

  bool get isCritical => urgencyLevel == 'Critical';
  bool get isUrgent => urgencyLevel == 'Urgent';

  int get responseCount => respondedDonors.length;
}
