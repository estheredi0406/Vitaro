// Path: lib/features/dashboard/models/recent_activity.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ActivityType { donation, alert }

// Model for a single item in the "Recent Activity" list
class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final ActivityType type;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });

  // Factory to create from a "donations" document
  factory RecentActivity.fromDonation(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestampRaw = data['donationDate'] ?? data['scheduledAt'];
    final timestamp = timestampRaw is Timestamp
        ? timestampRaw.toDate()
        : DateTime.now();
    final status = (data['status'] as String?)?.toLowerCase() ?? 'scheduled';
    final title = status == 'completed' ? 'Donation Complete' : 'Donation Scheduled';
    final subtitleSuffix = status == 'completed'
        ? 'Completed on'
        : 'Scheduled for';
    return RecentActivity(
      id: doc.id,
      title: title,
      subtitle:
          '${data['centerName'] ?? 'King Faisal Hospital'} • $subtitleSuffix ${_formatDisplayDate(timestamp)}',
      timestamp: timestamp,
      type: ActivityType.donation,
    );
  }

  // Factory to create from an "alerts" document
  factory RecentActivity.fromAlert(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecentActivity(
      id: doc.id,
      title: 'Emergency Alert',
      subtitle: 'A ${data['bloodType']} blood need at ${data['hospitalName']}',
      timestamp: (data['createdAt'] as Timestamp).toDate(),
      type: ActivityType.alert,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, timestamp, type];
}

String _formatDisplayDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}