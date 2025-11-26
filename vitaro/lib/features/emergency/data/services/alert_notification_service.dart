import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../models/emergency_alert_model.dart';

class AlertNotificationService {
  static final AlertNotificationService _instance =
      AlertNotificationService._internal();
  factory AlertNotificationService() => _instance;
  AlertNotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Track the last alert timestamp to avoid duplicate notifications on app start
  DateTime? _lastAlertTime;
  bool _isInitialized = false;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('Initializing Alert Notification Service...');

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set initial timestamp to now (avoid notifying for old alerts)
    _lastAlertTime = DateTime.now();

    // Start listening for new alerts
    _listenForNewAlerts();

    _isInitialized = true;
    debugPrint('Alert Notification Service initialized');
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {},
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'emergency_alerts_channel',
      'Emergency Alerts',
      description: 'Urgent blood donation requests',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Listen for new emergency alerts in real-time
  void _listenForNewAlerts() {
    debugPrint('Listening for new emergency alerts...');

    _firestore
        .collection('emergency_alerts')
        .orderBy('createdAt', descending: true)
        .limit(1) // Only get the most recent alert
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isEmpty) return;

          final doc = snapshot.docs.first;

          try {
            final alert = EmergencyAlertModel.fromFirestore(doc);

            // Check if this is a new alert (created after we started listening)
            if (_lastAlertTime != null &&
                alert.createdAt.isAfter(_lastAlertTime!)) {
              debugPrint('NEW ALERT DETECTED!');
              debugPrint('  Hospital: ${alert.hospitalName}');
              debugPrint('  Blood Type: ${alert.bloodType}');

              // Send notification
              _sendNotification(alert);
            }

            // Update last alert time
            _lastAlertTime = alert.createdAt;
          } catch (e) {
            debugPrint('Error processing alert: $e');
          }
        });
  }

  // Send local notification for new alert
  Future<void> _sendNotification(EmergencyAlertModel alert) async {
    debugPrint('Sending notification for new alert...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'emergency_alerts_channel',
          'Emergency Alerts',
          channelDescription: 'Urgent blood donation requests',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(''),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final String title = ' Emergency Blood Needed!';
    final String body =
        '${alert.bloodType} blood urgently needed at ${alert.hospitalName}';

    await _localNotifications.show(
      alert.id.hashCode, // Use alert ID as notification ID
      title,
      body,
      details,
      payload: alert.id,
    );
  }

  // Stop listening (call when user logs out or app is disposed)
}
