import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackArrow;

  const ScreenAppBar({
    super.key,
    required this.title,
    this.showBackArrow = true, // Default to true, most screens need it
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Use your theme's scaffold color for a flat, modern look
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      // Conditionally show the back arrow
      leading: showBackArrow
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.textDark, // Use your theme color
              ),
              onPressed: () {
                // Standard back navigation
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            )
          : null, // Don't show anything (e.g., for Dashboard)
    );
  }

  // This is required to make a StatelessWidget usable as an AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
