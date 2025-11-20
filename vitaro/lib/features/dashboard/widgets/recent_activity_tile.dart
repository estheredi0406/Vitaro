import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/dashboard/models/recent_activity.dart';

class RecentActivityTile extends StatelessWidget {
  final RecentActivity activity;

  const RecentActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isAlert = activity.type == ActivityType.alert;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAlert
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isAlert ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: isAlert ? Colors.red : Colors.green,
        ),
      ),
      title: Text(
        activity.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        activity.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        DateFormat('MMM d').format(activity.timestamp),
        style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
      ),
    );
  }
}