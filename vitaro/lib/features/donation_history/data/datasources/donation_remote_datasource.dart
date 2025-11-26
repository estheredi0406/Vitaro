import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';

abstract class DonationRemoteDataSource {
  Future<void> addDonation(DonationModel donation, String userId);
  Future<List<DonationModel>> getDonationHistory(String userId);
}

class DonationRemoteDataSourceImpl implements DonationRemoteDataSource {
  final FirebaseFirestore firestore;

  DonationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addDonation(DonationModel donation, String userId) async {
    // FIXED: Write to the main 'donations' collection
    // We also ensure the 'donorId' is included in the data
    final data = donation.toFirestore();
    data['donorId'] = userId; 
    final donationCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('donations');

    await firestore.collection('donations').add(data);
  }

  @override
  Future<List<DonationModel>> getDonationHistory(String userId) async {
    try {
      // FIXED: Read from the main 'donations' collection
      // Filter where 'donorId' matches the current user
      final querySnapshot = await firestore
          .collection('donations')
          .where('donorId', isEqualTo: userId)
          // Note: If this crashes due to an index error, check your console for a link to create the index
          // We use 'donationDate' because that is what we saved in your Booking feature
          .orderBy('donationDate', descending: true) 
          .get();

      return querySnapshot.docs.map((doc) {
        return DonationModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      // Fallback: If 'donationDate' doesn't exist or index is missing, try without sorting
      print("Sort failed, trying unsorted query: $e");
      final querySnapshot = await firestore
          .collection('donations')
          .where('donorId', isEqualTo: userId)
          .get();
          
      return querySnapshot.docs.map((doc) {
        return DonationModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    }
  }
}