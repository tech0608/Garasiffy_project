import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';

class BookingDetailScreen extends StatelessWidget {
  final String projectId;

  const BookingDetailScreen({super.key, required this.projectId});

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'Menunggu Antrian';
      case 'on_progress':
        return 'Sedang Dikerjakan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return Colors.orange;
      case 'on_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'engine':
        return Icons.bolt;
      case 'body':
        return Icons.brush;
      case 'audio':
        return Icons.speaker;
      case 'maintenance':
        return Icons.settings;
      default:
        return Icons.build;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '-';
    try {
      final DateTime date = timestamp.toDate();
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: FirestoreService().streamProject(projectId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.withAlpha(128)),
                  const SizedBox(height: 16),
                  const Text('Terjadi kesalahan'),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final project = snapshot.data;
          if (project == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.withAlpha(128)),
                  const SizedBox(height: 16),
                  const Text('Booking tidak ditemukan'),
                ],
              ),
            );
          }

          final String status = project['status'] ?? 'waiting';
          final String serviceType = project['serviceType'] ?? 'maintenance';
          final double progress = (project['progress'] ?? 0.0).toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: GarasifyyTheme.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(status).withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withAlpha(26),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getServiceIcon(serviceType),
                              color: _getStatusColor(status),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project['carModel'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  project['plateNumber'] ?? '-',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withAlpha(26),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (status == 'on_progress') ...[
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress Pengerjaan',
                                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: GarasifyyTheme.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[800],
                                color: GarasifyyTheme.primaryRed,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),

                // Service Type
                Text(
                  'Layanan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: _getServiceIcon(serviceType),
                  title: _getServiceTitle(serviceType),
                  subtitle: project['notes'] ?? 'Tidak ada catatan',
                ).animate(delay: 100.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),

                // Booking Details
                Text(
                  'Detail Booking',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GarasifyyTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Tanggal Booking', _formatDate(project['bookingDate'])),
                      const Divider(color: Colors.grey, height: 24),
                      _buildDetailRow('Dibuat', _formatDate(project['createdAt'])),
                      const Divider(color: Colors.grey, height: 24),
                      _buildDetailRow('Terakhir Update', _formatDate(project['updatedAt'])),
                      if (project['totalCost'] != null && project['totalCost'] > 0) ...[
                        const Divider(color: Colors.grey, height: 24),
                        _buildDetailRow(
                          'Total Biaya',
                          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(project['totalCost']),
                          valueColor: GarasifyyTheme.primaryRed,
                        ),
                      ],
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),

                // Timeline Button
                if (status == 'on_progress' || status == 'completed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/timeline/$projectId'),
                      icon: const Icon(Icons.timeline),
                      label: const Text('Lihat Timeline Pengerjaan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GarasifyyTheme.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getServiceTitle(String type) {
    switch (type) {
      case 'engine':
        return 'Engine Upgrade';
      case 'body':
        return 'Body Paint';
      case 'audio':
        return 'Audio Install';
      case 'maintenance':
        return 'Maintenance';
      default:
        return type;
    }
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GarasifyyTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GarasifyyTheme.primaryRed.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: GarasifyyTheme.primaryRed, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
