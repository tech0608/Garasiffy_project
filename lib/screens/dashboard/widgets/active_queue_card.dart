import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';

class ActiveQueueCard extends StatelessWidget {
  final Map<String, dynamic>? projectData;

  const ActiveQueueCard({super.key, this.projectData});

  @override
  Widget build(BuildContext context) {
    // Default/Empty State
    if (projectData == null) {
      return Card(
        elevation: 4,
        color: GarasifyyTheme.cardDark,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.car_repair, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Belum ada antrian aktif', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.push('/booking'),
                style: ElevatedButton.styleFrom(backgroundColor: GarasifyyTheme.cardDark, side: const BorderSide(color: GarasifyyTheme.primaryRed)),
                child: const Text('Booking Layanan', style: TextStyle(color: GarasifyyTheme.primaryRed)),
              ),
            ],
          ),
        ),
      );
    }

    final status = projectData!['status'] ?? 'WAITING';
    final projectId = projectData!['id'] ?? 'Unknown';
    final plateNumber = projectData!['plateNumber'] ?? 'Unknown Car';
    final serviceType = projectData!['serviceType'] ?? 'Service';

    Color statusColor = Colors.orange;
    if (status == 'on_progress') statusColor = Colors.blue;
    if (status == 'completed') statusColor = Colors.green;

    return Card(
      elevation: 8,
      shadowColor: GarasifyyTheme.primaryRed.withAlpha(102),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              GarasifyyTheme.cardDark,
              GarasifyyTheme.primaryRed.withAlpha(26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: GarasifyyTheme.primaryRed.withAlpha(77)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plateNumber,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      '#${projectId.toString().substring(0, 5).toUpperCase()}',
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status.toString().toUpperCase().replaceAll('_', ' '),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Layanan:', style: TextStyle(color: Colors.grey)),
                Text(serviceType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/timeline/$projectId'),
                icon: const Icon(Icons.timeline),
                label: const Text('Cek Progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
