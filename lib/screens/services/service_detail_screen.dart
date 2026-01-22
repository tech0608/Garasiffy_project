import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceType;
  final Map<String, dynamic>? serviceData;

  const ServiceDetailScreen({super.key, required this.serviceType, this.serviceData});

  @override
  Widget build(BuildContext context) {
    // Use passed data or fallback to empty state
    final data = serviceData;
    
    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Layanan Tidak Ditemukan')),
        body: const Center(child: Text('Data layanan tidak tersedia')),
      );
    }
    
    // Parse Icon
    final IconData icon = data['iconCode'] != null 
        ? IconData(data['iconCode'], fontFamily: 'MaterialIcons')
        : Icons.build;

    // Parse Color (if needed for styling)
    final Color color = data['colorValue'] != null 
        ? Color(data['colorValue']) 
        : GarasifyyTheme.primaryRed;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            backgroundColor: GarasifyyTheme.darkBackground, // Make pinned header solid
            surfaceTintColor: GarasifyyTheme.darkBackground, // Fix material 3 tint
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                data['title'], 
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                color: GarasifyyTheme.darkBackground,
                child: Center(
                  child: Icon(
                    icon, 
                    size: 80, 
                    color: color.withAlpha(128),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: GarasifyyTheme.darkBackground, // Solid background to prevent overlap
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Layanan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: GarasifyyTheme.primaryRed),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['description'],
                      style: const TextStyle(height: 1.5, color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'Paket Tersedia',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    
                    // Dynamic Packages
                    if (data['packages'] != null && (data['packages'] as List).isNotEmpty)
                      ...(data['packages'] as List).map((packageData) {
                        final package = packageData as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildPackageCard(
                            context,
                            package['name'] ?? ' Paket',
                            package['price'] ?? 'Call for Price',
                            List<String>.from(package['features'] ?? []),
                          ),
                        );
                      })
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Belum ada paket tersedia untuk layanan ini.',
                            style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 32),
                    Text(
                      'Proses Pengerjaan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    _buildTimeline(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GarasifyyTheme.cardDark,
          border: Border(top: BorderSide(color: Colors.white.withAlpha(26))),
        ),
        child: Row(
          children: [
             Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://wa.me/6285157033668');
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka WhatsApp')));
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: GarasifyyTheme.primaryRed),
                ),
                child: const Text('Tanya CS', style: TextStyle(color: GarasifyyTheme.primaryRed)),
              ),
            ),
            const SizedBox(width: 16),
              Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/booking'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: GarasifyyTheme.primaryRed,
                ),
                child: const Text('Booking Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, String title, String price, List<String> features) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GarasifyyTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(price, style: const TextStyle(color: GarasifyyTheme.accentOrange, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24, color: Colors.white10),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(feature, style: const TextStyle(color: GarasifyyTheme.textGrey)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineTile(title: 'Konsultasi & Analisis', isFirst: true, isLast: false),
        _buildTimelineTile(title: 'Desain & Perencanaan', isFirst: false, isLast: false),
        _buildTimelineTile(title: 'Pengerjaan', isFirst: false, isLast: false),
        _buildTimelineTile(title: 'Quality Check & Delivery', isFirst: false, isLast: true),
      ],
    );
  }

  Widget _buildTimelineTile({required String title, required bool isFirst, required bool isLast}) {
    return SizedBox(
      height: 80,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: const LineStyle(color: GarasifyyTheme.primaryRed),
        indicatorStyle: const IndicatorStyle(
          width: 20,
          color: GarasifyyTheme.primaryRed,
          padding: EdgeInsets.all(6),
        ),
        endChild: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16),
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
