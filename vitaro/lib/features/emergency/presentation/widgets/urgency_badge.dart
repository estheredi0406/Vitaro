import 'package:flutter/material.dart';

class UrgencyBadge extends StatelessWidget {
  final String level; // 'Critical', 'Urgent', 'Moderate'

  const UrgencyBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (level.toLowerCase()) {
      case 'critical':
        backgroundColor = Colors.red.shade700;
        textColor = Colors.white;
        icon = Icons.warning_amber_rounded;
        break;
      case 'urgent':
        backgroundColor = Colors.orange.shade600;
        textColor = Colors.white;
        icon = Icons.priority_high;
        break;
      case 'moderate':
      default:
        backgroundColor = Colors.blue.shade600;
        textColor = Colors.white;
        icon = Icons.info_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            level.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
