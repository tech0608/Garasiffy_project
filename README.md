# Garasiffy - Digital Workshop Management System

## 📋 Latar Belakang Proyek

### Tentang Garasiffy
**Garasiffy** adalah sebuah startup yang bergerak di bidang layanan bengkel modifikasi kendaraan dengan konsep **"One Stop Modification"**. Bengkel ini menyediakan layanan modifikasi komprehensif yang meliputi:

- **Engine** - Modifikasi mesin dan performa kendaraan
- **Interior** - Penyesuaian dan peningkatan bagian dalam kendaraan
- **Exterior** - Modifikasi tampilan luar kendaraan
- **Audio** - Instalasi dan peningkatan sistem audio kendaraan

### Masalah yang Dihadapi
Sebelum adanya sistem digital, Garasiffy menghadapi beberapa tantangan dalam mengelola operasional bengkel:

- 📊 **Pengelolaan antrian yang tidak terstruktur** - Kesulitan dalam melacak kendaraan mana yang sedang dikerjakan dan urutan pengerjaan
- 🔍 **Transparansi proses kerja yang terbatas** - Konsumen tidak dapat memantau progress pengerjaan kendaraan mereka secara real-time
- 📱 **Komunikasi yang kurang efisien** - Antara konsumen dan pengelola bengkel memerlukan sistem yang lebih baik
- ⏱️ **Estimasi waktu yang tidak akurat** - Sulit memberikan informasi kepastian kapan pekerjaan akan selesai
- 📈 **Manajemen sumber daya yang tidak optimal** - Kesulitan dalam mengalokasikan mekanik dan peralatan dengan efisien

### Solusi: Aplikasi Garasiffy Mobile
Proyek ini merupakan konversi dari versi web sebelumnya ([Garasifyy_UTS_Web1](https://github.com/tech0608/Garasifyy_UTS_Web1)) ke platform mobile yang lebih accessible dan user-friendly.

#### Tujuan Aplikasi:

1. **Untuk Konsumen:**
   - ✅ Memudahkan pemesanan dan booking modifikasi kendaraan
   - ✅ Otomatis masuk ke dalam antrian setelah booking
   - ✅ Menerima estimasi waktu kapan dapat masuk ke bengkel
   - ✅ Memantau progress pengerjaan secara real-time (sudah berapa persen dikerjakan)
   - ✅ Menerima notifikasi/update tentang perkembangan pekerjaan
   - ✅ Komunikasi langsung dengan bengkel

---

## 🎯 Fitur Utama
Aplikasi Garasiffy dirancang dengan fitur-fitur berikut:

### 📅 Booking System (Sistem Pemesanan)
- **Browse Services** - Konsumen dapat melihat daftar layanan modifikasi yang tersedia
- **Book Modification** - Konsumen dapat memilih jenis modifikasi yang diinginkan
- **Automatic Queue Entry** - Setelah booking selesai, konsumen otomatis masuk ke dalam antrian
- **Time Estimation** - Sistem memberikan estimasi tanggal dan waktu kapan kendaraan dapat masuk ke bengkel berdasarkan:
  - Antrian saat ini
  - Kapasitas mekanik
  - Durasi pengerjaan untuk jenis modifikasi yang dipilih
- **Booking Confirmation** - Konfirmasi booking dengan detail lengkap

### User Management
- Registrasi dan login untuk konsumen
- Profile management
- History riwayat modifikasi
- Data kendaraan konsumen

### Queue Management (Manajemen Antrian)
- Daftar antrian kendaraan yang real-time
- Status pengerjaan kendaraan (menunggu/sedang dikerjakan/selesai)
- Prioritas antrian
- Estimasi waktu penyelesaian yang dinamis

### Progress Tracking (Pemantauan Progress)
- Update persentase progres pengerjaan
- Breakdown task/pekerjaan yang dilakukan
- Timeline pengerjaan
- Notifikasi otomatis kepada konsumen saat status berubah

### Notification System
- Notifikasi push untuk update status kendaraan
- Notifikasi reminder booking approach (kendaraan akan masuk bengkel)
- Email/SMS notification (opsional)

---

## 🛠️ Tech Stack
*Teknologi yang digunakan:*
- **Framework:** Flutter (Mobile)
- **Language:** Dart
- **Backend:** Firebase (Firestore, Auth, Cloud Functions)
- **State Management:** Provider
- **Architecture:** MVVM Design Pattern

## 📦 Konversi dari Web Version
Proyek ini mengonversi aplikasi web asli dengan meningkatkan:
- User experience untuk mobile devices
- Performa dan kecepatan akses
- Kemudahan penggunaan real-time di lapangan
- Integration dengan notification system
- Fitur booking yang seamless dan user-friendly

## 📱 Platform Target
- **Android**

## 🚀 Status Proyek
*Completed (v1.0.0)*

## 👥 Tim Pengembang
- **Developer:** @tech0608

## 📄 Lisensi
This project is created for educational purposes as part of UAS Mobile Programing 2 assignment.

Developed by **Luthfy Arief**
**Universitas Teknologi Bandung (UTB)**

---

© 2026 Garasify - Premium Car Modification Platform. All rights reserved.

**Catatan:** Proyek ini fokus pada digitalisasi proses manajemen bengkel modifikasi untuk meningkatkan efisiensi operasional dan kepuasan konsumen melalui transparansi, komunikasi yang lebih baik, serta sistem booking dan antrian yang terstruktur.
