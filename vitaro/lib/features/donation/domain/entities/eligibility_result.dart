import 'package:equatable/equatable.dart';

class EligibilityResult extends Equatable {
  const EligibilityResult({
    required this.isEligible,
    required this.reasons,
    this.nextEligibleDate,
  });

  final bool isEligible;
  final List<String> reasons;
  final DateTime? nextEligibleDate;

  @override
  List<Object?> get props => [isEligible, reasons, nextEligibleDate];
}

