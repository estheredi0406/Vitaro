import 'package:vitaro/features/auth/domain/repositories/auth_repository.dart';
import 'package:vitaro/features/donation_history/data/datasources/donation_remote_datasource.dart';
import 'package:vitaro/features/donation_history/data/models/donation_model.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';
import 'package:vitaro/features/donation_history/domain/repositories/donation_repository.dart';

class DonationRepositoryImpl implements DonationRepository {
  final DonationRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  DonationRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
  });

  @override
  Future<void> addDonation(Donation donation) async {
    final userId = await authRepository.getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final donationModel = DonationModel.fromEntity(donation);

    await remoteDataSource.addDonation(donationModel, userId);
  }

  @override
  Future<List<Donation>> getDonationHistory() async {
    final userId = await authRepository.getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final donationModels = await remoteDataSource.getDonationHistory(userId);
    return donationModels;
  }
}
