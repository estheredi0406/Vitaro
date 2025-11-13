import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyAlertModel {
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

  EmergencyAlertModel({
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

  // Convert Firestore document to EmergencyAlertModel
  factory EmergencyAlertModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // DEBUG: Print the ENTIRE raw document
    print('🔥 ========== RAW FIRESTORE DOCUMENT ==========');
    print('🔥 Document ID: ${doc.id}');
    print('🔥 ALL FIELDS:');
    data.forEach((key, value) {
      print('   "$key": $value (type: ${value.runtimeType})');
    });
    print('🔥 =============================================');

    // Filter out empty/null donor IDs
    List<String> cleanDonors = [];
    if (data['respondedDonors'] != null) {
      final rawDonors = data['respondedDonors'] as List<dynamic>;
      cleanDonors = rawDonors
          .where((id) => id != null && id.toString().trim().isNotEmpty)
          .map((id) => id.toString())
          .toList();
    }

    return EmergencyAlertModel(
      id: doc.id,
      hospitalName: data['hospitalName'] ?? '',
      bloodType: data['bloodType'] ?? '',
      urgencyLevel: data['urgencyLevel'] ?? 'Moderate',
      location: data['location'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      unitsNeeded: data['unitsNeeded'] ?? 1,
      contactNumber: data['contactNumber'] ?? '',
      status: data['status'] ?? 'Active',
      respondedDonors: cleanDonors,
      description: data['description'],
    );
  }

  // Convert EmergencyAlertModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'hospitalName': hospitalName,
      'bloodType': bloodType,
      'urgencyLevel': urgencyLevel,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'unitsNeeded': unitsNeeded,
      'contactNumber': contactNumber,
      'status': status,
      'respondedDonors': respondedDonors,
      'description': description,
    };
  }

  bool get isActive {
    return status == 'Active' && DateTime.now().isBefore(expiresAt);
  }

  String get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return 'Expired';

    final difference = expiresAt.difference(now);
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m left';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h left';
    }
    return '${difference.inDays}d left';
  }

  EmergencyAlertModel copyWith({
    String? id,
    String? hospitalName,
    String? bloodType,
    String? urgencyLevel,
    String? location,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? unitsNeeded,
    String? contactNumber,
    String? status,
    List<String>? respondedDonors,
    String? description,
  }) {
    return EmergencyAlertModel(
      id: id ?? this.id,
      hospitalName: hospitalName ?? this.hospitalName,
      bloodType: bloodType ?? this.bloodType,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      contactNumber: contactNumber ?? this.contactNumber,
      status: status ?? this.status,
      respondedDonors: respondedDonors ?? this.respondedDonors,
      description: description ?? this.description,
    );
  }
}
