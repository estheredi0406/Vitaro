import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/donation/domain/entities/donor_profile.dart';
import 'package:vitaro/features/donation/presentation/booking_success_screen.dart';
import 'package:vitaro/features/donation/presentation/cubit/booking_cubit.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, required this.center, required this.profile});

  final BloodCenter center;
  final DonorProfile profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(center: center),
      child: _BookingView(center: center, profile: profile),
    );
  }
}

class _BookingView extends StatelessWidget {
  const _BookingView({required this.center, required this.profile});

  final BloodCenter center;
  final DonorProfile profile;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final timeFormat = DateFormat.jm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Donation'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.submissionStatus == SubmissionStatus.failure &&
              state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }

          if (state.submissionStatus == SubmissionStatus.success &&
              state.createdRequestId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BookingSuccessScreen(
                  center: center,
                  profile: profile,
                  requestId: state.createdRequestId!,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CenterSummaryCard(center: center),
                const SizedBox(height: 24),
                const Text(
                  'Select preferred date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final today = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: today.add(const Duration(days: 1)),
                      firstDate: today,
                      lastDate: today.add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      if (!context.mounted) return;
                      context.read<BookingCubit>().updateSelectedDate(picked);
                    }
                  },
                  child: _PickerTile(
                    icon: Icons.calendar_today,
                    label: state.selectedDate != null
                        ? dateFormat.format(state.selectedDate!)
                        : 'Choose a date',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select preferred time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      if (!context.mounted) return;
                      context.read<BookingCubit>().updateSelectedTime(picked);
                    }
                  },
                  child: _PickerTile(
                    icon: Icons.access_time,
                    label: state.selectedTime != null
                        ? timeFormat.format(
                            DateTime(
                              0,
                              1,
                              1,
                              state.selectedTime!.hour,
                              state.selectedTime!.minute,
                            ),
                          )
                        : 'Choose a time',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state.submissionStatus == SubmissionStatus.submitting
                        ? null
                        : () {
                            context.read<BookingCubit>().submitBooking();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.submissionStatus == SubmissionStatus.submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Confirm Booking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CenterSummaryCard extends StatelessWidget {
  const _CenterSummaryCard({required this.center});

  final BloodCenter center;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            center.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            center.address,
            style: const TextStyle(color: AppTheme.textLight),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 18, color: AppTheme.primaryRed),
              const SizedBox(width: 8),
              Text(center.phone),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryRed),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
