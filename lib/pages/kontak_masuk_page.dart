// kontak_masuk_page.dart - DENGAN SKELETON LOADING

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart'; // --- TAMBAHAN ---

class KotakMasukPage extends StatefulWidget {
  const KotakMasukPage({super.key});

  @override
  State<KotakMasukPage> createState() => _KotakMasukPageState();
}

class _KotakMasukPageState extends State<KotakMasukPage> {
  bool _isKotakMasukActive = true;
  // --- TAMBAHAN: State untuk loading ---
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // --- TAMBAHAN: Simulasi memuat data ---
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // --- TAMBAHAN: Widget untuk satu item skeleton ---
  Widget _buildSkeletonListItem(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: colorScheme.surfaceContainerHighest),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 150, color: Colors.grey),
                const SizedBox(height: 8),
                Container(height: 12, width: 200, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.9),
              colorScheme.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header (tetap sama)
               Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      'Kotak Masuk',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pilih',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Toggle Buttons (tetap sama)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              // Tombol 'Kotak Masuk'
                              Expanded(
                                // PERUBAHAN: Menambahkan GestureDetector untuk membuat tombol bisa diklik.
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isKotakMasukActive = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      // PERUBAHAN: Menggunakan variabel state _isKotakMasukActive
                                      color: _isKotakMasukActive ? colorScheme.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Kotak Masuk',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _isKotakMasukActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Tombol 'Notification'
                              Expanded(
                                // PERUBAHAN: Menambahkan GestureDetector untuk membuat tombol bisa diklik.
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isKotakMasukActive = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      // PERUBAHAN: Menggunakan variabel state _isKotakMasukActive
                                      color: !_isKotakMasukActive ? colorScheme.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Notification',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: !_isKotakMasukActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20), // Memberi jarak dari toggle button

                        // --- PERUBAHAN: Tampilkan skeleton atau empty state ---
                        Expanded(
                          child: _isLoading
                              ? Skeletonizer(
                                  child: ListView.builder(
                                    itemCount: 6, // Jumlah item skeleton
                                    itemBuilder: (context, index) => _buildSkeletonListItem(colorScheme),
                                  ),
                                )
                              : Center( // Tampilan jika data kosong setelah loading
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined, // Icon yang lebih relevan
                                        size: 80,
                                        color: colorScheme.outline,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Tidak Ada Pesan',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: colorScheme.outline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}