import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: GarasifyyTheme.darkBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    GarasifyyTheme.primaryRed.withAlpha(204),
                    GarasifyyTheme.primaryRed.withAlpha(102),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              child: Column(
                children: [
                  // Profile Photo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(77),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: user?.photoURL != null
                        ? ClipOval(
                            child: Image.network(
                              user!.photoURL!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 50, color: Colors.grey),
                            ),
                          )
                        : const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    user?.email ?? 'No email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),

            // Settings/Options List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      context.push('/edit-profile');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      context.push('/change-password');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.notifications,
                    title: 'Pengaturan Notifikasi',
                    subtitle: 'Kelola preferensi notifikasi',
                    onTap: () {
                      context.push('/notification-settings');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.directions_car,
                    title: 'Kendaraan Saya',
                    subtitle: 'Kelola daftar kendaraan Anda',
                    onTap: () {
                      context.push('/vehicles');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.chat,
                    title: 'Hubungi CS (WhatsApp)',
                    subtitle: 'Chat langsung dengan kami',
                    onTap: () async {
                       final Uri url = Uri.parse('https://wa.me/6285157033668');
                       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                         // ignore: use_build_context_synchronously
                         if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka WhatsApp')));
                         }
                       }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    subtitle: 'Dapatkan bantuan atau hubungi kami',
                    onTap: () {
                      context.push('/help');
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: GarasifyyTheme.cardDark,
                            title: const Text('Logout', style: TextStyle(color: Colors.white)),
                            content: const Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: GarasifyyTheme.primaryRed,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          await authProvider.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GarasifyyTheme.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  // Debug/Admin Tool
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.refresh, color: Colors.grey, size: 16),
                      label: const Text('Reset Data Layanan (Fix Missing Data)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mereset data layanan...')),
                        );
                        try {
                           await FirestoreService().resetServices();
                           // ignore: use_build_context_synchronously
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(backgroundColor: Colors.green, content: Text('Data layanan berhasil diperbarui! Silakan pull-to-refresh dashboard.')),
                           );
                        } catch (e) {
                           // ignore: use_build_context_synchronously
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(backgroundColor: Colors.red, content: Text('Gagal mereset data.')),
                           );
                        }
                      },
                    ),
                  ),

                  // App Version
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Garasifyy Mobile v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withAlpha(153),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: GarasifyyTheme.cardDark,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: GarasifyyTheme.primaryRed.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: GarasifyyTheme.primaryRed),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
