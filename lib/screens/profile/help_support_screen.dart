import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GarasifyyTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: GarasifyyTheme.darkBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(color: GarasifyyTheme.primaryRed, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQItem('Bagaimana cara booking service?', 'Anda bisa melakukan booking melalui menu Booking di dashboard atau halaman detail layanan.'),
          _buildFAQItem('Apakah ada garansi?', 'Ya, setiap layanan kami memiliki garansi yang berbeda-beda tercantum di detail paket.'),
          _buildFAQItem('Bisa konsultasi dulu?', 'Tentu, tim kami siap membantu konsultasi sebelum pengerjaan dimulai.'),
          
          const SizedBox(height: 32),
          const Text(
            'Contact Us',
            style: TextStyle(color: GarasifyyTheme.primaryRed, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.white),
            title: const Text('Email Support', style: TextStyle(color: Colors.white)),
            subtitle: const Text('support@garasifyy.com', style: TextStyle(color: Colors.grey)),
            onTap: () => _launchUrl('mailto:support@garasifyy.com'),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.white),
            title: const Text('WhatsApp Admin', style: TextStyle(color: Colors.white)),
            subtitle: const Text('+62 812-3456-7890', style: TextStyle(color: Colors.grey)),
            onTap: () => _launchUrl('https://wa.me/6281234567890'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Theme(
      data: ThemeData.dark().copyWith(
        dividerColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(primary: GarasifyyTheme.primaryRed),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
