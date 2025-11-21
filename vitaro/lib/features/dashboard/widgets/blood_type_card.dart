import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/dashboard/models/dashboard_user.dart';

class BloodTypeCard extends StatelessWidget {
  final DashboardUser? user; // Made optional
  final String? bloodTypeOverride; // New override field

  const BloodTypeCard({
    super.key,
    this.user,
    this.bloodTypeOverride,
  });

  @override
  Widget build(BuildContext context) {
    // Logic: Use override if present, otherwise use user data, otherwise fallback
    final displayBloodType = bloodTypeOverride ?? (user?.bloodType ?? "Not Set");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFFF5252)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha:0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Blood Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                displayBloodType, // Use the logic variable
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bloodtype,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}