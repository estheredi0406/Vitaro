import 'package:flutter/material.dart';
import 'package:vitaro/features/donation_history/domain/entities/donation.dart';

class DonationTrackingScreen extends StatelessWidget {
  final Donation donation;

  const DonationTrackingScreen({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    int currentStepIndex = 0;
    String status = donation.status.toLowerCase();

    if (status.contains("donation") || status == "completed") {
      currentStepIndex = 1;
    }
    if (status.contains("processing")) currentStepIndex = 2;
    if (status.contains("testing")) currentStepIndex = 3;
    if (status.contains("storage")) currentStepIndex = 4;
    if (status.contains("thank")) currentStepIndex = 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Donation Status',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location: ${donation.location}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              "Steps $currentStepIndex/5",
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Dynamic Progress Bar
            LinearProgressIndicator(
              value: currentStepIndex / 5,
              backgroundColor: Colors.red[50],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD32F2F),
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 40),

            _buildTimelineItem(
              title: "Donation",
              subtitle: "Completed successfully",
              isActive: currentStepIndex >= 1,
              icon: Icons.check,
              isFirst: true,
            ),
            _buildTimelineItem(
              title: "Processing",
              subtitle: currentStepIndex >= 2 ? "Completed" : "In Progress",
              isActive: currentStepIndex >= 2,
              icon: Icons.science_outlined,
            ),
            _buildTimelineItem(
              title: "Testing",
              subtitle: currentStepIndex >= 3 ? "Completed" : "Pending",
              isActive: currentStepIndex >= 3,
              icon: Icons.biotech,
            ),
            _buildTimelineItem(
              title: "Storage",
              subtitle: currentStepIndex >= 4 ? "Ready for use" : "Pending",
              isActive: currentStepIndex >= 4,
              icon: Icons.inventory_2_outlined,
            ),
            _buildTimelineItem(
              title: "Thank You!",
              subtitle: "You saved lives.",
              isActive: currentStepIndex >= 5,
              icon: Icons.favorite_border,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isActive,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    const Color vitaroRed = Color(0xFFD32F2F);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isActive ? vitaroRed : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isActive ? Icons.check : icon,
                  size: 20,
                  color: isActive ? vitaroRed : Colors.grey,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isActive
                        ? vitaroRed.withValues(alpha: 0.5)
                        : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? vitaroRed : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
