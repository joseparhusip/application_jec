// lib/page_menu/bonus_page.dart (WARNA BARU)

import 'package:flutter/material.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({super.key});

  @override
  State<BonusPage> createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  // State untuk melacak hari check-in, 0 berarti belum ada yang di-claim
  int _lastCheckedInDay = 0;

  void _performCheckIn() {
    // Logika sederhana: hanya bisa check-in satu kali per hari secara berurutan
    if (_lastCheckedInDay < 7) {
      setState(() {
        _lastCheckedInDay++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anda berhasil check-in untuk Hari ke-$_lastCheckedInDay!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda sudah menyelesaikan check-in mingguan!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Mengatur agar body bisa berada di belakang AppBar
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderCard(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildCheckInSection(context),
                  const SizedBox(height: 30),
                  _buildCheckInButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        // --- PERUBAHAN DI SINI ---
        gradient: LinearGradient(
          colors: [colorScheme.primary, Colors.blueAccent], // Menggunakan warna primer tema
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.yellow, size: 24),
                SizedBox(width: 8),
                Text('0', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Use points to redeem Deals? Check now',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInSection(BuildContext context) {
    final List<Map<String, dynamic>> dailyRewards = [
      {'points': 5, 'isSpecial': false},
      {'points': 10, 'isSpecial': false},
      {'points': 15, 'isSpecial': false},
      {'points': 20, 'isSpecial': false},
      {'points': 25, 'isSpecial': false},
      {'points': 50, 'isSpecial': false},
      {'points': 200, 'isSpecial': true},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        int day = index + 1;
        return Expanded(
          child: _buildDayItem(
            context,
            day: day,
            points: dailyRewards[index]['points'],
            isSpecial: dailyRewards[index]['isSpecial'],
            isCheckedIn: day <= _lastCheckedInDay,
          ),
        );
      }),
    );
  }

  Widget _buildDayItem(BuildContext context, {required int day, required int points, required bool isSpecial, required bool isCheckedIn}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSpecial ? Colors.yellow.withOpacity(0.2) : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          )
        ],
      ),
      child: Opacity(
        // Buat item terlihat redup jika sudah di-check-in
        opacity: isCheckedIn ? 0.5 : 1.0,
        child: Column(
          children: [
            Text(
              'Day $day',
              style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
            isSpecial
                ? Icon(Icons.card_giftcard, color: Colors.yellow.shade700, size: 30)
                // --- PERUBAHAN DI SINI ---
                : Icon(Icons.monetization_on, color: isDarkMode ? Colors.yellow : colorScheme.primary, size: 30),
            const SizedBox(height: 8),
            Text(
              '+$points',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _performCheckIn,
        style: ElevatedButton.styleFrom(
          // --- PERUBAHAN DI SINI ---
          backgroundColor: colorScheme.primary, // Menggunakan warna primer tema
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Check in',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}