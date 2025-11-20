part of 'booking_cubit.dart';

enum SubmissionStatus { idle, submitting, success, failure }

class BookingState extends Equatable {
  const BookingState({
    required this.center,
    required this.selectedDate,
    required this.selectedTime,
    required this.submissionStatus,
    required this.errorMessage,
    required this.createdRequestId,
  });

  factory BookingState.initial(BloodCenter center) {
    return BookingState(
      center: center,
      selectedDate: null,
      selectedTime: null,
      submissionStatus: SubmissionStatus.idle,
      errorMessage: '',
      createdRequestId: null,
    );
  }

  final BloodCenter center;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final SubmissionStatus submissionStatus;
  final String errorMessage;
  final String? createdRequestId;

  BookingState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    SubmissionStatus? submissionStatus,
    String? errorMessage,
    String? createdRequestId,
  }) {
    return BookingState(
      center: center,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      createdRequestId: createdRequestId ?? this.createdRequestId,
    );
  }

  @override
  List<Object?> get props => [
        center,
        selectedDate,
        selectedTime,
        submissionStatus,
        errorMessage,
        createdRequestId,
      ];
}

