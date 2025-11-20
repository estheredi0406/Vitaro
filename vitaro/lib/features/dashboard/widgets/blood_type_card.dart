import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/dashboard/models/dashboard_user.dart';

class BloodTypeCard extends StatelessWidget {
  final DashboardUser user;

  const BloodTypeCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Logic: If bloodType is 'unknown', show 'Not Set', otherwise show the type (e.g. 'O+')
    final bool isUnknown = user.bloodType.toLowerCase() == 'unknown';
    final String displayType = isUnknown ? 'Not Set' : user.bloodType;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Blood Type',
                style: TextStyle(
                  // Fixed: Used withValues instead of deprecated withOpacity
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const Icon(Icons.water_drop, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displayType, // <--- Displays "Not Set" instead of "unknown"
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Eligible to Donate',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}