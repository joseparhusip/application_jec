import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Sesuaikan path jika Anda meletakkan file di folder yang berbeda
import 'package:application_jec_frontend/models/appointment_models.dart';
import 'package:application_jec_frontend/dummy-data/dummy_data.dart';

class LasikPage extends StatefulWidget {
  const LasikPage({super.key});

  @override
  State<LasikPage> createState() => _LasikPageState();
}

class _LasikPageState extends State<LasikPage> {
  final TextEditingController _rsController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDateEnabled = false;

  final TextEditingController _doctorSearchController = TextEditingController();
  Hospital? _selectedHospital;
  Doctor? _selectedDoctor;
  List<Doctor> _availableDoctors = [];
  List<Doctor> _filteredDoctors = [];

  final List<String> _hospitalNames = hospitalsData.map((h) => h.name).toList();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _rsController.addListener(() {
      setState(() {
        _isDateEnabled = _rsController.text.isNotEmpty;
      });
    });
    _doctorSearchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _rsController.dispose();
    _doctorSearchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    final query = _doctorSearchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _availableDoctors.where((doctor) {
        final doctorName = doctor.name.toLowerCase();
        return doctorName.contains(query);
      }).toList();
    });
  }

  // --- KALENDER DENGAN UI PROFESIONAL ---
  Future<void> _selectDate(BuildContext context) async {
    if (!_isDateEnabled) return;

    final colorScheme = Theme.of(context).colorScheme;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: const Locale('id', 'ID'), // Mengatur bahasa ke Indonesia
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF1D2A39), // Warna teks utama
            ),
            // PERBAIKAN: Menggunakan DialogTheme, bukan DialogThemeData
            dialogTheme: DialogThemeData( 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: colorScheme.primary,
              headerForegroundColor: Colors.white,
              headerHelpStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              headerHeadlineStyle: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              // FIX: Menggunakan WidgetStateProperty
              yearOverlayColor: WidgetStateProperty.all(colorScheme.primary.withAlpha(26)),
              weekdayStyle: TextStyle(
                color: Colors.black.withAlpha(150),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              // FIX: Menggunakan WidgetStateProperty
              todayBackgroundColor: WidgetStateProperty.all(Colors.grey.shade200),
              // FIX: Menggunakan WidgetStateProperty
              todayForegroundColor: WidgetStateProperty.all(colorScheme.primary),
              todayBorder: BorderSide(color: Colors.grey.shade300),
              // FIX: Menggunakan WidgetStateProperty
              dayOverlayColor: WidgetStateProperty.all(colorScheme.primary.withAlpha(26)),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onHospitalSelected(String hospitalName) {
    setState(() {
      _rsController.text = hospitalName;
      _selectedHospital =
          hospitalsData.firstWhere((h) => h.name == hospitalName);
      _availableDoctors = _selectedHospital!.doctors;
      _filteredDoctors = _availableDoctors;
      _doctorSearchController.clear();
      _selectedDoctor = null;
    });
  }

  void _showHospitalSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: HospitalSearchDialog(
          hospitals: _hospitalNames,
          onHospitalSelected: _onHospitalSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final double appBarHeight = MediaQuery.of(context).padding.top + 60;
    final double searchFormHeight = _selectedHospital == null ? 170 : 250;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            _buildHeader(isDarkMode, colorScheme),
            SafeArea(
              child: ClipRect(
                child: Column(
                  children: [
                    SizedBox(height: searchFormHeight + 80),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: _selectedHospital == null
                            ? _buildEmptyState(colorScheme)
                            : _buildDoctorList(context, colorScheme),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildAppBar(context),
              ),
            ),
            Positioned(
              top: appBarHeight + 20,
              left: 20,
              right: 20,
              child: _buildSearchForm(context, colorScheme),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: _buildSearchButton(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, ColorScheme colorScheme) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: isDarkMode
          ? const BoxDecoration(color: Colors.black)
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withAlpha(204),
                  colorScheme.primary,
                ],
              ),
            ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(102),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              'assets/icons/iconsmenu/lasik.svg',
              width: 24,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'LASIK',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHospitalSearchField(context, colorScheme),
          const SizedBox(height: 20),
          _buildDateField(context, colorScheme),
          if (_selectedHospital != null) ...[
            const SizedBox(height: 20),
            _buildDoctorSearchField(context, colorScheme),
          ]
        ],
      ),
    );
  }

  Widget _buildDoctorSearchField(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: TextField(
        controller: _doctorSearchController,
        decoration: InputDecoration(
          hintText: 'Cari nama dokter (opsional)',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: colorScheme.primary, size: 20),
          suffixIcon: _doctorSearchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: Colors.grey.shade500, size: 20),
                  onPressed: () {
                    _doctorSearchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Container();
  }

  Widget _buildDoctorList(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filteredDoctors.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Dokter tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba dengan kata kunci lain',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: _filteredDoctors.map((doctor) {
                    final isSelected = _selectedDoctor == doctor;
                    return _buildDoctorCard(doctor, isSelected, context);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, bool isSelected, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDoctor = null;
              } else {
                _selectedDoctor = doctor;
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withAlpha(13)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      doctor.imagePath,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.grey, size: 32),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name.split(',').first,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalSearchField(
      BuildContext context, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _showHospitalSearchDialog,
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: TextField(
            controller: _rsController,
            decoration: InputDecoration(
              hintText: 'Cari rumah sakit atau klinik',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              prefixIcon: Icon(Icons.search, color: colorScheme.primary, size: 20),
              suffixIcon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600, size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, ColorScheme colorScheme) {
    final String formattedDate = _selectedDate != null
        ? DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDate!)
        : 'Pilih tanggal';

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              _isDateEnabled ? const Color(0xFFF8F9FA) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _isDateEnabled
                ? const Color(0xFFE9ECEF)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: _isDateEnabled ? colorScheme.primary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isDateEnabled ? formattedDate : 'Pilih tanggal konsultasi',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      _isDateEnabled ? Colors.black : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: _isDateEnabled
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context, ColorScheme colorScheme) {
    final hasData = _rsController.text.isNotEmpty && _isDateEnabled;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasData
            ? () {
                final doctorInfo = _selectedDoctor != null
                    ? ' dengan ${_selectedDoctor!.name.split(',').first}'
                    : '';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Mencari layanan LASIK di ${_rsController.text}$doctorInfo'),
                    backgroundColor: colorScheme.primary,
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              hasData ? colorScheme.primary : Colors.grey.shade300,
          foregroundColor: hasData ? Colors.white : Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: hasData ? 6 : 0,
          shadowColor: hasData 
              ? colorScheme.primary.withAlpha(77) 
              : null,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 22),
            SizedBox(width: 10),
            Text(
              'Cari Layanan LASIK',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class HospitalSearchDialog extends StatefulWidget {
  final List<String> hospitals;
  final Function(String) onHospitalSelected;

  const HospitalSearchDialog({
    super.key,
    required this.hospitals,
    required this.onHospitalSelected,
  });

  @override
  State<HospitalSearchDialog> createState() => _HospitalSearchDialogState();
}

class _HospitalSearchDialogState extends State<HospitalSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _filteredHospitals = widget.hospitals;
    _searchController.addListener(_filterHospitals);
  }

  void _filterHospitals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHospitals = widget.hospitals;
      } else {
        _filteredHospitals = widget.hospitals
            .where((hospital) => hospital.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Rumah Sakit',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Cari dan pilih rumah sakit mata',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close,
                      color: Color(0xFF4B5563), size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari rumah sakit...',
                  hintStyle:
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search, color: colorScheme.primary, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredHospitals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text('Tidak ada hasil',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4B5563))),
                        const Text('Coba kata kunci lain',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF6B7280))),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = _filteredHospitals[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: hospital,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'sans-serif'),
                                ),
                                const TextSpan(
                                    text: ' ㆍ ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                        fontSize: 13)),
                                TextSpan(
                                  text: hospital.startsWith('KUM')
                                      ? 'clinic'
                                      : 'hospital',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF1E3A8A),
                                      fontSize: 13,
                                      fontFamily: 'sans-serif'),
                                ),
                              ],
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 12, color: Colors.grey.shade400),
                          onTap: () {
                            widget.onHospitalSelected(hospital);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}