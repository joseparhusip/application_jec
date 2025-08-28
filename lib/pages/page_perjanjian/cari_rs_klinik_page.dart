// cari_rs_klinik_page.dart (UPDATED & REFACTORED)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'rs_detail_page.dart';
import 'package:application_jec_frontend/models/rs_klinik_models.dart'; // <-- [BARU] Impor model dari file terpisah

// [DIHAPUS] Definisi kelas RumahSakit dan Doctor dipindahkan ke models/rs_klinik_models.dart

class CariRsKlinikPage extends StatefulWidget {
  const CariRsKlinikPage({super.key});

  @override
  State<CariRsKlinikPage> createState() => _CariRsKlinikPageState();
}

class _CariRsKlinikPageState extends State<CariRsKlinikPage> {
  final TextEditingController _rsController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDateEnabled = false;

  final List<RumahSakit> _allRsList = [
    RumahSakit(
        name: 'JEC Bekasi',
        address: 'Jl. Raya Pekayon No.1, Bekasi',
        imagePath: 'assets/fasilitas/JEC-Bekasi.jpg',
        description: 'JEC Eye Hospitals and Clinics di Bekasi adalah pusat layanan kesehatan mata terkemuka yang menawarkan teknologi canggih dan dokter spesialis berpengalaman untuk menangani berbagai kelainan mata.',
        services: ['Katarak', 'LASIK', 'Retina', 'Glaukoma', 'Mata Anak'],
        doctors: [
          Doctor(name: 'Dr. Setiyo Budi, SpM(K)', specialist: 'Katarak & Bedah Refraktif', imagePath: 'assets/doctor/doc1.jpg'),
          Doctor(name: 'Dr. Waldensius Girsang, SpM(K)', specialist: 'Retina', imagePath: 'assets/doctor/doc2.jpg'),
        ],
        galleryImages: ['assets/gallery/jec1.jpg', 'assets/gallery/jec2.jpg', 'assets/gallery/jec3.jpg'],
        coordinates: {'lat': -6.255, 'lng': 106.993}
    ),
    RumahSakit(
        name: 'JEC Candi',
        address: 'Jl. Sultan Agung No.12, Semarang',
        imagePath: 'assets/fasilitas/JEC-Candi.jpg',
        description: 'Berlokasi di jantung kota Semarang, JEC Candi menyediakan layanan komprehensif untuk kesehatan mata dengan standar internasional dan fasilitas yang nyaman bagi pasien.',
        services: ['Operasi Katarak', 'Skrining Diabetes Retinopati', 'Bedah Plastik Mata'],
        doctors: [
          Doctor(name: 'Dr. Darwan M. Purba, SpM(K)', specialist: 'Glaukoma', imagePath: 'assets/doctor/doc3.jpg'),
          Doctor(name: 'Dr. Fifin L. Rahmi, SpM', specialist: 'Mata Anak & Strabismus', imagePath: 'assets/doctor/doc4.jpg'),
        ],
        galleryImages: ['assets/gallery/jec2.jpg', 'assets/gallery/jec3.jpg', 'assets/gallery/jec1.jpg'],
        coordinates: {'lat': -6.992, 'lng': 110.422}
    ),
    RumahSakit(
        name: 'JEC Kedoya',
        address: 'Jl. Terusan Arjuna Utara No.1, Jakarta Barat',
        imagePath: 'assets/fasilitas/JEC-Kedoya.jpg',
        description: 'Sebagai rumah sakit mata utama, JEC Kedoya menjadi rujukan nasional dengan layanan subspesialis terlengkap dan teknologi diagnostik serta bedah mata termutakhir di Indonesia.',
        services: ['LASIK & ReLEx SMILE', 'Katarak', 'Kornea', 'Glaukoma', 'Neuro-oftalmologi'],
        doctors: [
          Doctor(name: 'Dr. Johan A. Hutauruk, SpM(K)', specialist: 'Presiden Direktur', imagePath: 'assets/doctor/doc1.jpg'),
          Doctor(name: 'Dr. Nashrul Ihsan, SpM(K)', specialist: 'Kornea & Bedah Refraktif', imagePath: 'assets/doctor/doc2.jpg'),
        ],
        galleryImages: ['assets/gallery/jec3.jpg', 'assets/gallery/jec1.jpg', 'assets/gallery/jec2.jpg'],
        coordinates: {'lat': -6.179, 'lng': 106.772}
    ),
    RumahSakit(
        name: 'JEC Menteng',
        address: 'Jl. Cik Ditiro No.46, Jakarta Pusat',
        imagePath: 'assets/fasilitas/JEC-Menteng.jpg',
        description: 'JEC Menteng merupakan cikal bakal JEC Eye Hospitals and Clinics yang memiliki sejarah panjang dalam memberikan pelayanan kesehatan mata berkualitas di pusat Jakarta.',
        services: ['Pemeriksaan Mata Umum', 'Lensa Kontak', 'Low Vision Care'],
        doctors: [
          Doctor(name: 'Dr. Vidyapati Mangunkusumo, SpM(K)', specialist: 'Infeksi & Imunologi Mata', imagePath: 'assets/doctor/doc3.jpg'),
          Doctor(name: 'Dr. Elvioza, SpM(K)', specialist: 'Katarak', imagePath: 'assets/doctor/doc4.jpg'),
        ],
        galleryImages: ['assets/gallery/jec1.jpg', 'assets/gallery/jec3.jpg', 'assets/gallery/jec2.jpg'],
        coordinates: {'lat': -6.196, 'lng': 106.834}
    ),
  ];

  List<RumahSakit> _filteredRsList = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _filteredRsList = _allRsList;
    _rsController.addListener(() {
      _filterRsList();
      setState(() {
        _isDateEnabled = _rsController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _rsController.dispose();
    super.dispose();
  }

  void _filterRsList() {
    String query = _rsController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRsList = _allRsList;
      } else {
        _filteredRsList = _allRsList
            .where((rs) => rs.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_isDateEnabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
                      'Cari RS/Klinik',
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
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(26),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildTextField(
                              context,
                              "Ketik nama rumah sakit/klinik",
                              controller: _rsController,
                              hasSuffix: _rsController.text.isNotEmpty,
                            ),
                            const SizedBox(height: 15),
                            _buildDateField(context),
                            const SizedBox(height: 15),
                            _buildTextField(
                              context, "Ketik Nama Dokter (Optional)", hasSuffix: false),
                          ],
                        ),
                      ),
                      
                      Expanded(
                        child: _filteredRsList.isEmpty
                            ? _buildNotFoundWidget(context)
                            : _buildResultsList(),
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

  Widget _buildTextField(BuildContext context, String hint,
      {TextEditingController? controller, bool hasSuffix = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.onSurface.withAlpha(128)),
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withAlpha(153)),
        suffixIcon: hasSuffix
            ? IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface.withAlpha(153)),
                onPressed: () {
                  controller?.clear();
                },
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      ),
      style: TextStyle(color: colorScheme.onSurface),
    );
  }

  Widget _buildDateField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String formattedDate = DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate!);

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: _isDateEnabled
              ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: _isDateEnabled ? colorScheme.onSurface.withAlpha(153) : Colors.grey,
                    size: 20),
                const SizedBox(width: 10),
                Text(
                  _isDateEnabled ? formattedDate : 'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDateEnabled ? colorScheme.onSurface : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, color: _isDateEnabled ? colorScheme.onSurface.withAlpha(153) : Colors.grey),
          ],
        ),
      ),
    );
  }

Widget _buildResultsList() {
  return GridView.builder(
    padding: const EdgeInsets.all(20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.75,
    ),
    itemCount: _filteredRsList.length,
    itemBuilder: (context, index) {
      final rs = _filteredRsList[index];
      return _buildRsListItem(context, rs);
    },
  );
}

Widget _buildRsListItem(BuildContext context, RumahSakit rs) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return LayoutBuilder(
    builder: (context, constraints) {
      final double baseFontSize = constraints.maxWidth / 12;

      return Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(
                rs.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.local_hospital, size: 50, color: Colors.grey);
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rs.name,
                          style: TextStyle(
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rs.address,
                          style: TextStyle(
                            fontSize: baseFontSize * 0.8,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () { /* TODO: Tambahkan aksi ke peta */ },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.location_on_outlined, color: colorScheme.primary, size: baseFontSize * 1.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RsDetailPage(rs: rs),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38A1C1), 
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Lihat Detail',
                              style: TextStyle(
                                fontSize: baseFontSize * 0.9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildNotFoundWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: colorScheme.onSurface.withAlpha(102)),
          const SizedBox(height: 10),
          Text(
            'Pencarian tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withAlpha(179),
            ),
          ),
          Text(
            'Masukkan kata kunci lain',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}