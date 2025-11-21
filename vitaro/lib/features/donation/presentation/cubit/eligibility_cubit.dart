import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/donation/data/donation_repository.dart';
import 'package:vitaro/features/donation/domain/eligibility/eligibility_checker.dart';
import 'package:vitaro/features/donation/domain/entities/donor_profile.dart';
import 'package:vitaro/features/donation/domain/entities/eligibility_result.dart';

part 'eligibility_state.dart';

class EligibilityCubit extends Cubit<EligibilityState> {
  EligibilityCubit({
    required BloodCenter center,
    DonationRepository? repository,
    EligibilityChecker? checker,
  }) : _repository = repository ?? DonationRepository(),
       _checker = checker ?? const EligibilityChecker(),
       super(EligibilityState.initial(center));

  final DonationRepository _repository;
  final EligibilityChecker _checker;

  Future<void> evaluateEligibility() async {
    emit(state.copyWith(status: EligibilityStatus.loading));
    try {
      final profile = await _repository.fetchCurrentDonorProfile();
      final result = _checker.evaluate(profile);
      emit(
        state.copyWith(
          status: EligibilityStatus.success,
          profile: profile,
          result: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EligibilityStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
