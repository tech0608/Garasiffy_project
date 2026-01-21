import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _usersRef => _db.collection('users');
  CollectionReference get _projectsRef => _db.collection('projects');
  CollectionReference get _servicesRef => _db.collection('services');
  CollectionReference get _notificationsRef => _db.collection('notifications');

  // Stream of Active Projects for a specific user
  Stream<List<Map<String, dynamic>>> getUserProjects(String userId) {
    return _projectsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).where((project) {
        // Filter in memory to avoid composite index
        final status = project['status'] as String?;
        return status == 'waiting' || status == 'on_progress' || status == 'completed';
      }).toList();
      
      // Sort in memory by updatedAt
      projects.sort((a, b) {
        final aTime = a['updatedAt'] as Timestamp?;
        final bTime = b['updatedAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // Descending order
      });
      
      return projects;
    });
  }

  // Stream of Project History (completed/cancelled) for a specific user
  Stream<List<Map<String, dynamic>>> getProjectHistory(String userId) {
    return _projectsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).where((project) {
        // Filter for completed or cancelled projects only
        final status = project['status'] as String?;
        return status == 'completed' || status == 'cancelled';
      }).toList();
      
      // Sort in memory by updatedAt
      projects.sort((a, b) {
        final aTime = a['updatedAt'] as Timestamp?;
        final bTime = b['updatedAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // Descending order (newest first)
      });
      
      return projects;
    });
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Create or Update User Profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).set(data, SetOptions(merge: true));
  }

  // --- SERVICES ---
  
  // Get all services
  Stream<List<Map<String, dynamic>>> getServices() {
    return _servicesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Helper to seed services (Run once if needed)
  Future<void> seedServices() async {
    final snapshot = await _servicesRef.get();
    
    // Check if re-seed is needed (empty or missing packages)
    bool needReseed = snapshot.docs.isEmpty;
    if (!needReseed) {
      // Check if Engine Overhaul has packages (as an indicator of old schema)
      final overhaul = snapshot.docs.firstWhere(
        (doc) => (doc.data() as Map<String, dynamic>)['type'] == 'engine_overhaul',
        orElse: () => snapshot.docs.first,
      );
      if (!(overhaul.data() as Map<String, dynamic>).containsKey('packages')) {
        needReseed = true;
        // Delete old data
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        debugPrint('🗑️ Deleted old services to update schema');
      }
    }

    if (needReseed) {
      final services = [
        // Engine & Performance
        {
          'type': 'engine_upgrade',
          'title': 'Engine Upgrade',
          'iconCode': Icons.bolt.codePoint,
          'colorValue': 0xFFDC143C, 
          'description': 'Optimalkan performa mesin dengan ECU tuning, turbo kit, atau supercharger.',
          'category': 'Performance',
          'packages': [
            {'name': 'Stage 1 (Street)', 'price': 'Rp 3.5 Jt', 'features': ['ECU Remap / Piggyback', 'Replacement Air Filter', 'Dyno Test & Tuning']},
            {'name': 'Stage 2 (Sport)', 'price': 'Rp 12.5 Jt', 'features': ['Full Exhaust System', 'Open Filter Intake', 'ECU Remap Stage 2', 'Busi Racing']},
            {'name': 'Stage 3 (Pro)', 'price': 'Call for Price', 'features': ['Turbo/Supercharger Kit', 'Internal Engine Forging', 'Standalone ECU']},
          ]
        },
        {
          'type': 'engine_overhaul',
          'title': 'Engine Overhaul',
          'iconCode': Icons.settings_suggest.codePoint,
          'colorValue': 0xFFFF6347,
          'description': 'Perbaikan dan restorasi mesin secara menyeluruh.',
          'category': 'Repair',
          'packages': [
            {'name': 'Top Overhaul', 'price': 'Rp 4.5 Jt', 'features': ['Gasket cylinder head', 'Skir klep', 'Seal klep', 'Pembersihan kerak']},
            {'name': 'General Overhaul', 'price': 'Rp 8.5 Jt', 'features': ['Ring piston', 'Metal duduk/jalan', 'Honing liner', 'Full Gasket set']},
            {'name': 'Total Rebuild', 'price': 'Custom', 'features': ['Ganti piston set', 'Stang piston', 'Kruk as balancing', 'Blueprinting']},
          ]
        },
        {
          'type': 'exhaust_system',
          'title': 'Exhaust System',
          'iconCode': Icons.air.codePoint,
          'colorValue': 0xFF8B4513, 
          'description': 'Upgrade sistem pembuangan untuk performa dan suara lebih baik.',
          'category': 'Performance',
          'packages': [
             {'name': 'Catback System', 'price': 'Rp 3.5 Jt', 'features': ['Resonator Stainless', 'Muffler Racing', 'Pipa Stainless 2.5 inch']},
             {'name': 'Full System NA', 'price': 'Rp 6.5 Jt', 'features': ['Header 4-2-1 / 4-1', 'Resonator', 'Muffler', 'Pipa Mandrel Bend']},
             {'name': 'Turbo Downpipe', 'price': 'Rp 2.5 Jt', 'features': ['Downpipe Stainless', 'Frontpipe', 'Laser Cut Flange']},
          ]
        },
        
        // Body & Exterior
        {
          'type': 'body_paint',
          'title': 'Body Paint',
          'iconCode': Icons.brush.codePoint,
          'colorValue': 0xFF1E90FF, 
          'description': 'Cat ulang body mobil dengan berbagai pilihan warna premium.',
          'category': 'Exterior',
          'packages': [
            {'name': 'Refresh', 'price': 'Rp 8 Jt', 'features': ['Siram Full Body', 'Minor Body Repair', 'Polish & Wax']},
            {'name': 'Premium Repaint', 'price': 'Rp 18 Jt', 'features': ['Kerok Total / Ganti Warna', 'Cat Premium (Spies Hecker)', 'Wet Gloss Finish']},
            {'name': 'Show Car', 'price': 'Custom', 'features': ['Custom Body Kit', 'Candy Paint', 'Nano Ceramic Coating']},
          ]
        },
        {
          'type': 'body_kit',
          'title': 'Body Kit Custom',
          'iconCode': Icons.directions_car.codePoint,
          'colorValue': 0xFF4169E1, 
          'description': 'Pasang body kit custom untuk tampilan lebih sporty.',
          'category': 'Exterior',
          'packages': [
            {'name': 'Add-on Lips', 'price': 'Rp 2.5 Jt', 'features': ['Front Lips', 'Side Skirt', 'Rear Diffuser', 'Bahan FRP/Plastic']},
            {'name': 'Full Bumper', 'price': 'Rp 7.5 Jt', 'features': ['Front Bumper Custom', 'Rear Bumper', 'Side Skirt', 'Fitting Presisi']},
            {'name': 'Wide Body', 'price': 'Custom', 'features': ['Fender Flare / Radius', 'Custom Spoiler', 'Wing GT Wing']},
          ]
        },
        {
          'type': 'wrapping',
          'title': 'Car Wrapping',
          'iconCode': Icons.palette.codePoint,
          'colorValue': 0xFF9370DB, 
          'description': 'Ganti warna mobil dengan sticker wrapping tanpa cat permanen.',
          'category': 'Exterior',
          'packages': [
            {'name': 'Standard Gloss/Matte', 'price': 'Rp 4.5 Jt', 'features': ['Oracal 651', 'Full Body', 'Garansi Pemasangan 6 Bulan']},
            {'name': 'Premium Color', 'price': 'Rp 9.5 Jt', 'features': ['Teckwrap / Inozetek', 'Super Glossy', 'Minim Orange Peel', 'Garansi 2 Tahun']},
            {'name': 'PPF (Protection)', 'price': 'Rp 15 Jt', 'features': ['Paint Protection Film', 'Self Healing', 'Anti Gores Benda Tumpul']},
          ]
        },
        
        // Interior & Audio
        {
          'type': 'audio_install',
          'title': 'Audio System',
          'iconCode': Icons.speaker.codePoint,
          'colorValue': 0xFFFF8C00, 
          'description': 'Instalasi audio system premium dengan subwoofer dan amplifier.',
          'category': 'Interior',
          'packages': [
            {'name': 'Daily Comfort', 'price': 'Rp 4.5 Jt', 'features': ['Speaker 2-Way Split', 'Subwoofer Kolong', 'Peredam Pintu']},
            {'name': 'Concert Hall', 'price': 'Rp 15 Jt', 'features': ['Speaker 3-Way High End', 'DSP Processor 8 Ch', 'Power Amplifier']},
            {'name': 'VIP Lounge', 'price': 'Custom', 'features': ['Retrim Jok Nappa', 'Full Peredam', 'Custom Minibar']},
          ]
        },
        {
          'type': 'interior_upgrade',
          'title': 'Interior Upgrade',
          'iconCode': Icons.airline_seat_recline_normal.codePoint,
          'colorValue': 0xFFDAA520, 
          'description': 'Upgrade jok kulit, dashboard, dan interior custom.',
          'category': 'Interior',
          'packages': [
            {'name': 'Jok Paten Synthetic', 'price': 'Rp 3.5 Jt', 'features': ['Bahan MBTech Carrera/Superior', 'Jahitan Double Stitch', 'Busa Tambahan']},
            {'name': 'Jok Microfiber', 'price': 'Rp 5.5 Jt', 'features': ['Bahan Microfiber Leather', 'Adem & Kuat', 'Garansi Bahan 3 Tahun']},
            {'name': 'Full Interior', 'price': 'Rp 8.5 Jt', 'features': ['Jok', 'Doortrim', 'Plafon', 'Karpet Dasar', 'Dashboard']},
          ]
        },
        
        // Suspension & Wheels
        {
          'type': 'suspension',
          'title': 'Suspension Upgrade',
          'iconCode': Icons.height.codePoint,
          'colorValue': 0xFF32CD32, 
          'description': 'Upgrade suspensi untuk handling dan kenyamanan lebih baik.',
          'category': 'Performance',
          'packages': [
            {'name': 'Lowering Kit', 'price': 'Rp 3.5 Jt', 'features': ['Per Eibach / Tein', 'Turun 2-3 jari', 'Handling Stabil']},
            {'name': 'Coilover Street', 'price': 'Rp 12 Jt', 'features': ['Adjustable Height', 'Adjustable Damper (Soft-Hard)', 'ISC / Tein']},
            {'name': 'Air Suspension', 'price': 'Rp 25 Jt', 'features': ['2 Point / 4 Point Management', 'Remote Wireless', 'Tanki Stainless']},
          ]
        },
        {
          'type': 'wheels_tires',
          'title': 'Wheels & Tires',
          'iconCode': Icons.trip_origin.codePoint,
          'colorValue': 0xFF2E8B57, 
          'description': 'Ganti velg racing dan ban performance.',
          'category': 'Performance',
          'packages': [
            {'name': 'Flow Form 15-16"', 'price': 'Rp 5.5 Jt', 'features': ['Velg Flow Form Ringan', 'Replika High Quality', 'Free Balancing']},
            {'name': 'Original Japan 15-16"', 'price': 'Rp 18 Jt', 'features': ['Volk Rays / Enkei Original', 'Second Good Condition / New']},
            {'name': 'Paket Ban Sport', 'price': 'Rp 4 Jt', 'features': ['4 Pcs Ban Semi Slick (SX2 / AD08R)', 'Nitrogen', 'Spooring 3D']},
          ]
        },
        
        // Electrical & Electronics
        {
          'type': 'lighting',
          'title': 'Lighting Upgrade',
          'iconCode': Icons.lightbulb.codePoint,
          'colorValue': 0xFFFFD700, 
          'description': 'Upgrade lampu LED, HID xenon, atau DRL.',
          'category': 'Electrical',
          'packages': [
            {'name': 'LED Headlamp', 'price': 'Rp 1.5 Jt', 'features': ['LED Chips Philips/Osram', 'Cahaya Putih/Kuning', 'Cut-off Rapi']},
            {'name': 'Projector HID/Bi-LED', 'price': 'Rp 3.5 Jt', 'features': ['Lensa Projector 3 Inch', 'Demon Eyes', 'DRL Running Sein']},
            {'name': 'Custom Lazy Eyes', 'price': 'Rp 5.5 Jt', 'features': ['Acrylic Custom', 'RGB Smartphone Control', 'Unique Design']},
          ]
        },
        {
          'type': 'security_system',
          'title': 'Security System',
          'iconCode': Icons.security.codePoint,
          'colorValue': 0xFF808080, 
          'description': 'Instalasi alarm, GPS tracker, dan immobilizer.',
          'category': 'Electrical',
          'packages': [
            {'name': 'Alarm System', 'price': 'Rp 1.2 Jt', 'features': ['Remote Sliding Code', 'Sensor Getar', 'Central Lock Integration']},
            {'name': 'GPS Tracker', 'price': 'Rp 1.8 Jt', 'features': ['Realtime Tracking App', 'Matikan Mesin Jarak Jauh', 'Sadap Suara']},
            {'name': 'Keyless Entry', 'price': 'Rp 3.5 Jt', 'features': ['Start/Stop Button', 'Passive Keyless Entry', 'Remote Engine Start']},
          ]
        },
        
        // Maintenance & Service
        {
          'type': 'general_service',
          'title': 'General Service',
          'iconCode': Icons.build.codePoint,
          'colorValue': 0xFF228B22, 
          'description': 'Service berkala: ganti oli, filter, tune up.',
          'category': 'Maintenance',
          'packages': [
            {'name': 'Basic Service', 'price': 'Rp 850 Rb', 'features': ['Ganti Oli (Shell/Motul)', 'Filter Oli', 'Cek 30 Titik', 'Cuci & Vacuum']},
            {'name': 'Performance', 'price': 'Rp 2.2 Jt', 'features': ['Basic Service', 'Tune Up Carbon Clean', 'Injector Cleaning', 'Flushing Rem']},
            {'name': 'Restoration', 'price': 'Custom', 'features': ['Overhaul Mesin', 'Peremajaan Kaki-kaki', 'Restorasi Kelistrikan']},
          ]
        },
        {
          'type': 'brake_system',
          'title': 'Brake System',
          'iconCode': Icons.warning.codePoint,
          'colorValue': 0xFFB22222, 
          'description': 'Perbaikan dan upgrade sistem rem untuk keamanan optimal.',
          'category': 'Maintenance',
          'packages': [
            {'name': 'Brake Pad Replacement', 'price': 'Rp 800 Rb', 'features': ['Kampas Rem Ceramic/Semi-Metal', 'Bubut Disc Brake', 'Minyak Rem Dot 4']},
            {'name': 'Big Brake Kit 4 Pot', 'price': 'Rp 12 Jt', 'features': ['Kaliper 4 Piston', 'Disc 285-300mm', 'Braided Brake Lines']},
            {'name': 'Big Brake Kit 6 Pot', 'price': 'Rp 22 Jt', 'features': ['Kaliper 6 Piston', 'Disc 330-355mm', 'Floating Disc']},
          ]
        },
        {
          'type': 'ac_service',
          'title': 'AC Service',
          'iconCode': Icons.ac_unit.codePoint,
          'colorValue': 0xFF87CEEB, 
          'description': 'Service AC mobil: isi freon, bersih evaporator, ganti filter.',
          'category': 'Maintenance',
          'packages': [
            {'name': 'Cuci AC Ringan', 'price': 'Rp 350 Rb', 'features': ['Cuci Evaporator', 'Cuci Kondensor', 'Vacuum Interior']},
            {'name': 'Service Besar', 'price': 'Rp 1.5 Jt', 'features': ['Turun Dashboard', 'Cuci Blowe', 'Ganti Filter Kabin', 'Isi Freon & Oli']},
            {'name': 'Ganti Kompresor', 'price': 'Custom', 'features': ['Kompresor Original Denso/Sand', 'Flushing Sistem', 'Garansi Dingin']},
          ]
        },
        {
          'type': 'detailing',
          'title': 'Car Detailing',
          'iconCode': Icons.cleaning_services.codePoint,
          'colorValue': 0xFF20B2AA, 
          'description': 'Cuci detail, poles, coating, dan salon mobil premium.',
          'category': 'Maintenance',
          'packages': [
            {'name': 'Express Polish', 'price': 'Rp 1.5 Jt', 'features': ['1 Step Polish', 'Wax Protection', 'Interior Vacuum', 'Glass Cleaning']},
            {'name': 'Deep Gloss Coating', 'price': 'Rp 3.5 Jt', 'features': ['3 Step Paint Correction', 'Nano Ceramic 2 Layer', 'Detailing Mesin & Interior']},
            {'name': 'Platinum Package', 'price': 'Rp 6.5 Jt', 'features': ['Multi Layer Ceramic 9H', 'Full Interior Detailing', 'Undercarriage Detailing']},
          ]
        },
      ];

      for (var service in services) {
        await _servicesRef.add(service);
      }
      debugPrint('✅ Seeded ${services.length} services to Firestore');
    }
  }

  // Helper to reset/delete all services (for updating seed data)
  Future<void> resetServices() async {
    final snapshot = await _servicesRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    debugPrint('🗑️ Deleted ${snapshot.docs.length} old services');
    // Re-seed with new data
    await seedServices();
  }

  // --- BOOKING / PROJECTS ---

  // Create a new booking
  Future<void> createBooking({
    required String userId,
    required String serviceType,
    required String plateNumber,
    required String carModel,
    required String notes,
    required DateTime bookingDate,
    Map<String, dynamic>? selectedPackage,
  }) async {
    final docRef = await _projectsRef.add({
      'userId': userId,
      'serviceType': serviceType,
      'plateNumber': plateNumber,
      'carModel': carModel,
      'notes': notes,
      'bookingDate': bookingDate,
      'selectedPackage': selectedPackage,
      'status': 'waiting',
      'progress': 0.0,
      'totalCost': 0, // Will be updated by admin
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Create notification for booking
    await createNotification(
      userId: userId,
      type: 'booking_created',
      title: 'Booking Berhasil',
      message: 'Booking $serviceType untuk $carModel ($plateNumber) telah dibuat.',
      referenceId: docRef.id,
    );
  }

  // Get single project by ID
  Future<Map<String, dynamic>?> getProjectById(String projectId) async {
    try {
      final doc = await _projectsRef.doc(projectId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting project: $e');
      return null;
    }
  }

  // Stream single project
  Stream<Map<String, dynamic>?> streamProject(String projectId) {
    return _projectsRef.doc(projectId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    });
  }

  // --- NOTIFICATIONS ---

  // Get notifications for a user
  Stream<List<Map<String, dynamic>>> getNotifications(String userId) {
    return _notificationsRef
        .where('userId', isEqualTo: userId)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Sort in memory to avoid needing a composite index
      notifications.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1; // Null Last
        if (bTime == null) return -1;
        return bTime.compareTo(aTime); // Descending (Newest first)
      });

      return notifications;
    });
  }

  // Get unread notification count
  Stream<int> getUnreadNotificationCount(String userId) {
    return _notificationsRef
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'isRead': true});
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    final batch = _db.batch();
    final snapshot = await _notificationsRef
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // Create notification
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? referenceId,
  }) async {
    await _notificationsRef.add({
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'referenceId': referenceId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // --- VEHICLES ---

  // Get vehicles collection for a user
  CollectionReference _vehiclesRef(String userId) => 
      _usersRef.doc(userId).collection('vehicles');

  // Get all vehicles for a user
  Stream<List<Map<String, dynamic>>> getUserVehicles(String userId) {
    return _vehiclesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Add a vehicle
  Future<void> addVehicle({
    required String userId,
    required String plateNumber,
    required String model,
    String? year,
    String? color,
  }) async {
    await _vehiclesRef(userId).add({
      'plateNumber': plateNumber,
      'model': model,
      'year': year ?? '',
      'color': color ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update a vehicle
  Future<void> updateVehicle({
    required String vehicleId,
    required String plateNumber,
    required String model,
    String? year,
    String? color,
  }) async {
    // We need to find the vehicle in any user's subcollection
    // For simplicity, we'll use a collection group query approach
    // But since this is user-specific, the caller should provide userId
    // For now, we'll use a workaround through the app
    final querySnapshot = await _db.collectionGroup('vehicles')
        .where(FieldPath.documentId, isEqualTo: vehicleId)
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'plateNumber': plateNumber,
        'model': model,
        'year': year ?? '',
        'color': color ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    final querySnapshot = await _db.collectionGroup('vehicles')
        .where(FieldPath.documentId, isEqualTo: vehicleId)
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }
}
