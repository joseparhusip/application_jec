// lib/pages/fasilitas_page.dart (KODE LENGKAP & DIPERBARUI)

import 'package:flutter/material.dart';
// --- PERUBAHAN: Import model yang sudah dipisah dengan nama file baru ---
import 'package:application_jec_frontend/models/facility_models.dart';

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  State<FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  static const List<Facility> _allFacilities = [
    Facility(name: 'RS Mata JEC @ Menteng', imagePath: 'assets/fasilitas/JEC-Menteng.jpg', type: FacilityType.rs),
    Facility(name: 'RS Mata JEC @ Kedoya', imagePath: 'assets/fasilitas/JEC-Kedoya.jpg', type: FacilityType.rs),
    Facility(name: 'RS Mata JEC PRIMASANA @ Tj. Priok', imagePath: 'assets/fasilitas/JEC-Primasana.jpg', type: FacilityType.rs),
    Facility(name: 'RS Mata JEC CANDI @ Semarang', imagePath: 'assets/fasilitas/JEC-Candi.jpg', type: FacilityType.rs),
    Facility(name: 'Klinik Utama Mata JEC @ Tambora', imagePath: 'assets/fasilitas/JEC-Tambora.jpg', type: FacilityType.klinik),
    Facility(name: 'Klinik Utama Mata JEC @ Bekasi', imagePath: 'assets/fasilitas/JEC-Bekasi.jpg', type: FacilityType.klinik),
  ];

  late List<Facility> _filteredFacilities;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredFacilities = _allFacilities;
  }

  void _runFilter(String filter) {
    List<Facility> results;
    if (filter == 'RS') {
      results = _allFacilities.where((f) => f.type == FacilityType.rs).toList();
    } else if (filter == 'Klinik') {
      results = _allFacilities.where((f) => f.type == FacilityType.klinik).toList();
    } else {
      results = _allFacilities;
    }
    setState(() {
      _selectedFilter = filter;
      _filteredFacilities = results;
    });
  }

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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withOpacity(0.8),
                    Colors.grey.shade100,
                  ],
                  stops: const [0.0, 0.25],
                ),
              ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildSearchAndFilter(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _filteredFacilities.length,
                  itemBuilder: (context, index) {
                    return _FacilityCard(facility: _filteredFacilities[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const Text(
            'Fasilitas Rumah Sakit / Klinik',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari Rumah Sakit / Klinik',
              hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
              prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.5)),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FilterChip(
                label: 'Tampilkan Semua',
                isSelected: _selectedFilter == 'Semua',
                onTap: () => _runFilter('Semua'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Rumah Sakit',
                isSelected: _selectedFilter == 'RS',
                onTap: () => _runFilter('RS'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Klinik',
                isSelected: _selectedFilter == 'Klinik',
                onTap: () => _runFilter('Klinik'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final Facility facility;
  const _FacilityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              facility.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                    child: Icon(Icons.business_rounded,
                        size: 50, color: Colors.grey.shade400));
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    facility.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      height: 1.3,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, Colors.blueAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          'Lihat Fasilitas',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}