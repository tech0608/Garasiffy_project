import 'package:flutter/material.dart';

class SeedData {
  static final List<Map<String, dynamic>> services = [
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
}
