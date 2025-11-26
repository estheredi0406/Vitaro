import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailUpdatesEnabled = false;
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load settings when screen starts
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true; // Default true
      _emailUpdatesEnabled = prefs.getBool('email_updates_enabled') ?? false; // Default false
      _isLoading = false;
    });
  }

  // Save setting to SharedPreferences
  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Notification Toggle
            SwitchListTile(
              activeThumbcolor: const Color(0xFFE53935),
              contentPadding: EdgeInsets.zero,
              title: const Text("Notification Reminders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: const Text("Receive alerts when blood is needed nearby", style: TextStyle(fontSize: 12, color: Colors.grey)),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSetting('notifications_enabled', value);
              },
            ),
            const Divider(),

            // Email Toggle
            SwitchListTile(
              activeThumbColor: const Color(0xFFE53935),
              contentPadding: EdgeInsets.zero,
              title: const Text("Email Updates", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: const Text("Receive newsletters and campaign updates", style: TextStyle(fontSize: 12, color: Colors.grey)),
              value: _emailUpdatesEnabled,
              onChanged: (bool value) {
                setState(() {
                  _emailUpdatesEnabled = value;
                });
                _saveSetting('email_updates_enabled', value);
              },
            ),
          ],
        ),
      ),
    );
  }
}