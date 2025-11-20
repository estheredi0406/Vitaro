import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitaro/shared_widgets/screen_app_bar.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import '../../data/models/emergency_alert_model.dart';
import '../../data/repositories/emergency_repository.dart';
import '../widgets/alert_card.dart';
import 'donor_info_form_screen.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  State<EmergencyAlertsScreen> createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  final EmergencyRepository _repository = EmergencyRepository();
  String _selectedFilter = 'All';
  final List<String> _bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(
        title: 'Emergency Blood Alerts',
        showBackArrow: false,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: StreamBuilder<List<EmergencyAlertModel>>(
              stream: _selectedFilter == 'All'
                  ? _repository.getActiveAlerts()
                  : _repository.getAlertsByBloodType(_selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryRed,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: AppTheme.textLight,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading alerts',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final alerts = snapshot.data ?? [];

                if (alerts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No urgent requests',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'All blood banks are currently stable',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      return AlertCard(
                        alert: alerts[index],
                        onRespond: () => _handleResponse(alerts[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      color: AppTheme.secondaryRed.withValues(alpha: 0.2),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: _bloodTypes.map((bloodType) {
          final isSelected = _selectedFilter == bloodType;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(bloodType),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = bloodType;
                });
              },
              selectedColor: AppTheme.primaryRed,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _handleResponse(EmergencyAlertModel alert) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId =
        user?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final hasResponded = await _repository.hasUserResponded(alert.id, userId);
    if (hasResponded) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('You have already responded to this alert'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final donorInfo = await navigator.push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => DonorInfoFormScreen(
          alertId: alert.id,
          hospitalName: alert.hospitalName,
          bloodTypeNeeded: alert.bloodType,
        ),
      ),
    );

    if (donorInfo == null) return;

    if (mounted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Sending your response...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    final success = await _repository.respondToAlert(
      alert.id,
      userId,
      userName: donorInfo['userName'],
      userPhone: donorInfo['userPhone'],
      userBloodType: donorInfo['userBloodType'],
      userEmail: donorInfo['userEmail'],
      userAge: donorInfo['userAge'],
      lastDonationDate: donorInfo['lastDonationDate'],
      medicalNotes: donorInfo['medicalNotes'],
    );

    if (success && mounted) {
      messenger.showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Response sent successfully!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${alert.hospitalName} will contact you at ${donorInfo['userPhone']}',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } else if (mounted) {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Failed to send response. Please try again.'),
            ],
          ),
          backgroundColor: AppTheme.primaryRed,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _handleResponse(alert),
          ),
        ),
      );
    }
  }
}
