// Path: lib/features/donation/presentation/cubit/booking_cubit.dart

import 'package:bloc/bloc.dart'; // <-- FIX: Removed 'packagepackage:'
import 'package:equatable/equatable.dart'; // <-- FIX: Removed 'packagepackage:'
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/donation/data/donation_repository.dart';
import 'package:vitaro/features/donation/domain/entities/donation_request.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required BloodCenter center,
    DonationRepository? repository,
    FirebaseAuth? auth,
  }) : _repository = repository ?? DonationRepository(),
       _auth = auth ?? FirebaseAuth.instance,
       super(BookingState.initial(center));

  final DonationRepository _repository;
  final FirebaseAuth _auth;

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void updateSelectedTime(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  Future<void> submitBooking() async {
    if (state.selectedDate == null || state.selectedTime == null) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: 'Please select a preferred date and time.',
        ),
      );
      emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
      return;
    }

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: 'User not authenticated.',
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: SubmissionStatus.submitting));

    try {
      final scheduledAt = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        state.selectedTime!.hour,
        state.selectedTime!.minute,
      );

      final request = DonationRequest.newRequest(
        // *** This is the 'donorId' fix ***
        donorId: userId,
        centerId: state.center.id,
        centerName: state.center.name,
        scheduledAt: scheduledAt,
      );

      final requestId = await _repository.createDonationRequest(request);

      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.success,
          createdRequestId: requestId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
