// visual_acuity_test_page.dart (FINAL DENGAN FONT DIALOG DIPERBAIKI)

import 'dart:math';
import 'package:flutter/material.dart';

// Model untuk data pertanyaan tes
class VisualAcuityQuestion {
  final String correctLetter;
  final double fontSize;
  final List<String> options;

  VisualAcuityQuestion({
    required this.correctLetter,
    required this.fontSize,
  }) : options = _generateOptions(correctLetter);

  // Fungsi helper untuk membuat pilihan jawaban secara acak
  static List<String> _generateOptions(String correctLetter) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    List<String> options = [correctLetter];
    while (options.length < 4) {
      String randomLetter;
      do {
        randomLetter = letters[random.nextInt(letters.length)];
      } while (options.contains(randomLetter));
      options.add(randomLetter);
    }
    options.shuffle();
    return options;
  }
}

class VisualAcuityTestPage extends StatefulWidget {
  const VisualAcuityTestPage({super.key});

  @override
  State<VisualAcuityTestPage> createState() => _VisualAcuityTestPageState();
}

class _VisualAcuityTestPageState extends State<VisualAcuityTestPage> {
  final PageController _pageController = PageController();
  
  final List<VisualAcuityQuestion> _testQuestions = [
    VisualAcuityQuestion(correctLetter: 'E', fontSize: 12),
    VisualAcuityQuestion(correctLetter: 'R', fontSize: 12),
  ];

  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pages = _buildTestFlow();
  }
  
  // Fungsi untuk membangun seluruh alur halaman tes
  List<Widget> _buildTestFlow() {
    List<Widget> flow = [];
    
    flow.add(_InstructionScreen(
      imageAsset: 'assets/icons/mata-kiri.png',
      text: 'Tutup mata kiri Anda',
      onNext: _nextPage,
    ));

    for (var question in _testQuestions) {
      flow.add(_TestQuestionScreen(question: question, onNext: _nextPage));
    }
    
    flow.add(_InstructionScreen(
      imageAsset: 'assets/icons/mata-kanan.png',
      text: 'Tutup mata kanan Anda',
      onNext: _nextPage,
    ));
    
    for (var question in _testQuestions) {
      flow.add(_TestQuestionScreen(question: question, onNext: _nextPage));
    }

    flow.add(_ResultsScreen(
      onFinish: () {
          // --- PERUBAHAN FONT DIALOG DI SINI ---
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Tes mata berhasil disimpan',
                style: TextStyle(fontSize: 18.0), // Ukuran font diperkecil
              ),
              actions: [
                TextButton(
                  child: const Text('Selesai'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
      },
      onMakeAppointment: () { /* Logika buat janji temu */ },
    ));
    
    return flow;
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
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
                      'Visual Acuity',
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
                  errorBuilder: (context, e, s) => const Icon(Icons.visibility_off, size: 100, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        _buildNextButton(context, onNext),
      ],
    );
  }
}

// WIDGET UNTUK HALAMAN PERTANYAAN TES
class _TestQuestionScreen extends StatefulWidget {
  final VisualAcuityQuestion question;
  final VoidCallback onNext;

  const _TestQuestionScreen({required this.question, required this.onNext});

  @override
  State<_TestQuestionScreen> createState() => _TestQuestionScreenState();
}

class _TestQuestionScreenState extends State<_TestQuestionScreen> {
  String? _selectedOption;

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      widget.question.correctLetter,
                      style: TextStyle(
                        fontSize: widget.question.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Huruf apa yang kamu lihat?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.question.options.map((option) {
                    final isSelected = _selectedOption == option;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = option;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4DB9AC) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        _buildNextButton(context, widget.onNext, isEnabled: _selectedOption != null),
      ],
    );
  }
}

// WIDGET UNTUK HALAMAN HASIL
class _ResultsScreen extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback onMakeAppointment;

  const _ResultsScreen({required this.onFinish, required this.onMakeAppointment});

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    'assets/images/test_success.png',
                    height: 150,
                     errorBuilder: (context, e, s) => const Icon(Icons.task_alt, size: 100, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text("Hasil Tes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 10,
                        )
                      ]
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ResultItem(label: "Mata Kiri"),
                        _ResultItem(label: "Mata Kanan"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                     decoration: BoxDecoration(
                       color: const Color(0xFF4DB9AC).withOpacity(0.2),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: const Center(
                       child: Text(
                         "Hasil menunjukkan bahwa mata anda tidak bermasalah",
                         textAlign: TextAlign.center,
                         style: TextStyle(color: Color(0xFF006A60), fontWeight: FontWeight.w500),
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
                     elevation: 2,
                  ),
                  child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

// Widget kecil untuk item hasil (Mata Kiri/Kanan)
class _ResultItem extends StatelessWidget {
  final String label;
  const _ResultItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// Widget helper untuk tombol "Selanjutnya"
Widget _buildNextButton(BuildContext context, VoidCallback onPressed, {bool isEnabled = true}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4DB9AC),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        child: const Text(
          "Selanjutnya",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}