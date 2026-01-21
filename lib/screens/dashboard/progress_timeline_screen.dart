import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';

class ProgressTimelineScreen extends StatelessWidget {
  final String projectId;

  const ProgressTimelineScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pengerjaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: FirestoreService().streamProject(projectId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
             return const Center(child: Text('Terjadi kesalahan memuat data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final project = snapshot.data;
          if (project == null) {
            return const Center(child: Text('Data proyek tidak ditemukan'));
          }

          final String status = project['status'] ?? 'waiting';
          final String carModel = project['carModel'] ?? 'Unknown Car';
          final String plateNumber = project['plateNumber'] ?? '-';
          
          // Generate timeline steps based on status
          // Note: In a real admin system, this list could come from a 'timeline' field in Firestore
          final steps = _generateTimelineSteps(status, project);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Car Info Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GarasifyyTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(26)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: GarasifyyTheme.primaryRed.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.directions_car, color: GarasifyyTheme.primaryRed, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            carModel,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'Plat: $plateNumber',
                            style: const TextStyle(color: GarasifyyTheme.textGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Timeline
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    return _TimelineStep(
                      isFirst: index == 0,
                      isLast: index == steps.length - 1,
                      isPast: step['isPast'],
                      isActive: step['isActive'],
                      title: step['title'],
                      description: step['description'],
                      date: step['date'],
                      icon: step['icon'],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _generateTimelineSteps(String status, Map<String, dynamic> project) {
    // Basic timestamps
    final createdAt = _formatDate(project['createdAt']);
    final updatedAt = _formatDate(project['updatedAt']);
    
    // Status Logic
    bool isWaiting = status == 'waiting';
    bool inProgress = status == 'on_progress';
    bool isCompleted = status == 'completed';
    bool isCancelled = status == 'cancelled';

    return [
      {
        'title': 'Menunggu Antrian',
        'description': 'Kendaraan terdaftar dalam antrian',
        'date': createdAt,
        'icon': Icons.list_alt,
        'isPast': !isWaiting && !isCancelled, 
        'isActive': isWaiting,
      },
      {
        'title': 'Inspeksi Awal',
        'description': 'Pengecekan kondisi fisik dan mesin',
        'date': inProgress ? 'Sedang berlangsung' : (isCompleted ? 'Selesai' : '-'),
        'icon': Icons.search,
        'isPast': inProgress || isCompleted,
        'isActive': false,
      },
      {
        'title': 'Proses Pengerjaan',
        'description': 'Layanan sedang dikerjakan oleh teknisi',
        'date': inProgress ? 'Estimasi Selesai: Segera' : (isCompleted ? _formatDate(project['updatedAt']) : '-'),
        'icon': Icons.handyman,
        'isPast': isCompleted,
        'isActive': inProgress,
      },
      {
        'title': 'Quality Control & Serah Terima',
        'description': isCompleted ? 'Kendaraan siap diambil' : 'Final check dan test drive',
        'date': isCompleted ? updatedAt : '-',
        'icon': Icons.check_circle_outline,
        'isPast': isCompleted,
        'isActive': isCompleted,
      },
    ];
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '-';
    try {
      final date = timestamp.toDate();
      return DateFormat('dd MMM, HH:mm').format(date);
    } catch (e) {
      return '-';
    }
  }
}

class _TimelineStep extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final bool isActive;
  final String title;
  final String description;
  final String date;
  final IconData icon;

  const _TimelineStep({
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.isActive,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFinished = isPast || isActive;
    final color = isActive ? Colors.orange : (isPast ? GarasifyyTheme.primaryRed : Colors.grey);

    return SizedBox(
      height: 120,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? GarasifyyTheme.primaryRed : Colors.grey.withAlpha(77),
          thickness: 3,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          indicator: Container(
            decoration: BoxDecoration(
              color: isActive ? Colors.orange.withAlpha(26) : (isPast ? GarasifyyTheme.primaryRed : GarasifyyTheme.cardDark),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.orange : (isPast ? Colors.white : Colors.grey),
              size: 20,
            ),
          ),
        ),
        endChild: Container(
          margin: const EdgeInsets.only(left: 16, bottom: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GarasifyyTheme.cardDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.orange.withAlpha(77) : (isPast ? GarasifyyTheme.primaryRed.withAlpha(77) : Colors.transparent),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isFinished ? Colors.white : GarasifyyTheme.textGrey,
                      ),
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.orange : (isPast ? GarasifyyTheme.accentOrange : GarasifyyTheme.textGrey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: GarasifyyTheme.textGrey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
