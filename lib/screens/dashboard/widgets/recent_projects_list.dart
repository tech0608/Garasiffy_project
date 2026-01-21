import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';

class RecentProjectsList extends StatelessWidget {
  final List<Map<String, dynamic>> projects;

  const RecentProjectsList({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    // Show only up to 3 recent projects
    final displayProjects = projects.take(3).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Proyek Terbaru',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (projects.isNotEmpty)
              TextButton(
                onPressed: () {
                   // Navigate to history tab logic could go here
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(color: GarasifyyTheme.primaryRed),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (displayProjects.isEmpty)
           const Padding(
             padding: EdgeInsets.all(16.0),
             child: Text('Belum ada riwayat proyek', style: TextStyle(color: Colors.grey)),
           ),
        
        ...displayProjects.map((project) {
          final status = (project['status'] ?? 'WAITING').toString().toUpperCase();
          Color statusColor = Colors.grey;
          if (status == 'WAITING') statusColor = Colors.orange;
          if (status == 'ON_PROGRESS') statusColor = Colors.blue;
          if (status == 'COMPLETED') statusColor = Colors.green;

          double progress = (project['progress'] ?? 0.0) as double;
          String dateStr = 'Recently'; 
          final projectId = project['id'] as String?;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildProjectItem(
              context: context,
              projectId: projectId,
              title: project['serviceType'] ?? 'Unknown Service',
              date: dateStr, 
              status: status.replaceAll('_', ' '),
              progress: progress,
              statusColor: statusColor,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProjectItem({
    required BuildContext context,
    required String? projectId,
    required String title,
    required String date,
    required String status,
    required double progress,
    required Color statusColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: projectId != null 
          ? () => context.push('/booking/$projectId')
          : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GarasifyyTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(13)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(217), // 85% opacity
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.build_circle_outlined, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            color: GarasifyyTheme.textGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(217), // 85% opacity
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1.5),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withAlpha(26),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: GarasifyyTheme.textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
