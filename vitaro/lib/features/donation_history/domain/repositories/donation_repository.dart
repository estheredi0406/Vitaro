import 'package:vitaro/features/donation_history/domain/entities/donation.dart'; // Ensure this entity exists!

abstract class DonationRepository {
  // Fetch list of past donations
  Future<List<Donation>> getDonationHistory();

  // Add a new donation (This is what was missing!)
  Future<void> addDonation(Donation donation);

  // You can add update/delete later
}
