// color_blind_test_page.dart (KODE DIPERBAIKI)

import 'package:flutter/material.dart';

class ColorBlindTestPage extends StatefulWidget {
  const ColorBlindTestPage({super.key});

  @override
  State<ColorBlindTestPage> createState() => _ColorBlindTestPageState();
}

class _ColorBlindTestPageState extends State<ColorBlindTestPage> {
  final PageController _pageController = PageController();
  // Menggunakan Map untuk menyimpan jawaban per mata
  final Map<String, String> _answers = {};

  // --- DATA TES DIPUSATKAN DI SINI ---
  final String correctAnswer = '74';
  final List<String> options = const ['47', '74', '33', '29']; // Opsi disesuaikan dengan jawaban baru


  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _buildTestFlow();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _saveAnswer(String eye, String answer) {
    setState(() {
      _answers[eye] = answer;
    });
    _nextPage();
  }

  List<Widget> _buildTestFlow() {
    return [
      // 1. Instruksi tes mata kanan
      _InstructionScreen(
        imageAsset: 'assets/icons/mata-kiri.png',
        text: 'Tutup mata kiri Anda',
        onNext: _nextPage,
      ),
      // 2. Halaman tes mata kanan
      _TestQuestionScreen(
        options: options, // Mengirim data opsi
        onAnswered: (answer) => _saveAnswer('kanan', answer),
      ),
      // 3. Instruksi tes mata kiri
      _InstructionScreen(
        imageAsset: 'assets/icons/mata-kanan.png',
        text: 'Tutup mata kanan Anda',
        onNext: _nextPage,
      ),
      // 4. Halaman tes mata kiri
      _TestQuestionScreen(
        options: options, // Mengirim data opsi
        onAnswered: (answer) => _saveAnswer('kiri', answer),
      ),
      // 5. Halaman Hasil
      _ResultsScreen(
        answers: _answers,
        correctAnswer: correctAnswer, // Mengirim data jawaban benar
        onFinish: () => Navigator.of(context).pop(),
        onMakeAppointment: () { /* Logika buat janji temu */},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4DB9AC), Color(0xFF65D6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom App Bar
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
                      'Tes Buta Warna',
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
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET UNTUK HALAMAN INSTRUKSI
class _InstructionScreen extends StatelessWidget {
  final String imageAsset;
  final String text;
  final VoidCallback onNext;

  const _InstructionScreen({
    required this.imageAsset,
    required this.text,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAsset,
                  height: 220,
                  errorBuilder: (context, e, s) =>
                      const Icon(Icons.visibility_off, size: 100, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        // Tombol Selanjutnya
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DB9AC),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Selanjutnya", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

// WIDGET UNTUK HALAMAN PERTANYAAN
class _TestQuestionScreen extends StatelessWidget {
  final ValueChanged<String> onAnswered;
  final List<String> options;

  const _TestQuestionScreen({
    required this.onAnswered,
    required this.options,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/buta-warna.jpg',
                  height: 280,
                  errorBuilder: (context, e, s) => const Center(child: Text("Gambar tidak tersedia")),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Angka berapa yang anda lihat?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
         // Tombol Jawaban
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return ElevatedButton(
                  onPressed: () => onAnswered(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
        ),
      ],
    );
  }
}


// WIDGET UNTUK HALAMAN HASIL
// WIDGET UNTUK HALAMAN HASIL (DIPERBAIKI)
class _ResultsScreen extends StatelessWidget {
  final Map<String, String> answers;
  final VoidCallback onFinish;
  final VoidCallback onMakeAppointment;
  final String correctAnswer; // Menerima jawaban yang benar

  const _ResultsScreen({
    required this.answers,
    required this.onFinish,
    required this.onMakeAppointment,
    required this.correctAnswer, // Wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    final bool rightEyeCorrect = answers['kanan'] == correctAnswer;
    final bool leftEyeCorrect = answers['kiri'] == correctAnswer;
    final bool hasProblem = !rightEyeCorrect || !leftEyeCorrect;

    String resultText;
    if (hasProblem) {
      resultText = "Ada indikasi buta warna pada mata Anda. Disarankan untuk konsultasi lebih lanjut.";
    } else {
      resultText = "Hasil tes menunjukkan penglihatan warna Anda normal.";
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(
                    hasProblem ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                    size: 100,
                    color: hasProblem ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(height: 20),
                  const Text("Hasil Tes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    // PERBAIKAN: Mengganti .withOpacity() yang usang dengan .withAlpha()
                    decoration: BoxDecoration(
                      color: hasProblem 
                          ? Colors.orange.withAlpha(38) 
                          : const Color(0xFF4DB9AC).withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: hasProblem ? Colors.deepOrange : const Color(0xFF006A60),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "*Hasil tes ini tidak dapat menggantikan hasil pemeriksaan oleh dokter",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Area Tombol Bawah
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onMakeAppointment,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF4DB9AC)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Buat Janji Pertemuan", style: TextStyle(color: Color(0xFF4DB9AC), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB9AC),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}