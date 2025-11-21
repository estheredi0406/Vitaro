// Path: lib/features/donation/domain/entities/donation_request.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DonationRequest extends Equatable {
  const DonationRequest({
    required this.id,
    // *** MODIFIED: Renamed to match team rules ***
    required this.donorId,
    required this.centerId,
    required this.centerName,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
  });

  factory DonationRequest.newRequest({
    // *** MODIFIED: Renamed to match team rules ***
    required String donorId,
    required String centerId,
    required String centerName,
    required DateTime scheduledAt,
  }) {
    return DonationRequest(
      id: '',
      // *** MODIFIED: Renamed to match team rules ***
      donorId: donorId,
      centerId: centerId,
      centerName: centerName,
      scheduledAt: scheduledAt,
      status: 'scheduled',
      createdAt: DateTime.now(),
    );
  }

  factory DonationRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return DonationRequest(
      id: doc.id,
      // *** MODIFIED: Renamed to match team rules ***
      donorId: data['donorId'] as String,
      centerId: data['centerId'] as String,
      centerName: data['centerName'] as String? ?? 'Unknown center',
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
      status: data['status'] as String? ?? 'scheduled',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  final String id;
  // *** MODIFIED: Renamed to match team rules ***
  final String donorId;
  final String centerId;
  final String centerName;
  final DateTime scheduledAt;
  final String status;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      // *** MODIFIED: Renamed to match team rules ***
      'donorId': donorId,
      'centerId': centerId,
      'centerName': centerName,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'donationDate': Timestamp.fromDate(
        scheduledAt,
      ), // This field is also in your code
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
    id,
    // *** MODIFIED: Renamed to match team rules ***
    donorId,
    centerId,
    centerName,
    scheduledAt,
    status,
    createdAt,
  ];
}
