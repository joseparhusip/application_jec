// lib/pages/layanan_jec_page.dart (KODE LENGKAP & DIPERBARUI)

import 'package:flutter/material.dart';
// --- PERUBAHAN: Import model yang sudah dipisah dengan nama file baru ---
import 'package:application_jec_frontend/models/layanan_models.dart';

const List<Layanan> _layananList = [
  Layanan(nama: 'Kontrol Miopia', assetPath: 'assets/layanan/layananmiopia.png'),
  Layanan(nama: 'Kornea', assetPath: 'assets/layanan/layanankornea.png'),
  Layanan(nama: 'Low Vision', assetPath: 'assets/layanan/layananlowvision.png'),
  Layanan(nama: 'Katarak, Lensa dan Bedah Refraktif', assetPath: 'assets/layanan/layanankatarak.png'),
  Layanan(nama: 'Layanan Glaukoma', assetPath: 'assets/layanan/layananglaukama.png'),
  Layanan(nama: 'Layanan Retina', assetPath: 'assets/layanan/layananretina.png'),
  Layanan(nama: 'Layanan Okuloplasti dan Rekonstruksi Orbita', assetPath: 'assets/layanan/layananokuloplasti.png'),
  Layanan(nama: 'Layanan Mata Anak (Pediatrik) dan Mata Juling', assetPath: 'assets/layanan/layananmataanak.png'),
  Layanan(nama: 'Layanan Lensa Kontak', assetPath: 'assets/layanan/layananlensakontak.png'),
  Layanan(nama: 'Layanan Infeksi dan Imunologi', assetPath: 'assets/layanan/layananinfeksi.png'),
  Layanan(nama: 'Layanan Neuro-Oftalmologi', assetPath: 'assets/layanan/layananneuro.png'),
  Layanan(nama: 'Layanan Mata Kering', assetPath: 'assets/layanan/layananmatakering.png'),
  Layanan(nama: 'Layanan Trauma Oftalmik', assetPath: 'assets/layanan/layanantrauma.png'),
  Layanan(nama: 'Layanan Sel Punca', assetPath: 'assets/layanan/eyecheck.png'),
  Layanan(nama: 'Eye Check', assetPath: 'assets/layanan/eyecheck.png'),
  Layanan(nama: 'Teleoftalmologi', assetPath: 'assets/layanan/teleooftalmologi.png'),
  Layanan(nama: 'Thyroid Eye', assetPath: 'assets/layanan/eyecheck.png'),
];


class LayananJecPage extends StatelessWidget {
  const LayananJecPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : colorScheme.primary,
      appBar: AppBar(
        title: const Text('Layanan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tersedia ${_layananList.length} Layanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _layananList.length,
                      itemBuilder: (context, index) {
                        final layanan = _layananList[index];
                        return _buildServiceGridItem(
                          konteks: context,
                          assetPath: layanan.assetPath,
                          label: layanan.nama,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGridItem({
    required BuildContext konteks,
    required String assetPath,
    required String label,
  }) {
    final colorScheme = Theme.of(konteks).colorScheme;
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(konteks).showSnackBar(
          SnackBar(content: Text('$label diklik!')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              assetPath,
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.2,
                color: colorScheme.onSurface.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}