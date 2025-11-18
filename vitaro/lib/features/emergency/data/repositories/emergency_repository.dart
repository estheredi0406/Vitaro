import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_alert_model.dart';

class EmergencyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'emergency_alerts';

  // Get all active emergency alerts
  Stream<List<EmergencyAlertModel>> getActiveAlerts() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                try {
                  return EmergencyAlertModel.fromFirestore(doc);
                } catch (e) {
                  print('Error parsing alert ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<EmergencyAlertModel>()
              .toList();
        })
        .handleError((error) {
          print('Error fetching alerts: $error');
          return <EmergencyAlertModel>[];
        });
  }

  // Get alerts filtered by blood type
  Stream<List<EmergencyAlertModel>> getAlertsByBloodType(String bloodType) {
    return _firestore
        .collection(_collectionName)
        .where('bloodType', isEqualTo: bloodType)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                try {
                  return EmergencyAlertModel.fromFirestore(doc);
                } catch (e) {
                  print('Error parsing alert ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<EmergencyAlertModel>()
              .toList();
        })
        .handleError((error) {
          print('Error fetching alerts by blood type: $error');
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
      print('Error checking user response: $e');
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
      // Add user to the alert's respondedDonors array
      await _firestore.collection(_collectionName).doc(alertId).update({
        'respondedDonors': FieldValue.arrayUnion([userId]),
      });

      // Create a detailed response record
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
        'status': 'Pending',
        'hospitalNotes': '',
      });

      return true;
    } catch (e) {
      print('Error responding to alert: $e');
      return false;
    }
  }
}
