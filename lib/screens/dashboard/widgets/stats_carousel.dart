import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StatsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> projects;

  const StatsCarousel({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    // Calculate Stats
    final activeCount = projects.where((p) => ['waiting', 'on_progress'].contains(p['status'])).length;
    final completedCount = projects.where((p) => p['status'] == 'completed').length;
    
    // Calculate total cost (mock logic if field missing) or parse if present
    // Assuming 'totalCost' is int or double
    double totalCost = 0;
    for (var p in projects) {
        totalCost += (p['totalCost'] ?? 0) as num;
    }
    final formattedCost = totalCost >= 1000000 
        ? 'Rp ${(totalCost / 1000000).toStringAsFixed(1)} Jt' 
        : 'Rp ${(totalCost / 1000).toStringAsFixed(0)} Rb';

    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildStatCard(
            context,
            icon: Icons.assignment_outlined,
            title: 'PROYEK AKTIF',
            value: activeCount.toString(),
            subtitle: 'Sedang Dikerjakan',
            gradientColors: [const Color(0xFFDC3545), const Color(0xFFFF4500)],
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            icon: Icons.payments_outlined,
            title: 'TOTAL INVOICE',
            value: formattedCost,
            subtitle: 'Investment Modifikasi',
            gradientColors: [const Color(0xFF0D1117), const Color(0xFF1A1A1A)],
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            icon: Icons.check_circle_outline,
            title: 'PROYEK SELESAI',
            value: completedCount.toString(),
            subtitle: 'Sudah Diserahkan',
            gradientColors: [const Color(0xFF28A745), const Color(0xFF20C997)],
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            icon: Icons.star_outline,
            title: 'RATING',
            value: '5.0', // Placeholder for now
            subtitle: 'Kepuasan Customer',
            gradientColors: [const Color(0xFFFFC107), const Color(0xFFFD7E14)],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(102),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              // Optional: Add trend indicator here
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
