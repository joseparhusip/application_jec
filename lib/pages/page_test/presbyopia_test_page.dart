// presbyopia_test_page.dart (KODE DENGAN GAMBAR DIPERBESAR)

import 'package:flutter/material.dart';

class PresbyopiaTestPage extends StatefulWidget {
  const PresbyopiaTestPage({super.key});

  @override
  State<PresbyopiaTestPage> createState() => _PresbyopiaTestPageState();
}

class _PresbyopiaTestPageState extends State<PresbyopiaTestPage> {
  final PageController _pageController = PageController();
  bool? _canReadClearly; // Menyimpan jawaban (true untuk Ya, false untuk Tidak)

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

  void _saveAnswer(bool answer) {
    setState(() {
      _canReadClearly = answer;
    });
    _nextPage();
  }

  List<Widget> _buildTestFlow() {
    return [
      // 1. Halaman Instruksi
      _InstructionScreen(
        onNext: _nextPage,
      ),
      // 2. Halaman Tes
      _TestQuestionScreen(
        onAnswered: _saveAnswer,
      ),
      // 3. Halaman Hasil
      _ResultsScreen(
        canReadClearly: _canReadClearly,
        onFinish: () => Navigator.of(context).pop(),
        onMakeAppointment: () { /* Logika buat janji temu */ },
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
                      'Presbyopia',
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
                    // Update halaman hasil saat halaman tersebut akan ditampilkan
                    if (index == _pages.length - 1) {
                      return _ResultsScreen(
                        canReadClearly: _canReadClearly,
                        onFinish: () => Navigator.of(context).pop(),
                        onMakeAppointment: () {},
                      );
                    }
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


class _InstructionScreen extends StatelessWidget {
  final VoidCallback onNext;

  const _InstructionScreen({required this.onNext});

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
                // --- PERUBAHAN UKURAN GAMBAR DI SINI ---
                Image.asset(
                  'assets/icons/kedua-mata.png',
                  height: 220, // Diperbesar dari 150 menjadi 220
                  errorBuilder: (context, e, s) =>
                      const Icon(Icons.people_alt_outlined, size: 100, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                const Text("Gunakan kedua mata anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
              child: const Text("Selanjutnya",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

// WIDGET UNTUK HALAMAN PERTANYAAN TES PRESBYOPIA
class _TestQuestionScreen extends StatelessWidget {
  final ValueChanged<bool> onAnswered;

  const _TestQuestionScreen({required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: const EdgeInsets.all(32.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/presbyopia1.png',
                  height: 250,
                  errorBuilder: (context, e, s) => const SizedBox(
                    height: 250,
                    child: Center(child: Text("Gambar tes tidak tersedia")),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Apakah kamu bisa membacanya dengan jelas?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E6B65),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Ya",
                      style: TextStyle(
                          color: Color(0xFF4DB9AC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onAnswered(false), // Jawaban "Tidak"
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF4DB9AC), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Tidak",
                      style: TextStyle(
                          color: Color(0xFF4DB9AC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
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
  final bool? canReadClearly;
  final VoidCallback onFinish;
  final VoidCallback onMakeAppointment;

  const _ResultsScreen({
    required this.canReadClearly,
    required this.onFinish,
    required this.onMakeAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasProblem = !(canReadClearly ?? true);

    String resultText;
    if (hasProblem) {
      resultText = "Ada indikasi presbyopia pada mata Anda. Disarankan untuk konsultasi lebih lanjut.";
    } else {
      resultText = "Hasil menunjukkan bahwa mata Anda tidak memiliki indikasi presbyopia.";
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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