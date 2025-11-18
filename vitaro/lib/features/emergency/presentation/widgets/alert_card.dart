import 'package:flutter/material.dart';
import '../../data/models/emergency_alert_model.dart';
import 'urgency_badge.dart';
import '../screens/alert_details_screen.dart';

class AlertCard extends StatelessWidget {
  final EmergencyAlertModel alert;
  final VoidCallback onRespond;

  const AlertCard({super.key, required this.alert, required this.onRespond});

  @override
  Widget build(BuildContext context) {
    // DEBUG LOGGING
    print('🎴 ========== ALERT CARD ==========');
    print('🎴 Hospital: ${alert.hospitalName}');
    print('🎴 Blood Type: ${alert.bloodType}');
    print('🎴 Location: ${alert.location}');
    print('🎴 Urgency: ${alert.urgencyLevel}');
    print('🎴 Units: ${alert.unitsNeeded}');
    print('🎴 respondedDonors: ${alert.respondedDonors}');
    print('🎴 =================================');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      color: Colors.white, // Ensure white background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AlertDetailsScreen(alert: alert)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Important: Don't expand unnecessarily
            children: [
              // Header row with urgency badge and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UrgencyBadge(level: alert.urgencyLevel),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alert.timeRemaining,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hospital name - GUARANTEED VISIBILITY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  alert.hospitalName.isEmpty
                      ? '[No Hospital Name]'
                      : alert.hospitalName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Blood type - GUARANTEED VISIBILITY
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: Colors.red.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          alert.bloodType.isEmpty ? 'N/A' : alert.bloodType,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${alert.unitsNeeded} units needed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location - GUARANTEED VISIBILITY
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      alert.location.isEmpty ? '[No Location]' : alert.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Response count
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alert.respondedDonors.isEmpty
                      ? Colors.grey.shade100
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: alert.respondedDonors.isEmpty
                        ? Colors.grey.shade300
                        : Colors.green.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 18,
                      color: alert.respondedDonors.isEmpty
                          ? Colors.grey.shade600
                          : Colors.green.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        alert.respondedDonors.isEmpty
                            ? 'No donors yet - Be the first!'
                            : '${alert.respondedDonors.length} donor${alert.respondedDonors.length == 1 ? "" : "s"} responded',
                        style: TextStyle(
                          fontSize: 13,
                          color: alert.respondedDonors.isEmpty
                              ? Colors.grey.shade700
                              : Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRespond,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'I Can Donate',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
