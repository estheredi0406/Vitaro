part of 'find_centers_cubit.dart';

enum FindCentersStatus { initial, loading, loaded, error }

class FindCentersState extends Equatable {
  const FindCentersState({
    required this.status,
    required this.centers,
    required this.userPosition,
    required this.errorMessage,
  });

  const FindCentersState.initial()
      : status = FindCentersStatus.initial,
        centers = const <BloodCenter>[],
        userPosition = null,
        errorMessage = '';

  final FindCentersStatus status;
  final List<BloodCenter> centers;
  final Position? userPosition;
  final String errorMessage;

  bool get isLoading => status == FindCentersStatus.loading;
  bool get hasError => status == FindCentersStatus.error;

  FindCentersState copyWith({
    FindCentersStatus? status,
    List<BloodCenter>? centers,
    Position? userPosition,
    String? errorMessage,
  }) {
    return FindCentersState(
      status: status ?? this.status,
      centers: centers ?? this.centers,
      userPosition: userPosition ?? this.userPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, centers, userPosition, errorMessage];
}

