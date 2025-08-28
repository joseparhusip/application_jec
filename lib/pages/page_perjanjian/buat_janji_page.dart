// buat_janji_page.dart - Professional Version

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BuatJanjiPage extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;

  const BuatJanjiPage({
    super.key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
  });

  @override
  State<BuatJanjiPage> createState() => _BuatJanjiPageState();
}

class _BuatJanjiPageState extends State<BuatJanjiPage> 
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  String? _selectedLocation;
  String _selectedAppointmentType = 'Konsultasi Umum';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Data lokasi praktek
  final List<String> _locations = [
    'JEC @ Kedoya',
    'JEC @ Menteng', 
    'JEC @ Cibubur',
    'Konsultasi Online',
  ];

  // Data jenis appointment
  final List<String> _appointmentTypes = [
    'Konsultasi Umum',
    'Pemeriksaan Rutin',
    'Follow Up',
    'Second Opinion',
    'Konsultasi Khusus',
  ];

  // Data slot waktu berdasarkan lokasi
  final Map<String, List<String>> _timeSlotsByLocation = {
    'JEC @ Kedoya': [
      '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
      '11:00', '11:30', '14:00', '14:30', '15:00', '15:30'
    ],
    'JEC @ Menteng': [
      '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
      '13:00', '13:30', '14:00', '14:30', '15:00', '15:30'
    ],
    'JEC @ Cibubur': [
      '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', 
      '15:00', '15:30', '16:00', '16:30'
    ],
    'Konsultasi Online': [
      '08:00', '09:00', '10:00', '11:00', '13:00', '14:00',
      '15:00', '16:00', '19:00', '20:00', '21:00'
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedLocation = _locations.first;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> get _availableTimeSlots {
    if (_selectedLocation == null) return [];
    return _timeSlotsByLocation[_selectedLocation!] ?? [];
  }

  bool get _isFormValid {
    return _selectedDay != null && 
           _selectedTime != null && 
           _selectedLocation != null;
  }

  void _resetTimeSelection() {
    setState(() {
      _selectedTime = null;
    });
  }

  Future<void> _confirmAppointment() async {
    if (!_isFormValid) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildSuccessDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Buat Janji Temu'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDoctorInfoCard(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Jenis Konsultasi'),
                  const SizedBox(height: 12),
                  _buildAppointmentTypeSelector(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Lokasi Praktek'),
                  const SizedBox(height: 12),
                  _buildLocationSelector(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Pilih Tanggal'),
                  const SizedBox(height: 16),
                  _buildCalendar(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Pilih Waktu'),
                  const SizedBox(height: 16),
                  _buildTimeSlots(context),
                  const SizedBox(height: 28),
                  _buildAppointmentSummary(),
                  const SizedBox(height: 100), // Space for fixed button
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDoctorInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Hero(
              tag: 'doctor-${widget.doctorName}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.doctorImage,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      widget.doctorSpecialty,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (150+ reviews)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAppointmentType,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          items: _appointmentTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedAppointmentType = value;
              });
            }
          },
          icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _locations.map((location) {
        final isSelected = _selectedLocation == location;
        final isOnline = location.contains('Online');
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedLocation = location;
              _resetTimeSelection();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? colorScheme.primary 
                  : colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnline ? Icons.videocam : Icons.location_on,
                  size: 18,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: TextStyle(
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          locale: 'id_ID',
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _resetTimeSelection();
            });
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            markerDecoration: BoxDecoration(
              color: colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: colorScheme.error,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: colorScheme.primary,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_selectedLocation == null) {
      return const SizedBox.shrink();
    }

    final availableSlots = _availableTimeSlots;
    
    if (availableSlots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Tidak ada slot waktu tersedia untuk lokasi ini',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: availableSlots.map((time) {
        final isSelected = _selectedTime == time;
        final isAvailable = _isTimeSlotAvailable(time);
        
        return GestureDetector(
          onTap: isAvailable ? () {
            setState(() {
              _selectedTime = isSelected ? null : time;
            });
          } : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: !isAvailable 
                  ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
                  : isSelected 
                      ? colorScheme.primary 
                      : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !isAvailable
                    ? colorScheme.outline.withOpacity(0.2)
                    : isSelected 
                        ? colorScheme.primary 
                        : colorScheme.outline.withOpacity(0.4),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Text(
              time,
              style: TextStyle(
                color: !isAvailable
                    ? colorScheme.onSurface.withOpacity(0.4)
                    : isSelected 
                        ? colorScheme.onPrimary 
                        : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAppointmentSummary() {
    if (!_isFormValid) return const SizedBox.shrink();
    
    final colorScheme = Theme.of(context).colorScheme;
    final selectedDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(_selectedDay!);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Ringkasan Janji Temu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Jenis:', _selectedAppointmentType),
          _buildSummaryRow('Lokasi:', _selectedLocation!),
          _buildSummaryRow('Tanggal:', selectedDate),
          _buildSummaryRow('Waktu:', _selectedTime!),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: _isFormValid ? _confirmAppointment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid 
                  ? colorScheme.primary 
                  : colorScheme.surfaceContainerHighest,
              foregroundColor: _isFormValid 
                  ? colorScheme.onPrimary 
                  : colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: _isFormValid ? 4 : 0,
              textStyle: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isFormValid ? Icons.check_circle : Icons.info_outline),
                const SizedBox(width: 8),
                Text(_isFormValid 
                    ? 'Konfirmasi Janji Temu' 
                    : 'Lengkapi Data Terlebih Dahulu'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(_selectedDay!);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Janji Temu Berhasil Dibuat!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Dokter:', widget.doctorName),
                  _buildDetailRow('Tanggal:', selectedDate),
                  _buildDetailRow('Waktu:', _selectedTime!),
                  _buildDetailRow('Lokasi:', _selectedLocation!),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous page
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      // TODO: Navigate to appointment list or calendar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lihat Jadwal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  bool _isTimeSlotAvailable(String time) {
    // Simulasi logika ketersediaan slot
    // Dalam implementasi nyata, ini akan mengecek database
    if (_selectedDay == null) return false;
    
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
    
    // Tidak bisa booking waktu yang sudah lewat
    if (selectedDateTime.isBefore(now)) return false;
    
    // Simulasi: beberapa slot sudah terboking
    final bookedSlots = ['10:30', '14:00', '15:30'];
    if (bookedSlots.contains(time)) return false;
    
    return true;
  }
}