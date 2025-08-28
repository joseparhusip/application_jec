// cari_layanan_page.dart (KODE BARU)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CariLayananPage extends StatefulWidget {
  const CariLayananPage({super.key});

  @override
  State<CariLayananPage> createState() => _CariLayananPageState();
}

class _CariLayananPageState extends State<CariLayananPage> {
  // State untuk mengelola input text dan tanggal
  final TextEditingController _layananController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDateEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Listener untuk mendeteksi perubahan pada text field nama layanan
    _layananController.addListener(() {
      setState(() {
        // Aktifkan field tanggal jika ada teks
        _isDateEnabled = _layananController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _layananController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan date picker
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: isDarkMode ? Colors.white : colorScheme.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Cari Layanan',
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
                              "Ketik Nama Layanan",
                              controller: _layananController, // Gunakan controller
                              hasSuffix: false,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                                context, "Ketik Nama Rumah Sakit/Klinik",
                                hasSuffix: true),
                            const SizedBox(height: 15),
                            _buildDateField(context),
                            const SizedBox(height: 15),
                            _buildTextField(
                                context, "Ketik Nama Dokter (Optional)",
                                hasSuffix: false),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.search,
                          size: 80, color: colorScheme.onSurface.withAlpha(102)),
                      const SizedBox(height: 10),
                      Text(
                        'Pencarian tidak ditemukan',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withAlpha(179)),
                      ),
                      Text(
                        'Masukkan kata kunci lain',
                        style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withAlpha(128)),
                      ),
                      const Spacer(flex: 2),
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
        prefixIcon:
            Icon(Icons.search, color: colorScheme.onSurface.withAlpha(153)),
        suffixIcon: hasSuffix
            ? Icon(Icons.close, color: colorScheme.onSurface.withAlpha(153))
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
    );
  }

  Widget _buildDateField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String formattedDate =
        DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate!);

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
                    color: _isDateEnabled
                        ? colorScheme.onSurface.withAlpha(153)
                        : Colors.grey,
                    size: 20),
                const SizedBox(width: 10),
                Text(
                  _isDateEnabled ? formattedDate : 'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDateEnabled
                        ? colorScheme.onSurface
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down,
                color: _isDateEnabled
                    ? colorScheme.onSurface.withAlpha(153)
                    : Colors.grey),
          ],
        ),
      ),
    );
  }
}