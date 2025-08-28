// lib/page_menu/asuransi_page.dart (KODE FINAL LENGKAP DENGAN CARD DAN BUTTON)

import 'package:flutter/material.dart';
import 'package:application_jec_frontend/models/hospital_models.dart';

class AsuransiPage extends StatefulWidget {
  const AsuransiPage({super.key});

  @override
  State<AsuransiPage> createState() => _AsuransiPageState();
}

class _AsuransiPageState extends State<AsuransiPage> {
  // State untuk melacak filter yang aktif
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  List<Hospital> _filteredHospitals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  // Fungsi untuk memuat dan memfilter data hospital
  void _loadHospitals() {
    List<Hospital> hospitals = HospitalData.getAllHospitals();
    
    // Filter berdasarkan tipe
    if (_selectedFilter != 'Semua') {
      hospitals = hospitals.where((hospital) => hospital.type == _selectedFilter).toList();
    }
    
    // Filter berdasarkan search query
    if (_searchQuery.isNotEmpty) {
      hospitals = hospitals
          .where((hospital) =>
              hospital.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              hospital.address.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredHospitals = hospitals;
    });
  }

  // Fungsi untuk mengubah filter saat chip diklik
  void _runFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadHospitals();
  }

  // Fungsi untuk search
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadHospitals();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        // Latar belakang header yang bisa beradaptasi dengan mode gelap/terang
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
                    Expanded(
                      child: Text(
                        'Asuransi Rumah Sakit / Klinik',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      // Kartu Pencarian dan Filter
                      _buildSearchAndFilterCard(context),

                      // Daftar Hospital/Klinik
                      Expanded(
                        child: _filteredHospitals.isEmpty
                            ? _buildEmptyState(context)
                            : _buildHospitalList(context),
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

  // Widget untuk kartu pencarian dan filter
  Widget _buildSearchAndFilterCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari Rumah Sakit / Klinik',
              hintStyle:
                  TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
              prefixIcon:
                  Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.5)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: colorScheme.onSurface.withOpacity(0.5)),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            ),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),

          // Baris Filter yang sudah diperbaiki
          Row(
            children: [
              Expanded(
                child: _FilterChip(
                  label: 'Tampilkan Semua',
                  isSelected: _selectedFilter == 'Semua',
                  onTap: () => _runFilter('Semua'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterChip(
                  label: 'Rumah Sakit',
                  isSelected: _selectedFilter == 'RS',
                  onTap: () => _runFilter('RS'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterChip(
                  label: 'Klinik',
                  isSelected: _selectedFilter == 'Klinik',
                  onTap: () => _runFilter('Klinik'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget untuk daftar hospital
  Widget _buildHospitalList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = _filteredHospitals[index];
        return _buildHospitalCard(context, hospital);
      },
    );
  }

  // Widget untuk card hospital individual
  Widget _buildHospitalCard(BuildContext context, Hospital hospital) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Header
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: Image.asset(
                    hospital.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hospital.type == 'RS' ? Icons.local_hospital : Icons.medical_services,
                              size: 48,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Foto ${hospital.type}',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Badge Status
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hospital.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hospital.isOpen ? 'Buka' : 'Tutup',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Badge Tipe
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hospital.type == 'RS' ? colorScheme.primary : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hospital.type,
                      style: TextStyle(
                        color: hospital.type == 'RS' ? colorScheme.onPrimary : colorScheme.onSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Konten Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama dan Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        hospital.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          hospital.rating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Alamat
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      hospital.distance,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Jam Operasional
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      hospital.operatingHours,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Fasilitas
                if (hospital.facilities.isNotEmpty) ...[
                  Text(
                    'Fasilitas:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: hospital.facilities.take(4).map((facility) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          facility,
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (hospital.facilities.length > 4) ...[
                    const SizedBox(height: 4),
                    Text(
                      '+${hospital.facilities.length - 4} fasilitas lainnya',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
                
                // Button Actions
                Row(
                  children: [
                    // Button Telepon
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showContactDialog(context, hospital);
                        },
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Telepon'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Button Lihat Asuransi
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showInsuranceDialog(context, hospital);
                        },
                        icon: const Icon(Icons.shield, size: 16),
                        label: const Text('Lihat Asuransi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk empty state
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Tidak ada hasil untuk "$_searchQuery"'
                : 'Tidak ada data ${_selectedFilter == 'Semua' ? '' : _selectedFilter}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withOpacity(0.6)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci pencarian atau filter',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.4)
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk menampilkan info kontak
  void _showContactDialog(BuildContext context, Hospital hospital) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kontak ${hospital.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(hospital.phone)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(hospital.address)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Di sini bisa ditambahkan fungsi untuk membuka dialer telepon
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menghubungi ${hospital.phone}')),
                );
              },
              child: const Text('Hubungi'),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk menampilkan daftar asuransi
  void _showInsuranceDialog(BuildContext context, Hospital hospital) {
    final insuranceList = [
      'BPJS Kesehatan',
      'Prudential',
      'Allianz',
      'AXA Mandiri',
      'Great Eastern',
      'Sinarmas MSIG',
      'Cigna',
      'Manulife',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Asuransi yang Diterima\n${hospital.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: insuranceList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(insuranceList[index]),
                  dense: true,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

// Widget Kustom untuk Filter Chip yang sudah diperkecil
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
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
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}