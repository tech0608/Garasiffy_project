import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Mock Settings
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _promoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GarasifyyTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: GarasifyyTheme.darkBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive updates about your car progress',
            value: _pushEnabled,
            onChanged: (v) => setState(() => _pushEnabled = v),
          ),
          const Divider(color: Colors.white10),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive invoices and summaries via email',
            value: _emailEnabled,
            onChanged: (v) => setState(() => _emailEnabled = v),
          ),
          const Divider(color: Colors.white10),
          _buildSwitchTile(
            title: 'Promo & Offers',
            subtitle: 'Get notified about discounts and events',
            value: _promoEnabled,
            onChanged: (v) => setState(() => _promoEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: GarasifyyTheme.primaryRed,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
