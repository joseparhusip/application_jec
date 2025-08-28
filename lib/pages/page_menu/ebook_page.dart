// lib/page_menu/ebook_page.dart (Versi Perbaikan)

import 'package:flutter/material.dart';
import 'package:application_jec_frontend/models/ebook_models.dart';
// DIUBAH: Menggunakan import yang benar dari file viewer PDF fungsional
import 'pdf_viewer_page.dart'; 


class EbookPage extends StatefulWidget {
  const EbookPage({super.key});

  @override
  State<EbookPage> createState() => _EbookPageState();
}

class _EbookPageState extends State<EbookPage> {
  // Daftar data E-Book sesuai dengan file PDF yang ada
  final List<Ebook> _ebookList = [
    const Ebook(
      title: 'Buku Panduan COVID-19 JEC',
      subtitle: 'Panduan Lengkap COVID-19',
      imagePath: 'assets/file/Buku-Panduan-Covid.webp',
      pdfPath: 'assets/file/Buku Panduan COVID-19 JEC v8.pdf',
      description: 'Panduan lengkap penanganan COVID-19 di fasilitas kesehatan mata JEC',
      author: 'Tim Medis JEC',
    ),
    const Ebook(
      title: 'EYESIGHT Special Edition 2020',
      subtitle: 'Edisi Khusus 2020',
      imagePath: 'assets/file/EYESIGHT-COVER.webp',
      pdfPath: 'assets/file/EYESIGHT SPECIAL EDITION 2020.pdf',
      description: 'Publikasi khusus JEC Eye Hospitals & Clinics untuk tahun 2020',
      author: 'JEC Eye Hospitals',
    ),
    const Ebook(
      title: 'JEC Lengkap',
      subtitle: 'Revisi 9',
      imagePath: 'assets/file/Screenshot_6.webp',
      pdfPath: 'assets/file/JEC_Lengkap_rev_9.pdf',
      description: 'Panduan lengkap layanan JEC Eye Hospitals & Clinics',
      author: 'JEC Eye Hospitals',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: isDarkMode
            ? const BoxDecoration(color: Colors.black)
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withAlpha(230),
                    colorScheme.primary,
                  ],
                ),
              ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Kustom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : colorScheme.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'E-Book',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.search, color: isDarkMode ? Colors.white : colorScheme.onPrimary),
                      onPressed: () {
                        _showSearchDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              // Konten Utama
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header section dengan informasi
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Koleksi E-Book',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Akses berbagai publikasi dan panduan kesehatan mata',
                              style: TextStyle(
                                fontSize: 16,
                                // DIPERBAIKI: Mengatasi deprecated 'withOpacity'
                                color: colorScheme.onSurface.withAlpha(179), // Opacity 0.7
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_ebookList.length} E-Book tersedia',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // GridView untuk E-Book
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: _ebookList.length,
                          itemBuilder: (context, index) {
                            final ebook = _ebookList[index];
                            return _EbookCard(
                              ebook: ebook,
                              // DIUBAH: onTap sekarang langsung membuka PDF viewer
                              onTap: () {
                                if (ebook.pdfPath != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(
                                        pdfPath: ebook.pdfPath!,
                                        title: ebook.title,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('File PDF tidak tersedia'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
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
        ),
      ),
    );
  }

  // DIHAPUS: Method _openEbook tidak diperlukan lagi karena navigasi langsung.
  
  // Method untuk menampilkan dialog pencarian (tetap dipertahankan)
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pencarian E-Book'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Masukkan kata kunci...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}

// Widget kustom untuk setiap kartu E-Book
class _EbookCard extends StatelessWidget {
  final Ebook ebook;
  final VoidCallback? onTap;
  
  const _EbookCard({
    required this.ebook,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 1,
              blurRadius: 8,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      ebook.imagePath,
                      // DIUBAH: Menggunakan BoxFit.contain agar gambar tidak terpotong
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          // DIPERBAIKI: Mengatasi deprecated 'surfaceVariant'
                          color: colorScheme.surfaceContainerHighest,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: 40,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ebook.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (ebook.pdfPath != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PDF',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ebook.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (ebook.subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          ebook.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            // DIPERBAIKI: Mengatasi deprecated 'withOpacity'
                            color: colorScheme.onSurface.withAlpha(179), // Opacity 0.7
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (ebook.author != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'oleh ${ebook.author}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}


