part of 'eligibility_cubit.dart';

enum EligibilityStatus { initial, loading, success, failure }

class EligibilityState extends Equatable {
  const EligibilityState({
    required this.center,
    required this.status,
    required this.profile,
    required this.result,
    required this.errorMessage,
  });

  factory EligibilityState.initial(BloodCenter center) {
    return EligibilityState(
      center: center,
      status: EligibilityStatus.initial,
      profile: null,
      result: null,
      errorMessage: '',
    );
  }

  final BloodCenter center;
  final EligibilityStatus status;
  final DonorProfile? profile;
  final EligibilityResult? result;
  final String errorMessage;

  bool get isEligible => result?.isEligible ?? false;

  EligibilityState copyWith({
    EligibilityStatus? status,
    DonorProfile? profile,
    EligibilityResult? result,
    String? errorMessage,
  }) {
    return EligibilityState(
      center: center,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [center, status, profile, result, errorMessage];
}

