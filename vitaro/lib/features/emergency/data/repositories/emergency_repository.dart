import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_alert_model.dart';

class EmergencyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'emergency_alerts';

  // Get all active emergency alerts
  Stream<List<EmergencyAlertModel>> getActiveAlerts() {
    print('🔍 ========================================');
    print('🔍 Getting ALL documents');
    print('🔍 Collection: $_collectionName');
    print('🔍 ========================================');

    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) {
          print('\n🔍 ========== FIRESTORE RESPONSE ==========');
          print('🔍 Total documents received: ${snapshot.docs.length}');

          final List<EmergencyAlertModel> alerts = [];

          for (var doc in snapshot.docs) {
            print('\n📄 ===== Document ${doc.id} =====');

            try {
              final alert = EmergencyAlertModel.fromFirestore(doc);
              alerts.add(alert);
              print('✅ PARSED SUCCESSFULLY!');
              print('   Hospital: ${alert.hospitalName}');
              print('   Blood Type: ${alert.bloodType}');
            } catch (e) {
              print('❌ ERROR PARSING DOCUMENT: $e');
            }
          }

          print('\n🔍 Total alerts parsed: ${alerts.length}');
          print('🔍 ===============================\n');

          return alerts;
        })
        .handleError((error) {
          print('❌ STREAM ERROR: $error');
          return <EmergencyAlertModel>[];
        });
  }

  // Get alerts filtered by blood type
  Stream<List<EmergencyAlertModel>> getAlertsByBloodType(String bloodType) {
    print('🔍 Fetching alerts for blood type: $bloodType');

    return _firestore
        .collection(_collectionName)
        .where('bloodType', isEqualTo: bloodType)
        .snapshots()
        .map((snapshot) {
          print('🔍 Found ${snapshot.docs.length} alerts for $bloodType');

          return snapshot.docs
              .map((doc) => EmergencyAlertModel.fromFirestore(doc))
              .toList();
        })
        .handleError((error) {
          print('❌ Error fetching $bloodType alerts: $error');
          return <EmergencyAlertModel>[];
        });
  }

  // Check if user has already responded to an alert
  Future<bool> hasUserResponded(String alertId, String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(alertId)
          .get();

      if (doc.exists) {
        List<String> respondedDonors = List<String>.from(
          doc.get('respondedDonors') ?? [],
        );
        return respondedDonors.contains(userId);
      }
      return false;
    } catch (e) {
      print('❌ Error checking response: $e');
      return false;
    }
  }

  // Respond to an alert with complete donor information
  Future<bool> respondToAlert(
    String alertId,
    String userId, {
    required String userName,
    required String userPhone,
    required String userBloodType,
    String? userEmail,
    int? userAge,
    String? lastDonationDate,
    String? medicalNotes,
  }) async {
    try {
      print('💾 Saving response for: $userName');

      // 1. Add user to the alert's respondedDonors array
      await _firestore.collection(_collectionName).doc(alertId).update({
        'respondedDonors': FieldValue.arrayUnion([userId]),
      });

      // 2. Create a detailed response record
      await _firestore.collection('alert_responses').add({
        'alertId': alertId,
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'userEmail': userEmail ?? 'Not provided',
        'userBloodType': userBloodType,
        'userAge': userAge,
        'lastDonationDate': lastDonationDate,
        'medicalNotes': medicalNotes ?? 'None',
        'respondedAt': FieldValue.serverTimestamp(),
        'status': 'Pending', // Pending → Confirmed → Completed
        'hospitalNotes': '', // Hospital can add notes later
      });

      print('✅ Response saved successfully for: $userName ($userPhone)');
      return true;
    } catch (e) {
      print('❌ Error responding to alert: $e');
      return false;
    }
  }
}
