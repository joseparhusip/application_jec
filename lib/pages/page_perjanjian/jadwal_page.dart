// jadwal_page.dart - Professional Version

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPage extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;

  const JadwalPage({
    super.key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
  });

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;
  
  int _selectedTabIndex = 0;
  final DateTime _currentWeekStart = DateTime.now();

  // Data jadwal yang lebih detail dan realistis
  final Map<String, List<ScheduleItem>> _scheduleData = {
    'Senin': [
      ScheduleItem(
        location: 'JEC @ Kedoya',
        time: '08:00 - 12:00',
        type: 'Praktek Umum',
        slots: 16,
        bookedSlots: 12,
        icon: Icons.local_hospital,
        color: Colors.blue,
      ),
      ScheduleItem(
        location: 'JEC @ Menteng',
        time: '14:00 - 17:00',
        type: 'Konsultasi Khusus',
        slots: 12,
        bookedSlots: 8,
        icon: Icons.visibility,
        color: Colors.green,
      ),
    ],
    'Selasa': [
      ScheduleItem(
        location: 'JEC @ Cibubur',
        time: '09:00 - 13:00',
        type: 'Pemeriksaan Rutin',
        slots: 16,
        bookedSlots: 14,
        icon: Icons.medical_services,
        color: Colors.orange,
      ),
      ScheduleItem(
        location: 'Konsultasi Online',
        time: '19:00 - 21:00',
        type: 'Telemedicine',
        slots: 8,
        bookedSlots: 5,
        icon: Icons.videocam,
        color: Colors.purple,
      ),
    ],
    'Rabu': [
      ScheduleItem(
        location: 'JEC @ Kedoya',
        time: '08:00 - 12:00',
        type: 'Praktek Umum',
        slots: 16,
        bookedSlots: 10,
        icon: Icons.local_hospital,
        color: Colors.blue,
      ),
    ],
    'Kamis': [
      ScheduleItem(
        location: 'JEC @ Menteng',
        time: '14:00 - 18:00',
        type: 'Operasi & Tindakan',
        slots: 6,
        bookedSlots: 6,
        icon: Icons.healing,
        color: Colors.red,
      ),
    ],
    'Jumat': [
      ScheduleItem(
        location: 'JEC @ Cibubur',
        time: '10:00 - 13:00',
        type: 'Praktek Umum',
        slots: 12,
        bookedSlots: 9,
        icon: Icons.local_hospital,
        color: Colors.blue,
      ),
      ScheduleItem(
        location: 'Konsultasi Online',
        time: '18:00 - 20:00',
        type: 'Follow Up Online',
        slots: 8,
        bookedSlots: 3,
        icon: Icons.video_call,
        color: Colors.teal,
      ),
    ],
    'Sabtu': [], // Libur
    'Minggu': [], // Libur
  };

  // Data statistik mingguan
  final Map<String, dynamic> _weeklyStats = {
    'totalSlots': 94,
    'bookedSlots': 67,
    'availableSlots': 27,
    'locations': 4,
  };

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 7, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _cardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    // Set tab awal ke hari ini
    int todayIndex = DateTime.now().weekday - 1;
    _selectedTabIndex = todayIndex;
    _tabController.animateTo(todayIndex);
    
    _animationController.forward();
    _cardAnimationController.forward();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  List<String> get _dayNames => [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Jadwal Dokter'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _showWeekPicker,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildWeeklyStats(),
              _buildTabBar(),
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ScaleTransition(
          scale: _cardScaleAnimation,
          child: _buildDoctorInfoCard(context),
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
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
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.doctorImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Minggu ${DateFormat('d MMM', 'id_ID').format(_currentWeekStart)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
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

  Widget _buildWeeklyStats() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Slot',
              '${_weeklyStats['totalSlots']}',
              Icons.event_available,
              colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Terboking',
              '${_weeklyStats['bookedSlots']}',
              Icons.event_busy,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Tersedia',
              '${_weeklyStats['availableSlots']}',
              Icons.event,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        tabs: _dayNames.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final daySchedules = _scheduleData[day] ?? [];
          final hasSchedule = daySchedules.isNotEmpty;
          final isToday = index == (DateTime.now().weekday - 1);
          
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(day.substring(0, 3)),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isToday) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == index 
                                ? colorScheme.onPrimary 
                                : colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (hasSchedule)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == index 
                                ? colorScheme.onPrimary.withOpacity(0.7)
                                : colorScheme.primary.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: _dayNames.map((day) {
        final schedules = _scheduleData[day] ?? [];
        
        if (schedules.isEmpty) {
          return _buildOffDayView(context, day);
        }
        
        return _buildScheduleList(schedules, day);
      }).toList(),
    );
  }

  Widget _buildScheduleList(List<ScheduleItem> schedules, String day) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutCubic,
          child: _buildScheduleCard(schedules[index], index),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildScheduleCard(ScheduleItem schedule, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final availableSlots = schedule.slots - schedule.bookedSlots;
    final occupancyPercentage = (schedule.bookedSlots / schedule.slots);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 200)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    schedule.color.withOpacity(0.1),
                    schedule.color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: schedule.color.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: schedule.color.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: schedule.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            schedule.icon,
                            color: schedule.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule.location,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                schedule.type,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: schedule.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: availableSlots > 0 
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: availableSlots > 0 
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            availableSlots > 0 ? 'Tersedia' : 'Penuh',
                            style: TextStyle(
                              color: availableSlots > 0 ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          schedule.time,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$availableSlots/${schedule.slots} slot',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tingkat Hunian',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(occupancyPercentage * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: occupancyPercentage,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              occupancyPercentage > 0.8 
                                  ? Colors.red 
                                  : occupancyPercentage > 0.6 
                                      ? Colors.orange 
                                      : Colors.green,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOffDayView(BuildContext context, String day) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeekend = day == 'Sabtu' || day == 'Minggu';
    
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWeekend ? Icons.weekend : Icons.event_busy_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isWeekend ? 'Hari Libur' : 'Tidak Ada Jadwal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isWeekend 
                      ? 'Dokter libur di akhir pekan'
                      : 'Dokter tidak memiliki jadwal praktek hari ini',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isWeekend) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to appointment booking
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Janji Temu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWeekPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pilih Minggu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // TODO: Add week picker implementation
              ListTile(
                title: const Text('Minggu Ini'),
                subtitle: Text(DateFormat('d MMM y', 'id_ID').format(DateTime.now())),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Minggu Depan'),
                subtitle: Text(DateFormat('d MMM y', 'id_ID')
                    .format(DateTime.now().add(const Duration(days: 7)))),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScheduleItem {
  final String location;
  final String time;
  final String type;
  final int slots;
  final int bookedSlots;
  final IconData icon;
  final Color color;

  ScheduleItem({
    required this.location,
    required this.time,
    required this.type,
    required this.slots,
    required this.bookedSlots,
    required this.icon,
    required this.color,
  });
}