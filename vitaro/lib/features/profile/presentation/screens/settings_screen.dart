import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State for toggles
  bool _notificationsEnabled = true;
  bool _emailUpdatesEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Preferences",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            // Notification Toggle
            SwitchListTile(
              activeThumbColor: const Color(0xFFE53935),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Notification Reminders",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                "Receive alerts when blood is needed nearby",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),

            // Email Toggle
            SwitchListTile(
              activeThumbColor: const Color(0xFFE53935),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Email Updates",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                "Receive newsletters and campaign updates",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              value: _emailUpdatesEnabled,
              onChanged: (bool value) {
                setState(() {
                  _emailUpdatesEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
