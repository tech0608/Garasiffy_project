import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _promoEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      final settings = await FirestoreService().getNotificationSettings(user.uid);
      if (mounted) {
        setState(() {
          _pushEnabled = settings['pushEnabled'] ?? true;
          _emailEnabled = settings['emailEnabled'] ?? true;
          _promoEnabled = settings['promoEnabled'] ?? false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    // Optimistic update
    setState(() {
      if (key == 'pushEnabled') _pushEnabled = value;
      if (key == 'emailEnabled') _emailEnabled = value;
      if (key == 'promoEnabled') _promoEnabled = value;
    });

    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        await FirestoreService().updateNotificationSettings(user.uid, {
          'pushEnabled': _pushEnabled,
          'emailEnabled': _emailEnabled,
          'promoEnabled': _promoEnabled,
        });
      } catch (e) {
        // Revert on failure (optional, but good practice)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Failed to save settings')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GarasifyyTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: GarasifyyTheme.darkBackground,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: GarasifyyTheme.primaryRed))
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive updates about your car progress',
                value: _pushEnabled,
                onChanged: (v) => _updateSetting('pushEnabled', v),
              ),
              const Divider(color: Colors.white10),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive invoices and summaries via email',
                value: _emailEnabled,
                onChanged: (v) => _updateSetting('emailEnabled', v),
              ),
              const Divider(color: Colors.white10),
              _buildSwitchTile(
                title: 'Promo & Offers',
                subtitle: 'Get notified about discounts and events',
                value: _promoEnabled,
                onChanged: (v) => _updateSetting('promoEnabled', v),
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
      activeColor: GarasifyyTheme.primaryRed,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
