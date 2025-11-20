import 'package:vitaro/features/donation/domain/entities/donor_profile.dart';
import 'package:vitaro/features/donation/domain/entities/eligibility_result.dart';

class EligibilityChecker {
  const EligibilityChecker({
    this.minimumHemoglobin = 12.5,
    this.minimumDaysBetweenDonations = 56,
  });

  final double minimumHemoglobin;
  final int minimumDaysBetweenDonations;

  EligibilityResult evaluate(DonorProfile profile, {DateTime? referenceDate}) {
    final reasons = <String>[];
    final now = referenceDate ?? DateTime.now();

    if (profile.hemoglobin < minimumHemoglobin) {
      reasons.add(
        'Hemoglobin level is too low (minimum $minimumHemoglobin g/dL required).',
      );
    }

    if (profile.bloodPressureSystolic < 90 || profile.bloodPressureSystolic > 150) {
      reasons.add('Systolic blood pressure must be between 90 and 150 mmHg.');
    }

    if (profile.bloodPressureDiastolic < 60 || profile.bloodPressureDiastolic > 100) {
      reasons.add('Diastolic blood pressure must be between 60 and 100 mmHg.');
    }

    if (profile.pulse < 60 || profile.pulse > 110) {
      reasons.add('Pulse rate must be between 60 and 110 bpm.');
    }

    DateTime? nextEligibleDate;
    if (profile.lastDonationDate != null) {
      final lastDonationDate = profile.lastDonationDate!;
      final daysSinceLastDonation = now.difference(lastDonationDate).inDays;
      if (daysSinceLastDonation < minimumDaysBetweenDonations) {
        final calculatedDate =
            lastDonationDate.add(Duration(days: minimumDaysBetweenDonations));
        nextEligibleDate = calculatedDate;
        reasons.add(
          'Last donation was only $daysSinceLastDonation days ago. Wait until ${_formatDate(calculatedDate)}.',
        );
      }
    }

    if (profile.nextEligibilityDate != null &&
        profile.nextEligibilityDate!.isAfter(now)) {
      final upcomingDate = profile.nextEligibilityDate!;
      nextEligibleDate = upcomingDate;
      reasons.add(
        'Next eligible date is ${_formatDate(upcomingDate)}.',
      );
    }

    final isEligible = reasons.isEmpty;

    return EligibilityResult(
      isEligible: isEligible,
      reasons: reasons,
      nextEligibleDate: nextEligibleDate,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

