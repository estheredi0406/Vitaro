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
    final donationCollection =
        firestore.collection('users').doc(userId).collection('donations');

    await donationCollection.add(donation.toFirestore());
  }

  @override
  Future<List<DonationModel>> getDonationHistory(String userId) async {
    final donationCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('donations')
        .orderBy('date', descending: true);

    final querySnapshot = await donationCollection.get();

    return querySnapshot.docs.map((doc) {
      return DonationModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}
