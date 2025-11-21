// Path: lib/features/donation/data/donation_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitaro/features/donation/domain/entities/donation_request.dart';
import 'package:vitaro/features/donation/domain/entities/donor_profile.dart';

class DonationRepository {
  DonationRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<DonorProfile> fetchCurrentDonorProfile() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User is not authenticated.');
    }

    // *** MODIFIED: Changed 'donors' to 'users' ***
    // This fixes your "permission-denied" error.
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('Donor profile not found.');
    }

    return DonorProfile.fromFirestore(doc);
  }

  Future<void> updateDonorProfile(DonorProfile profile) async {
    // *** MODIFIED: Changed 'donors' to 'users' ***
    await _firestore
        .collection('users')
        .doc(profile.id)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<String> createDonationRequest(DonationRequest request) async {
    final docRef = await _firestore
        .collection('donations')
        .add(request.toMap());

    // *** MODIFIED: Changed 'donors' to 'users' ***
    // *** MODIFIED: Changed 'request.userId' to 'request.donorId' ***
    // (You MUST also update your 'DonationRequest' class to have a 'donorId' field)
    await _firestore.collection('users').doc(request.donorId).set({
      'nextEligibilityDate': Timestamp.fromDate(
        request.scheduledAt.add(const Duration(days: 56)),
      ),
      'lastDonationDate': Timestamp.fromDate(request.scheduledAt),
    }, SetOptions(merge: true));

    return docRef.id;
  }

  Future<void> updateDonationStatus(String requestId, String status) async {
    await _firestore.collection('donations').doc(requestId).update({
      'status': status,
    });
  }

  Future<List<DonationRequest>> fetchUpcomingDonations() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return const [];
    }

    final snapshot = await _firestore
        .collection('donations')
        // *** MODIFIED: Changed 'userId' to 'donorId' ***
        .where('donorId', isEqualTo: userId)
        .orderBy('scheduledAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => DonationRequest.fromFirestore(doc))
        .toList(growable: false);
  }
}
