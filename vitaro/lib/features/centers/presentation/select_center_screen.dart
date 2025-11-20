import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/donation/presentation/eligibility_check_screen.dart';

// *** SHARED WIDGET IMPORTS ***
import 'package:vitaro/shared_widgets/screen_app_bar.dart';
import 'package:vitaro/shared_widgets/custom_button.dart';

class SelectCenterScreen extends StatelessWidget {
  const SelectCenterScreen({super.key, required this.center});

  final BloodCenter center;

  Future<void> _launchMaps() async {
    final lat = center.location.latitude;
    final lng = center.location.longitude;

    // *** THE REAL FIX ***
    final googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for some browsers/devices
        await launchUrl(googleMapsUrl);
      }
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. USE SHARED APP BAR
      appBar: ScreenAppBar(title: center.name),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _launchMaps,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(center.address,
                                style: const TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline))),
                        const Icon(Icons.directions, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          size: 18, color: AppTheme.primaryRed),
                      const SizedBox(width: 8),
                      Text(center.phone),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.schedule,
                          size: 18, color: AppTheme.primaryRed),
                      const SizedBox(width: 8),
                      Expanded(child: Text(center.openingHours)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: center.services
                        .map(
                          (service) => Chip(
                            label: Text(service),
                            backgroundColor:
                                AppTheme.primaryRed.withValues(alpha: 0.1),
                            labelStyle:
                                const TextStyle(color: AppTheme.primaryRed),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 2. USE SHARED BUTTON
            CustomButton(
              text: 'Book Donation',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EligibilityCheckScreen(center: center),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}