// cari_dokter_page.dart (UPDATED & REFACTORED)

import 'package:flutter/material.dart';
import 'buat_janji_page.dart';
import 'jadwal_page.dart';
import 'package:application_jec_frontend/models/doctor_models.dart';

class CariDokterPage extends StatefulWidget {
  const CariDokterPage({super.key});

  @override
  State<CariDokterPage> createState() => _CariDokterPageState();
}

class _CariDokterPageState extends State<CariDokterPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> _filteredPopularDoctors = []; // <-- Gunakan tipe data Doctor

  final List<Map<String, String>> liveDoctors = [
    {"image": "assets/docter/Dr. Andhika Guna Dharma, SpM(K).jpg"},
    {"image": "assets/docter/Dr Afrisal Hari Kurniawan, SpM(K).jpg"},
    {"image": "assets/docter/Prof. DR. Dr Winarto, Sp.MK, SpM(K).jpg"},
  ];

  // --- Gunakan Doctor Model untuk List Dokter ---
  final List<Doctor> popularDoctors = [
    Doctor(
      name: "Prof. DR. Dr Winarto, Sp.MK, SpM(K)",
      specialty: "Cataract, Ocular Infection & Immunology",
      image: "assets/docter/Prof. DR. Dr Winarto, Sp.MK, SpM(K).jpg",
    ),
    Doctor(
      name: "Dr. A. Kentar Arimadyo Sulakso, MSi. Med., SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr A. Kentar Arimadyo Sulakso, MSi. Med., SpM(K).jpg",
    ),
    Doctor(
      name: "Dr. Afrisal Hari Kurniawan, SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr Afrisal Hari Kurniawan, SpM(K).jpg",
    ),
    Doctor(
      name: "dr. A. Rizal Fanany, Spm(k)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/dr. A. Rizal Fanany, Spm(k).jpg",
    ),
    Doctor(
      name: "Dr. Andhika Guna Dharma, SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr. Andhika Guna Dharma, SpM(K).jpg",
    ),
    Doctor(
      name: "Dr. Arnila Novitasari Saubig, SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr. Arnila Novitasari Saubig, SpM(K).jpg",
    ),
    Doctor(
      name: "Dr. dr. Trilaksana Nugroho, FISCM, M.Kes, SpMK",
      specialty: "Spesialis Mikrobiologi Klinik",
      image: "assets/docter/Dr. dr. trilaksana nugroho, fiscm, m.kes, spmk.jpg",
    ),
    Doctor(
      name: "Dr. Fatimah Dyah Nur Astuti, MARS, SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr. Fatimah Dyah Nur Astuti, MARS, SpM(K).jpg",
    ),
    Doctor(
      name: "Dr. Sri Inakawati, MSi.Med., SpM(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr. Sri Inakawati, MSi.Med., SpM(K).jpg",
    ),
    Doctor(
      name: "Dr.dr. Fifin Luthfia Rahmi, MS, Sp.M(K)",
      specialty: "Spesialis Mata Konsultan",
      image: "assets/docter/Dr.dr. Fifin Luthfia Rahmi, MS, Sp.M(K).jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredPopularDoctors = popularDoctors;
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDoctors);
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPopularDoctors = popularDoctors.where((doctor) {
        // <-- Akses properti .name
        final doctorName = doctor.name.toLowerCase();
        return doctorName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    const double headerHeight = 180.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: headerHeight - kToolbarHeight,
            pinned: true,
            backgroundColor: isDarkMode ? Colors.grey.shade900 : colorScheme.primary,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              centerTitle: false,
              title: const Text(
                'Find Your Doctor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              background: Container(
                 decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withAlpha(230),
                            colorScheme.primary,
                          ],
                        ),
                  color: isDarkMode ? Colors.grey.shade900 : null,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildContent(context),
                Positioned(
                  top: -35,
                  left: 20,
                  right: 20,
                  child: _buildSearchBar(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Live Doctors'),
            _buildLiveDoctorsList(),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Popular Doctor'),
            _buildPopularDoctorsList(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari nama dokter...',
          hintStyle: TextStyle(color: colorScheme.onSurface.withAlpha(128)),
          prefixIcon:
              Icon(Icons.search, color: colorScheme.onSurface.withAlpha(153)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close,
                      color: colorScheme.onSurface.withAlpha(153)),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            'See all >',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDoctorsList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: liveDoctors.length,
        padding: const EdgeInsets.only(left: 20),
        itemBuilder: (context, index) {
          return _buildLiveDoctorCard(
            context,
            liveDoctors[index]['image']!,
          );
        },
      ),
    );
  }

  Widget _buildLiveDoctorCard(BuildContext context, String imageUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          const Center(
            child: CircleAvatar(
              backgroundColor: Colors.white54,
              radius: 20,
              child: Icon(Icons.play_arrow, color: Colors.white, size: 28),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDoctorsList(BuildContext context) {
    if (_filteredPopularDoctors.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'Dokter tidak ditemukan',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.55,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredPopularDoctors.length,
        itemBuilder: (context, index) {
          final doctor = _filteredPopularDoctors[index];
          return _buildPopularDoctorCard(
            context,
            doctor,
          );
        },
      ),
    );
  }
  
  // --- Terima objek Doctor, bukan Map ---
  Widget _buildPopularDoctorCard(BuildContext context, Doctor doctor) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                color: Colors.grey.shade100,
                // <-- Akses properti .image
                child: Image.asset(
                  doctor.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person,
                        size: 40, color: Colors.grey);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // <-- Akses properti .name
                    doctor.name,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // <-- Akses properti .specialty
                    doctor.specialty,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuatJanjiPage(
                          // <-- Kirim data dari objek doctor
                          doctorName: doctor.name,
                          doctorSpecialty: doctor.specialty,
                          doctorImage: doctor.image,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child:
                      const Text('Buat Janji', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 5),
                OutlinedButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JadwalPage(
                          // <-- Kirim data dari objek doctor
                          doctorName: doctor.name,
                          doctorSpecialty: doctor.specialty,
                          doctorImage: doctor.image,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Jadwal',
                      style: TextStyle(fontSize: 12, color: colorScheme.primary)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}