import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kendaraan Saya'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleDialog(context, userId),
        backgroundColor: GarasifyyTheme.primaryRed,
        child: const Icon(Icons.add),
      ),
      body: userId == null
          ? const Center(child: Text('Silakan login terlebih dahulu'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService().getUserVehicles(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vehicles = snapshot.data ?? [];

                if (vehicles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada kendaraan',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan kendaraan Anda untuk\nmempermudah booking',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showAddVehicleDialog(context, userId),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Kendaraan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GarasifyyTheme.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return _VehicleCard(
                      vehicle: vehicle,
                      onEdit: () => _showEditVehicleDialog(context, vehicle),
                      onDelete: () => _showDeleteConfirmation(context, vehicle['id']),
                    ).animate(delay: Duration(milliseconds: index * 50))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.1, end: 0);
                  },
                );
              },
            ),
    );
  }

  void _showAddVehicleDialog(BuildContext context, String? userId) {
    if (userId == null) return;
    
    final plateController = TextEditingController();
    final modelController = TextEditingController();
    final yearController = TextEditingController();
    final colorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GarasifyyTheme.cardDark,
        title: const Text('Tambah Kendaraan', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(plateController, 'Plat Nomor', Icons.confirmation_number),
              const SizedBox(height: 12),
              _buildDialogTextField(modelController, 'Model/Merek', Icons.directions_car),
              const SizedBox(height: 12),
              _buildDialogTextField(yearController, 'Tahun', Icons.calendar_today,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildDialogTextField(colorController, 'Warna', Icons.color_lens),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (plateController.text.isNotEmpty && modelController.text.isNotEmpty) {
                await FirestoreService().addVehicle(
                  userId: userId,
                  plateNumber: plateController.text.toUpperCase(),
                  model: modelController.text,
                  year: yearController.text,
                  color: colorController.text,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: GarasifyyTheme.primaryRed),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditVehicleDialog(BuildContext context, Map<String, dynamic> vehicle) {
    final plateController = TextEditingController(text: vehicle['plateNumber']);
    final modelController = TextEditingController(text: vehicle['model']);
    final yearController = TextEditingController(text: vehicle['year']);
    final colorController = TextEditingController(text: vehicle['color']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GarasifyyTheme.cardDark,
        title: const Text('Edit Kendaraan', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(plateController, 'Plat Nomor', Icons.confirmation_number),
              const SizedBox(height: 12),
              _buildDialogTextField(modelController, 'Model/Merek', Icons.directions_car),
              const SizedBox(height: 12),
              _buildDialogTextField(yearController, 'Tahun', Icons.calendar_today,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildDialogTextField(colorController, 'Warna', Icons.color_lens),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (plateController.text.isNotEmpty && modelController.text.isNotEmpty) {
                await FirestoreService().updateVehicle(
                  vehicleId: vehicle['id'],
                  plateNumber: plateController.text.toUpperCase(),
                  model: modelController.text,
                  year: yearController.text,
                  color: colorController.text,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: GarasifyyTheme.primaryRed),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GarasifyyTheme.cardDark,
        title: const Text('Hapus Kendaraan', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin menghapus kendaraan ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirestoreService().deleteVehicle(vehicleId);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: GarasifyyTheme.darkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GarasifyyTheme.primaryRed),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _VehicleCard({
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: GarasifyyTheme.cardDark,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GarasifyyTheme.primaryRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: GarasifyyTheme.primaryRed,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle['plateNumber'] ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle['model'] ?? '-'} • ${vehicle['year'] ?? '-'}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    if (vehicle['color'] != null && vehicle['color'].isNotEmpty)
                      Text(
                        vehicle['color'],
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
