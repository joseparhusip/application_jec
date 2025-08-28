import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Variabel untuk melacak status filter yang dipilih
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Terjadwal', 'Terkonfirmasi', 'Dibatalkan', 'Selesai'];

  String _selectedSort = 'Newest';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Janji Temu',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // --- Baris Sorting & Filter ---
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Sorting Dropdown (contoh)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sorting', style: TextStyle(color: Colors.grey)),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedSort, // Gunakan variabel state
                                    icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
                                    items: ['Newest', 'Oldest']
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold))))
                                        .toList(),
                                    onChanged: (String? newValue) { // Tambahkan logika di sini
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedSort = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            // Filter Status
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Status', style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      spacing: 8.0,
                                      children: List<Widget>.generate(
                                        _filters.length,
                                        (int index) {
                                          return ChoiceChip(
                                            label: Text(_filters[index]),
                                            selected: _selectedFilterIndex == index,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _selectedFilterIndex = selected ? index : -1;
                                              });
                                            },
                                            selectedColor: colorScheme.primary,
                                            labelStyle: TextStyle(
                                              color: _selectedFilterIndex == index ? colorScheme.onPrimary : colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            backgroundColor: Colors.grey.shade200,
                                            shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
                                            showCheckmark: false,
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // --- Tampilan "Belum ada data" ---
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 100, color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Text(
                            'Belum ada data',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
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