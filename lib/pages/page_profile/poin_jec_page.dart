import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PoinJecPage extends StatelessWidget {
  const PoinJecPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Latar belakang dengan gradien seperti pada halaman profil
      backgroundColor: colorScheme.primary.withOpacity(0.9),
      appBar: AppBar(
        // AppBar transparan agar menyatu dengan latar belakang
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Kustomisasi ikon kembali agar kontras
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profil Lengkap',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Menyesuaikan warna ikon sistem di status bar
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Area atas yang menampilkan gradien
            const SizedBox(height: 20),
            // Konten utama dengan latar belakang putih dan sudut melengkung
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor, // Menggunakan warna latar scaffold
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // --- KARTU PROFIL PENGGUNA ---
                      _buildProfileCard(context),
                      const SizedBox(height: 20),
                      // --- KARTU MEMBER & POIN ---
                      _buildMemberCard(context),
                      const SizedBox(height: 20),
                      // --- KARTU KODE REFERENSI ---
                      _buildReferenceCodeCard(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu profil
  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(Icons.person, color: colorScheme.onPrimaryContainer, size: 30),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jose Elio Parhusip',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Bergabung sejak',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk kartu status member dan poin
  Widget _buildMemberCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.grey.shade400, size: 30),
              const SizedBox(width: 10),
              Text('Silver Member', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('0 Poin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text('500 Points lagi untuk naik ke', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          // --- PROGRESS BAR TINGKATAN MEMBER ---
          _buildTierProgressBar(),
          const SizedBox(height: 25),
          Text('Keuntungan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // --- DAFTAR KEUNTUNGAN ---
          _buildBenefitItem('1. Penukaran Points JEC'),
          _buildBenefitItem('2. Hadiah Ulang tahun JEC'),
          _buildBenefitItem('3. Voucher gratis konsultasi'),
        ],
      ),
    );
  }

  // Widget untuk progress bar tingkatan member
  Widget _buildTierProgressBar() {
    return Column(
      children: [
        Stack(
          children: [
            // Garis progres utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LinearProgressIndicator(
                value: 0.0, // 0 Poin dari 500 Poin untuk ke Gold
                backgroundColor: Colors.grey.shade300,
                color: Colors.orange,
                minHeight: 6,
              ),
            ),
            // Lingkaran penanda tingkatan
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TierMarker(isActive: true),
                _TierMarker(isActive: false),
                _TierMarker(isActive: false),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Label untuk setiap tingkatan
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TierLabel(points: '0 Poin', level: 'Silver'),
            _TierLabel(points: '500 Poin', level: 'Gold'),
            _TierLabel(points: '1200 Poin', level: 'Platinum'),
          ],
        ),
      ],
    );
  }

  // Widget untuk item keuntungan
  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(text, style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  // Widget untuk kartu kode referensi
  Widget _buildReferenceCodeCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.confirmation_number, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode Referensi Anda', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                'JEC-10525B',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.primary),
            onPressed: () {
              // Fungsi untuk berbagi kode
            },
          ),
        ],
      ),
    );
  }
}

// Widget kustom untuk penanda tingkatan (lingkaran)
class _TierMarker extends StatelessWidget {
  final bool isActive;
  const _TierMarker({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.orange : Colors.grey.shade300,
        border: Border.all(color: Colors.white, width: 3),
      ),
    );
  }
}

// Widget kustom untuk label tingkatan (poin dan nama)
class _TierLabel extends StatelessWidget {
  final String points;
  final String level;
  const _TierLabel({required this.points, required this.level});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(points, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(level, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}