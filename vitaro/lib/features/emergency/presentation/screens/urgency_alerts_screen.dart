// lib/features/emergency/presentation/screens/urgent_alerts_screen.dart

import 'package:flutter/material.dart';
import '../../../../models/emergency_alert.dart';
import '../widgets/alert_card.dart';

class UrgentAlertsScreen extends StatefulWidget {
  @override
  _UrgentAlertsScreenState createState() => _UrgentAlertsScreenState();
}

class _UrgentAlertsScreenState extends State<UrgentAlertsScreen> {
  String selectedBloodType = 'All';
  List<String> bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  Widget build(BuildContext context) {
    // Filter alerts
    List<EmergencyAlert> filteredAlerts = selectedBloodType == 'All'
        ? dummyAlerts
        : dummyAlerts
              .where((alert) => alert.bloodType == selectedBloodType)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Urgent Blood Requests'),
        backgroundColor: Colors.red[700],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Blood Type Filter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.red[700],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Blood Type',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: bloodTypes.map((type) {
                      bool isSelected = type == selectedBloodType;
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedBloodType = type;
                            });
                          },
                          backgroundColor: Colors.red[600],
                          selectedColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.red[700] : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: filteredAlerts.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshAlerts,
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        return AlertCard(alert: filteredAlerts[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green[300]),
          SizedBox(height: 16),
          Text(
            'No urgent alerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'No blood requests match your filter',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAlerts() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Firebase fetch will go here
    });
  }
}
