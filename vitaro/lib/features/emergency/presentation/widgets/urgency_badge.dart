// lib/features/emergency/presentation/widgets/urgency_badge.dart

import 'package:flutter/material.dart';

class UrgencyBadge extends StatelessWidget {
  final String urgencyLevel;

  const UrgencyBadge({Key? key, required this.urgencyLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (urgencyLevel.toLowerCase()) {
      case 'critical':
        color = Colors.red[900]!;
        icon = Icons.emergency;
        break;
      case 'urgent':
        color = Colors.orange[700]!;
        icon = Icons.warning;
        break;
      case 'moderate':
        color = Colors.blue[700]!;
        icon = Icons.info;
        break;
      default:
        color = Colors.grey[700]!;
        icon = Icons.circle;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            urgencyLevel.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
