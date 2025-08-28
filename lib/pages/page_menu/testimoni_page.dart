// lib/pages/testimoni_page.dart (KODE LENGKAP & DIPERBARUI)

import 'package:flutter/material.dart';
// --- PERUBAHAN: Import model yang sudah dipisah dengan nama file baru ---
import 'package:application_jec_frontend/models/testimonial_models.dart';

class TestimoniPage extends StatefulWidget {
  const TestimoniPage({super.key});

  @override
  State<TestimoniPage> createState() => _TestimoniPageState();
}

class _TestimoniPageState extends State<TestimoniPage> {
  final List<Testimonial> _testimonialList = [
    const Testimonial(
      name: 'Ummu Habibah',
      role: '(Pasien BPJS JEC)',
      quote: '“Uang yang kami keluarkan NOL Rupiah.”',
      imagePath: 'assets/testimoni/testi1.png',
    ),
    const Testimonial(
      name: 'Arief Setiabudi',
      role: '(IT Consultant)',
      quote: '“LASIK satu pilihan seumur hidup yang nggak akan bikin nyesel.”',
      imagePath: 'assets/testimoni/testi2.png',
    ),
    const Testimonial(
      name: 'Memes Prameswari',
      role: '(Penyanyi)',
      quote: '“TODAY is a good day for LASIK, not tomorrow.”',
      imagePath: 'assets/testimoni/testi3.png',
    ),
    const Testimonial(
      name: 'Eva Celia',
      role: '(Musisi dan Aktris)',
      quote: '“Adventures are more fun without glasses.”',
      imagePath: 'assets/testimoni/testi4.png',
    ),
     const Testimonial(
      name: 'Isyana Sarasvati',
      role: '(Penyanyi & Penulis Lagu)',
      quote: '“Akhirnya setelah 23 tahun, aku bisa melihat dunia dengan mata telanjangku sendiri.”',
      imagePath: 'assets/testimoni/testi5.png',
    ),
      const Testimonial(
      name: 'Gita Savitri Devi',
      role: '(Content Creator)',
      quote: '“JEC a life changing experience and a great investment.”',
      imagePath: 'assets/testimoni/testi6.png',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : colorScheme.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Testimoni',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

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
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _testimonialList.length,
                    itemBuilder: (context, index) {
                      return _TestimonialCard(testimonial: _testimonialList[index]);
                    },
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

class _TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    testimonial.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.person, size: 50, color: Colors.grey.shade400));
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      testimonial.quote,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        shadows: [
                          Shadow(blurRadius: 5.0, color: Colors.black54)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      testimonial.role,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}