import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/donation/presentation/booking_screen.dart';
import 'package:vitaro/features/donation/presentation/cubit/eligibility_cubit.dart';

// Shared Widgets
import 'package:vitaro/shared_widgets/screen_app_bar.dart';
import 'package:vitaro/shared_widgets/custom_button.dart';

class EligibilityCheckScreen extends StatelessWidget {
  const EligibilityCheckScreen({super.key, required this.center});

  final BloodCenter center;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EligibilityCubit(center: center)..evaluateEligibility(),
      child: const _EligibilityView(),
    );
  }
}

class _EligibilityView extends StatelessWidget {
  const _EligibilityView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(title: 'Donation Eligibility'),
      body: BlocBuilder<EligibilityCubit, EligibilityState>(
        builder: (context, state) {
          switch (state.status) {
            case EligibilityStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case EligibilityStatus.failure:
              return _ErrorBody(message: state.errorMessage);
            case EligibilityStatus.success:
              return _EligibilityResultBody(state: state);
            case EligibilityStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _EligibilityResultBody extends StatelessWidget {
  const _EligibilityResultBody({required this.state});

  final EligibilityState state;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile!;
    final result = state.result!;
    final formatter = DateFormat('MMMM d, y');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: result.isEligible
                  ? AppTheme.primaryRed.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.isEligible
                      ? 'You are eligible to donate!'
                      : 'Not eligible yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: result.isEligible
                        ? AppTheme.primaryRed
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Blood Type: ${profile.bloodType}',
                  style: const TextStyle(fontSize: 16),
                ),
                if (result.nextEligibleDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Next eligible date: ${formatter.format(result.nextEligibleDate!)}',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Health Metrics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _MetricRow(label: 'Hemoglobin', value: '${profile.hemoglobin} g/dL'),
          _MetricRow(
            label: 'Blood Pressure',
            value:
                '${profile.bloodPressureSystolic}/${profile.bloodPressureDiastolic} mmHg',
          ),
          _MetricRow(label: 'Pulse', value: '${profile.pulse} bpm'),
          if (!result.isEligible) ...[
            const SizedBox(height: 24),
            const Text(
              'What you need to address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...result.reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(reason)),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          CustomButton(
            text: 'Continue to Booking',
            onPressed: result.isEligible
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(
                          center: state.center,
                          profile: profile,
                        ),
                      ),
                    );
                  }
                : () {}, // Or null if you want it disabled
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.primaryRed,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              // Simple retry button if something goes wrong
              onPressed: () =>
                  context.read<EligibilityCubit>().evaluateEligibility(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
