import 'package:vitaro/features/donation_history/domain/entities/donation.dart'; // Ensure this entity exists!

abstract class DonationRepository {
  // Fetch list of past donations
  Future<List<Donation>> getDonationHistory();

  // Add a new donation
  Future<void> addDonation(Donation donation);
}
