import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Form State
  String? _selectedServiceType;
  Map<String, dynamic>? _selectedPackage;
  DateTime? _selectedDate;
  bool _isLoading = false;
  Map<String, dynamic>? _selectedVehicle;
  bool _useNewVehicle = false;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Seed services if likely empty (development helper)
    _firestoreService.seedServices();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectVehicle(Map<String, dynamic>? vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      if (vehicle != null) {
        _useNewVehicle = false;
        _plateController.text = vehicle['plateNumber'] ?? '';
        _modelController.text = vehicle['model'] ?? '';
      }
    });
  }

  void _toggleNewVehicle() {
    setState(() {
      _useNewVehicle = !_useNewVehicle;
      if (_useNewVehicle) {
        _selectedVehicle = null;
        _plateController.clear();
        _modelController.clear();
      }
    });
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedServiceType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih layanan terlebih dahulu'), backgroundColor: Colors.orange),
        );
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih tanggal booking'), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final user = Provider.of<AuthProvider>(context, listen: false).user;
        if (user == null) throw Exception('User not logged in');

        await _firestoreService.createBooking(
          userId: user.uid,
          serviceType: _selectedServiceType!,
          plateNumber: _plateController.text.toUpperCase(),
          carModel: _modelController.text,
          notes: _notesController.text,

          bookingDate: _selectedDate!,
          selectedPackage: _selectedPackage,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/'); // Back to dashboard
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: GarasifyyTheme.primaryRed,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: GarasifyyTheme.primaryRed,
              onPrimary: Colors.white,
              surface: GarasifyyTheme.cardDark,
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: GarasifyyTheme.darkBackground),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;

    return Scaffold(
      backgroundColor: GarasifyyTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Booking Service'),
        backgroundColor: GarasifyyTheme.darkBackground,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getServices(),
        builder: (context, servicesSnapshot) {
          List<Map<String, dynamic>> services = servicesSnapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Selection
                  Text('Pilih Layanan', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  services.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ) 
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: services.map((service) {
                            final isSelected = _selectedServiceType == service['title'];
                            
                            return ChoiceChip(
                              label: Text(service['title'] ?? 'Service'),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedServiceType = service['title'];
                                  _selectedPackage = null; // Reset package when service changes
                                });
                              },
                              selectedColor: GarasifyyTheme.primaryRed,
                              backgroundColor: GarasifyyTheme.cardDark,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                            );
                          }).toList(),
                        ),

                  // Package Selection (Dynamic based on Service)
                  if (_selectedServiceType != null) ...[
                    const SizedBox(height: 24),
                    Text('Pilih Paket', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                         // Find selected service data
                         final selectedServiceData = services.firstWhere(
                           (s) => s['title'] == _selectedServiceType, 
                           orElse: () => {},
                         );
                         final packages = (selectedServiceData['packages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                         
                         if (packages.isEmpty) {
                           return const Padding(
                             padding: EdgeInsets.symmetric(vertical: 8.0),
                             child: Text('Tidak ada paket tersedia untuk layanan ini. Hubungi CS untuk info lanjut.', style: TextStyle(color: Colors.grey)),
                           );
                         }

                         return Column(
                           children: packages.map((package) {
                             final isSelected = _selectedPackage?['name'] == package['name'];
                             return Container(
                               margin: const EdgeInsets.only(bottom: 12),
                               decoration: BoxDecoration(
                                 color: isSelected ? GarasifyyTheme.cardDark : GarasifyyTheme.cardDark.withAlpha(200),
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(
                                   color: isSelected ? GarasifyyTheme.primaryRed : Colors.white12,
                                   width: isSelected ? 2 : 1,
                                 ),
                               ),
                               child: Material(
                                 color: Colors.transparent,
                                 child: InkWell(
                                   onTap: () {
                                     setState(() {
                                       _selectedPackage = package;
                                     });
                                   },
                                   borderRadius: BorderRadius.circular(12),
                                   child: Padding(
                                     padding: const EdgeInsets.all(16),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(
                                               package['name'] ?? 'Paket',
                                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                             ),
                                             if (isSelected) 
                                               const Icon(Icons.check_circle, color: GarasifyyTheme.primaryRed)
                                           ],
                                         ),
                                         const SizedBox(height: 4),
                                         Text(
                                           package['price'] ?? '',
                                           style: const TextStyle(color: GarasifyyTheme.primaryRed, fontWeight: FontWeight.bold),
                                         ),
                                         const SizedBox(height: 8),
                                         Wrap(
                                           spacing: 8,
                                           runSpacing: 4,
                                           children: (package['features'] as List? ?? []).take(3).map((f) => 
                                             Text('• $f', style: const TextStyle(color: Colors.grey, fontSize: 12))
                                           ).toList(),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             );
                           }).toList(),
                         );
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Vehicle Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kendaraan', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                      TextButton.icon(
                        onPressed: _toggleNewVehicle,
                        icon: Icon(
                          _useNewVehicle ? Icons.list : Icons.add,
                          size: 18,
                          color: GarasifyyTheme.primaryRed,
                        ),
                        label: Text(
                          _useNewVehicle ? 'Pilih Tersimpan' : 'Input Baru',
                          style: const TextStyle(color: GarasifyyTheme.primaryRed, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Saved Vehicles Selector
                  if (!_useNewVehicle && userId != null)
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _firestoreService.getUserVehicles(userId),
                      builder: (context, vehiclesSnapshot) {
                        final vehicles = vehiclesSnapshot.data ?? [];
                        
                        if (vehicles.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: GarasifyyTheme.cardDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Belum ada kendaraan tersimpan',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => context.push('/vehicles'),
                                  child: const Text('Tambah Kendaraan', style: TextStyle(color: GarasifyyTheme.primaryRed)),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ...vehicles.map((vehicle) {
                              final isSelected = _selectedVehicle?['id'] == vehicle['id'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Material(
                                  color: isSelected ? GarasifyyTheme.primaryRed.withAlpha(30) : GarasifyyTheme.cardDark,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    onTap: () => _selectVehicle(vehicle),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: isSelected 
                                          ? Border.all(color: GarasifyyTheme.primaryRed, width: 2)
                                          : null,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car,
                                            color: isSelected ? GarasifyyTheme.primaryRed : Colors.grey,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vehicle['plateNumber'] ?? '-',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  vehicle['model'] ?? '-',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(Icons.check_circle, color: GarasifyyTheme.primaryRed),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),

                  // Manual Vehicle Input
                  if (_useNewVehicle || _selectedVehicle != null) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _modelController,
                      label: 'Model Mobil (ex: Honda Civic Turbo)',
                      icon: Icons.directions_car,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                      enabled: _useNewVehicle,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _plateController,
                      label: 'Plat Nomor (ex: B 1234 ABC)',
                      icon: Icons.numbers,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                      enabled: _useNewVehicle,
                    ),
                  ],

                  const SizedBox(height: 24),
                  
                  // Date Selection
                  Text('Jadwal Booking', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: GarasifyyTheme.cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: GarasifyyTheme.primaryRed),
                          const SizedBox(width: 16),
                          Text(
                            _selectedDate == null 
                                ? 'Pilih Tanggal' 
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Notes
                  _buildTextField(
                    controller: _notesController,
                    label: 'Catatan Tambahan',
                    icon: Icons.note,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 40),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GarasifyyTheme.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('BOOKING SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: enabled ? Colors.white : Colors.grey),
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: GarasifyyTheme.primaryRed),
        filled: true,
        fillColor: GarasifyyTheme.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

