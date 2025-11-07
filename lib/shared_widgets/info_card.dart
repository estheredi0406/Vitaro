import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Use Expanded so it can be placed in a Row and take up equal space
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              // Subtle shadow
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 13, // Slightly smaller
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 20, // Bold and prominent
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
