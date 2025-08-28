// tes_mata_page.dart (WARNA BARU)

import 'package:flutter/material.dart';
// IMPORT HALAMAN TES YANG SUDAH KITA BUAT
import '../page_test/visual_acuity_test_page.dart';
import '../page_test/astigmatism_test_page.dart';
import '../page_test/presbyopia_test_page.dart';
import '../page_test/duochrome_test_page.dart';
import '../page_test/color_blind_test_page.dart';

class TesMataPage extends StatelessWidget {
  const TesMataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme; // Ambil colorScheme dari tema
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: isDarkMode
            ? const BoxDecoration(color: Colors.black)
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // --- PERUBAHAN DI SINI ---
                    colorScheme.primary.withAlpha(204), // Menggunakan warna primer tema
                    Colors.grey.shade100,
                  ],
                  stops: const [0.0, 0.2],
                ),
              ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Tes Mata',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    _buildDisclaimerCard(),
                    const SizedBox(height: 20),
                    _TestCard(
                      imageAsset: 'assets/icons/visualacuity.png',
                      title: 'Visual Acuity',
                      description: 'Tes ini digunakan untuk menentukan huruf terkecil yang dapat Anda baca pada layar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VisualAcuityTestPage()),
                        );
                      },
                    ),
                    _TestCard(
                      imageAsset: 'assets/icons/astigmatism.png',
                      title: 'Astigmatism',
                      description: 'Tes ini digunakan untuk menentukan apakah Anda memerlukan koreksi silinder atau tidak',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AstigmatismTestPage()),
                        );
                      },
                    ),
                    _TestCard(
                      imageAsset: 'assets/icons/presbyopia.png',
                      title: 'Presbyopia',
                      description: 'Tes ini digunakan untuk menentukan apakah Anda memerlukan kacamata baca atau tidak',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PresbyopiaTestPage()),
                        );
                      },
                    ),
                    _TestCard(
                      imageAsset: 'assets/icons/duochrome.png',
                      title: 'Duochrome',
                      description: 'Tes ini digunakan untuk menganalisa refraksi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DuochromeTestPage()),
                        );
                      },
                    ),
                    _TestCard(
                      imageAsset: 'assets/icons/butawarna.jpg',
                      title: 'Tes Buta Warna',
                      description: 'Tes ini digunakan untuk menentukan apakah Anda memiliki ketidakmampuan untuk melihat warna atau melihat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ColorBlindTestPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Builder(builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withAlpha(77),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.secondaryContainer),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih salah satu tes di bawah atau ikuti keseluruhan tes. Hasil tes ini tidak dapat menggantikan hasil pemeriksaan oleh dokter.',
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 10),
            Text(
              '*Silakan gunakan lensa kontak atau kacamata biasa dan gadget anda 30cm di depan Anda',
              style: TextStyle(color: colorScheme.onSurface.withAlpha(179), fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ],
        ),
      );
    });
  }
}

class _TestCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _TestCard({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                imageAsset,
                height: 45,
                width: 45,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 45);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withAlpha(179), height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}