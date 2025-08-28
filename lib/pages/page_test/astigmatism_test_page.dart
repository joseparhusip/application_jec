// astigmatism_test_page.dart (KODE DENGAN GAMBAR DIPERBESAR)

import 'package:flutter/material.dart';

class AstigmatismTestPage extends StatefulWidget {
  const AstigmatismTestPage({super.key});

  @override
  State<AstigmatismTestPage> createState() => _AstigmatismTestPageState();
}

class _AstigmatismTestPageState extends State<AstigmatismTestPage> {
  final PageController _pageController = PageController();
  final Map<String, bool> _answers = {}; // Menyimpan jawaban (true untuk Ya, false untuk Tidak)

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

  void _saveAnswer(String eye, bool answer) {
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
        imageAsset: 'assets/icons/astigmatism1.png',
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
        imageAsset: 'assets/icons/astigmatism2.png',
        onAnswered: (answer) => _saveAnswer('kiri', answer),
      ),
      // 5. Halaman Hasil
      _ResultsScreen(
        answers: _answers,
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
                      'Astigmatism',
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

// WIDGET UNTUK HALAMAN PERTANYAAN TES ASTIGMATISM
class _TestQuestionScreen extends StatelessWidget {
  final String imageAsset;
  final ValueChanged<bool> onAnswered;

  const _TestQuestionScreen({
    required this.imageAsset,
    required this.onAnswered,
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
                // --- PERUBAHAN UKURAN GAMBAR DI SINI ---
                Image.asset(
                  imageAsset,
                  height: 300, // Diperbesar dari 250 menjadi 300
                  errorBuilder: (context, e, s) => Container(
                    height: 300, // Disesuaikan
                    width: 300,  // Disesuaikan
                    color: Colors.grey[200],
                    child: const Center(child: Text("Gambar tidak tersedia")),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Text(
                    "Apakah ada garis yang terlihat lebih gelap dari pada garis lainnya?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E6B65),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tombol Jawaban
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onAnswered(true), // Jawaban "Ya"
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF4DB9AC), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Ya", style: TextStyle(color: Color(0xFF4DB9AC), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onAnswered(false), // Jawaban "Tidak"
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF4DB9AC), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Tidak", style: TextStyle(color: Color(0xFF4DB9AC), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// WIDGET UNTUK HALAMAN HASIL
class _ResultsScreen extends StatelessWidget {
  final Map<String, bool> answers;
  final VoidCallback onFinish;
  final VoidCallback onMakeAppointment;

  const _ResultsScreen({
    required this.answers,
    required this.onFinish,
    required this.onMakeAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final bool rightEyeProblem = answers['kanan'] ?? false;
    final bool leftEyeProblem = answers['kiri'] ?? false;
    final bool hasProblem = rightEyeProblem || leftEyeProblem;

    String resultText;
    if (hasProblem) {
      resultText = "Ada indikasi astigmatisma pada mata Anda. Disarankan untuk konsultasi lebih lanjut.";
    } else {
      resultText = "Hasil menunjukkan bahwa mata Anda tidak memiliki indikasi astigmatisma.";
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
                    decoration: BoxDecoration(
                      color: hasProblem ? Colors.orange.withOpacity(0.15) : const Color(0xFF4DB9AC).withOpacity(0.2),
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