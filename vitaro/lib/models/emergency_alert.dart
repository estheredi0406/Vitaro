// lib/models/emergency_alert.dart

class EmergencyAlert {
  final String id;
  final String bloodType;
  final String hospitalName;
  final String location;
  final String address;
  final int unitsNeeded;
  final DateTime timestamp;
  final String urgencyLevel; // 'critical', 'urgent', 'moderate'
  final String description;

  EmergencyAlert({
    required this.id,
    required this.bloodType,
    required this.hospitalName,
    required this.location,
    required this.address,
    required this.unitsNeeded,
    required this.timestamp,
    required this.urgencyLevel,
    required this.description,
  });
}

// Dummy data for UI testing (remove when connecting Firebase)
List<EmergencyAlert> dummyAlerts = [
  EmergencyAlert(
    id: '1',
    bloodType: 'A+',
    hospitalName: 'King Faisal Hospital',
    location: 'Kacyiru, Kigali',
    address: 'KN 4 Ave, Kigali',
    unitsNeeded: 3,
    timestamp: DateTime.now().subtract(Duration(hours: 2)),
    urgencyLevel: 'critical',
    description: 'Urgent need for accident victim in ICU',
  ),
  EmergencyAlert(
    id: '2',
    bloodType: 'O-',
    hospitalName: 'CHUK Hospital',
    location: 'Muhima, Kigali',
    address: 'KN 4 St, Kigali',
    unitsNeeded: 5,
    timestamp: DateTime.now().subtract(Duration(hours: 5)),
    urgencyLevel: 'urgent',
    description: 'Emergency surgery scheduled for tomorrow',
  ),
  EmergencyAlert(
    id: '3',
    bloodType: 'B+',
    hospitalName: 'Kibagabaga Hospital',
    location: 'Gasabo, Kigali',
    address: 'KG 7 Ave, Kigali',
    unitsNeeded: 2,
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    urgencyLevel: 'moderate',
    description: 'Routine blood bank restocking needed',
  ),
];
