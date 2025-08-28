// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/home_page_data_models.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';
import 'page_perjanjian/cari_dokter_page.dart';
import 'page_perjanjian/cari_rs_klinik_page.dart';
import 'page_perjanjian/cari_layanan_page.dart';
import 'page_perjanjian/lasik_page.dart';
import 'page_perjanjian/flacs_page.dart';
import 'page_menu/tes_mata_page.dart';
import 'page_menu/fasilitas_page.dart';
import 'page_menu/lokasi_page.dart';
import 'page_menu/layanan_jec_page.dart';
import 'page_menu/asuransi_page.dart';
import 'page_menu/ebook_page.dart';
import 'page_menu/testimoni_page.dart';
import 'page_menu/video_page.dart';

// Constants
class HomePageConstants {
  static const Duration bannerAutoSlideInterval = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration menuAnimationDuration = Duration(milliseconds: 300);
  static const Duration fabAnimationDuration = Duration(milliseconds: 250);
  static const Duration mockApiDelay = Duration(milliseconds: 1500);
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 15.0;
  static const double borderRadiusLarge = 25.0;
  static const double borderRadiusXLarge = 30.0;
  
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(20.0);
  
  static const List<Color> menuColors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.red,
    Colors.amber,
  ];
}

class MockApiService {
  Future<HomePageData> fetchHomePageData() async {
    await Future.delayed(HomePageConstants.mockApiDelay);
    return const HomePageData(
      bannerImages: [
        'assets/carousel/banner1.jpg', 
        'assets/carousel/banner2.jpg'
      ],
      promoImages: [
        'assets/promo/promo1.jpg', 
        'assets/promo/promo2.jpg', 
        'assets/promo/promo3.jpg', 
        'assets/promo/promo4.jpg', 
        'assets/promo/promo5.jpg'
      ],
      socialImages: [
        'assets/sosial/sosial1.jpg', 
        'assets/sosial/sosial2.jpg', 
        'assets/sosial/sosial3.jpg', 
        'assets/sosial/sosial4.jpg', 
        'assets/sosial/sosial5.jpg'
      ],
      eventImages: [
        'assets/event/event1.jpg', 
        'assets/event/event2.jpg', 
        'assets/event/event3.jpg', 
        'assets/event/event4.jpg', 
        'assets/event/event5.jpg'
      ],
      achievementHeadlines: [
        'JEC Pionir Dalam Implementasi Teknologi Semi-Robotic untuk Operasi Katarak', 
        'Pengukuhan Prof. DR. Dr. Tjahjono D. Gondhowiardjo, SpM(K) sebagai Guru Besar Tetap FKUI', 
        'Pengukuhan Spesialis Mata JEC Prof. Dr. dr. Yunia Irawati, SpM(K) sebagai Guru Besar Tetap FKUI'
      ],
      artikelHeadlines: [
        'Kenali Jenis-Jenis LASIK dan Ketentuannya Sebelum Operasi', 
        'Klinik Mata Terpercaya untuk Menjaga Kondisi Mata Tetap Sehat', 
        'RS Mata Terbaik untuk Keluarga Indonesia dengan Pelayanan Lengkap'
      ],
      awardsHeadlines: [
        'JEC @ Kedoya Kembali Raih Akreditasi Internasional dari Joint Commission International', 
        'JEC Meraih Corporate Image Award 2018 untuk Kategori Eye Hospital', 
        'JEC Raih Penghargaan Marketeers OMNI Brand 2023 yang Bergengsi'
      ],
      cataractHeadlines: [
        'Kick Off 910 Operasi Katarak Gratis di RS Mata JEC dan Cabang Lainnya', 
        'Penyuluhan Katarak Di Gereja Bukit Moria oleh Tim Medis JEC', 
        'Bakti Katarak Dalam Rangka HUT JEC Ke 34 Bekerjasama dengan BUMN'
      ],
      achievementImage: 'assets/achievement/achievement1.jpg',
      artikelImage: 'assets/artikel/artikel1.jpg',
      awardsImage: 'assets/awards/awards1.jpg',
      cataractImage: 'assets/cataract/cataract1.jpg',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Controllers
  late final PageController _pageController;
  late final AnimationController _menuAnimationController;
  late final AnimationController _fabAnimationController;
  late final Animation<double> _slideAnimation;
  late final DecorationTween _fabDecorationTween;
  final OverlayPortalController _fabOverlayController = OverlayPortalController();
  
  // Notifiers
  final ValueNotifier<int> _bannerIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _showMoreMenuNotifier = ValueNotifier<bool>(false);

  // State
  Timer? _bannerTimer;
  late Future<HomePageData> _homePageDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _loadData();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _menuAnimationController = AnimationController(
      vsync: this, 
      duration: HomePageConstants.menuAnimationDuration,
    );
    _fabAnimationController = AnimationController(
      vsync: this, 
      duration: HomePageConstants.fabAnimationDuration,
    );
  }

  void _setupAnimations() {
    _slideAnimation = Tween<double>(
      begin: 1.0, 
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController, 
      curve: Curves.easeInOut,
    ));
    
    _fabDecorationTween = DecorationTween(
      begin: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      end: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );

    _showMoreMenuNotifier.addListener(_handleMenuAnimation);
  }

  void _loadData() {
    _homePageDataFuture = MockApiService().fetchHomePageData();
    _homePageDataFuture.then((data) {
      if (mounted && data.bannerImages.isNotEmpty) {
        _startAutoSlide(data.bannerImages.length);
      }
    }).catchError((error) {
      if (mounted) {
        debugPrint('Error loading home page data: $error');
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    _menuAnimationController.dispose();
    _fabAnimationController.dispose();
    _bannerIndexNotifier.dispose();
    _showMoreMenuNotifier.removeListener(_handleMenuAnimation);
    _showMoreMenuNotifier.dispose();
    super.dispose();
  }
  
  void _startAutoSlide(int bannerCount) {
    if (bannerCount == 0) return;
    _bannerTimer?.cancel(); // Cancel existing timer
    _bannerTimer = Timer.periodic(HomePageConstants.bannerAutoSlideInterval, (timer) {
      if (!mounted || !_pageController.hasClients) {
        timer.cancel();
        return;
      }
      
      final nextPage = (_bannerIndexNotifier.value + 1) % bannerCount;
      _pageController.animateToPage(
        nextPage, 
        duration: HomePageConstants.pageTransitionDuration, 
        curve: Curves.easeInOut,
      );
    });
  }
  
  void _handleMenuAnimation() {
    if (_showMoreMenuNotifier.value) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }
  }
  
  void _toggleMoreMenu() {
    _showMoreMenuNotifier.value = !_showMoreMenuNotifier.value;
  }

  void _closeMoreMenu() {
    if (_showMoreMenuNotifier.value) {
      _showMoreMenuNotifier.value = false;
    }
  }

  void _navigateToPage(Widget page) {
    if (_fabOverlayController.isShowing) {
      _toggleFabMenu();
    }
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  void _toggleFabMenu() {
    if (_fabAnimationController.isCompleted) {
      _fabAnimationController.reverse();
    } else {
      _fabAnimationController.forward();
    }
    _fabOverlayController.toggle();
  }

  void _retryDataLoad() {
    setState(() {
      _homePageDataFuture = MockApiService().fetchHomePageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HomePageData>(
        future: _homePageDataFuture,
        builder: (context, snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          
          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final data = isLoading ? HomePageData.skeleton() : snapshot.data!;
          
          return Skeletonizer(
  enabled: isLoading,
  child: Builder( // <-- 1. Tambahkan widget Builder
    builder: (context) { // <-- 2. Ini memberikan 'context' BARU yang berada di bawah Skeletonizer
      return _buildMainContent(context, data); // <-- 3. Gunakan context baru ini
    },
  ),
);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: HomePageConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Periksa koneksi internet Anda dan coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _retryDataLoad,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return OverlayPortal(
      controller: _fabOverlayController,
      overlayChildBuilder: (context) => _buildFabMenuOverlay(),
      child: _buildFab(),
    );
  }

  Widget _buildFab() {
    return AnimatedBuilder(
      animation: _fabAnimationController,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: _toggleFabMenu,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: _fabDecorationTween.evaluate(_fabAnimationController),
            child: Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _fabAnimationController,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFabMenuOverlay() {
    return AnimatedBuilder(
      animation: _fabAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _toggleFabMenu,
              child: Container(
                color: Colors.black.withAlpha(
                  (128 * _fabAnimationController.value).round(),
                ),
              ),
            ),
            ..._buildFabMenuItems(),
          ],
        );
      },
    );
  }

  List<Widget> _buildFabMenuItems() {
    final menuItems = [
      _FabMenuItem(
        icon: Icons.medical_services, 
        label: 'FLACS', 
        onTap: () => _navigateToPage(const FlacsPage()),
      ),
      _FabMenuItem(
        icon: Icons.visibility, 
        label: 'LASIK', 
        onTap: () => _navigateToPage(const LasikPage()),
      ),
      _FabMenuItem(
        icon: Icons.grid_view, 
        label: 'Cari Layanan', 
        onTap: () => _navigateToPage(const CariLayananPage()),
      ),
      _FabMenuItem(
        icon: Icons.description, 
        label: 'Cari RS/Klinik', 
        onTap: () => _navigateToPage(const CariRsKlinikPage()),
      ),
      _FabMenuItem(
        icon: Icons.person_search, 
        label: 'Cari Dokter', 
        onTap: () => _navigateToPage(const CariDokterPage()),
      ),
    ];
    
    return List.generate(menuItems.length, (index) {
      final doubleTween = Tween<double>(begin: 0, end: 1);
      final animation = CurvedAnimation(
        parent: _fabAnimationController,
        curve: Interval(
          0.2 + (0.1 * index), 
          1.0, 
          curve: Curves.easeOut,
        ),
      );
      
      return Positioned(
        right: 16.0,
        bottom: 88.0 + (64.0 * index),
        child: ScaleTransition(
          scale: doubleTween.animate(animation),
          child: FadeTransition(
            opacity: doubleTween.animate(animation),
            child: menuItems[index],
          ),
        ),
      );
    }).reversed.toList();
  }

  Widget _buildMainContent(BuildContext context, HomePageData data) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeAssets = Theme.of(context).extension<ThemeAssetData>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (themeAssets == null) {
      return const Center(
        child: Text('Theme assets not found'),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(colorScheme, isDarkMode),
        _buildContent(context, data, colorScheme, themeAssets, isDarkMode),
        _buildMoreMenuOverlay(),
      ],
    );
  }

  Widget _buildBackground(ColorScheme colorScheme, bool isDarkMode) {
    return Container(
      decoration: isDarkMode
          ? BoxDecoration(color: colorScheme.surface)
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withAlpha(230),
                  colorScheme.primary,
                  colorScheme.primary.withAlpha(204),
                ],
              ),
            ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HomePageData data,
    ColorScheme colorScheme,
    ThemeAssetData themeAssets,
    bool isDarkMode,
  ) {
    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _buildHeader(context, colorScheme), // Pass context to header
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          _buildMainCard(context, data, colorScheme, themeAssets, isDarkMode),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context, ColorScheme colorScheme) {
    // Check skeletonizer state inside the build method
    final isSkeleton = Skeletonizer.of(context).enabled;

    return SliverToBoxAdapter(
      child: Padding(
        padding: HomePageConstants.paddingLarge,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              // Conditionally show the icon
              child: isSkeleton
                  ? null
                  : Icon(
                      Icons.person,
                      size: 30,
                      color: colorScheme.primary,
                    ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Pagi',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    'Jose Elio Parhusip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '0 Points',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMainCard(
    BuildContext context,
    HomePageData data,
    ColorScheme colorScheme,
    ThemeAssetData themeAssets,
    bool isDarkMode,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(HomePageConstants.borderRadiusXLarge),
            topRight: Radius.circular(HomePageConstants.borderRadiusXLarge),
          ),
        ),
        child: Padding(
          padding: HomePageConstants.paddingLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ThemeSwitcher(),
              const SizedBox(height: 20),
              Text(
                'Buat Janji Pertemuan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _buildServiceContainer(colorScheme, isDarkMode),
              const SizedBox(height: 40),
              Text(
                'Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuGrid(themeAssets),
              const SizedBox(height: 30),
              _buildBannerCarousel(data.bannerImages),
              const SizedBox(height: 30),
              _buildSectionHeader(context, title: 'Promo'),
              const SizedBox(height: 20),
              _buildHorizontalList(images: data.promoImages, height: 220),
              const SizedBox(height: 30),
              _buildSectionHeader(context, title: 'Tanggung Jawab Sosial Perusahaan'),
              const SizedBox(height: 20),
              _buildHorizontalList(
                images: data.socialImages,
                height: 160,
                cardWidth: 200,
              ),
              const SizedBox(height: 30),
              _buildSectionHeader(context, title: 'Event'),
              const SizedBox(height: 20),
              _buildHorizontalList(images: data.eventImages, height: 220),
              const SizedBox(height: 30),
              _VerticalContentCard(
                icon: Icons.emoji_events_outlined,
                title: 'Achievement',
                imagePath: data.achievementImage,
                headlines: data.achievementHeadlines,
              ),
              const SizedBox(height: 20),
              _VerticalContentCard(
                icon: Icons.article_outlined,
                title: 'Artikel',
                imagePath: data.artikelImage,
                headlines: data.artikelHeadlines,
              ),
              const SizedBox(height: 20),
              _VerticalContentCard(
                icon: Icons.military_tech_outlined,
                title: 'Awards',
                imagePath: data.awardsImage,
                headlines: data.awardsHeadlines,
              ),
              const SizedBox(height: 20),
              _VerticalContentCard(
                icon: Icons.visibility_outlined,
                title: 'Cataract',
                imagePath: data.cataractImage,
                headlines: data.cataractHeadlines,
              ),
              const SizedBox(height: 20),
              const _NewsletterSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceContainer(ColorScheme colorScheme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceItem(
            iconPath: 'assets/icons/iconsmenu/cari-dokter.png',
            label: 'Cari\nDokter',
            onTap: () => _navigateToPage(const CariDokterPage()),
          ),
          _ServiceItem(
            iconPath: 'assets/icons/iconsmenu/cari_rumahsakit.png',
            label: 'Cari\nRS/Klinik',
            onTap: () => _navigateToPage(const CariRsKlinikPage()),
          ),
          _ServiceItem(
            iconPath: 'assets/icons/iconsmenu/cari-layanan.png',
            label: 'Cari\nLayanan',
            onTap: () => _navigateToPage(const CariLayananPage()),
          ),
          _ServiceItem(
            iconPath: 'assets/icons/iconsmenu/lasik.svg',
            label: 'LASIK',
            onTap: () => _navigateToPage(const LasikPage()),
          ),
          _ServiceItem(
            iconPath: 'assets/icons/iconsmenu/flacs.svg',
            label: 'FLACS',
            onTap: () => _navigateToPage(const FlacsPage()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(ThemeAssetData themeAssets) {
    final menuItems = [
      _MenuGridItem(
        icon: themeAssets.tesMataIcon,
        label: 'Tes Mata',
        backgroundColor: HomePageConstants.menuColors[0],
        onTap: () => _navigateToPage(const TesMataPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.fasilitasIcon,
        label: 'Fasilitas',
        backgroundColor: HomePageConstants.menuColors[1],
        onTap: () => _navigateToPage(const FasilitasPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.lokasiJecIcon,
        label: 'Lokasi JEC',
        backgroundColor: HomePageConstants.menuColors[2],
        onTap: () => _navigateToPage(const LokasiPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.layananJecIcon,
        label: 'Layanan JEC',
        backgroundColor: HomePageConstants.menuColors[3],
        onTap: () => _navigateToPage(const LayananJecPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.asuransiIcon,
        label: 'Asuransi',
        backgroundColor: HomePageConstants.menuColors[4],
        onTap: () => _navigateToPage(const AsuransiPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.ebookIcon,
        label: 'E-Book',
        backgroundColor: HomePageConstants.menuColors[5],
        onTap: () => _navigateToPage(const EbookPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.testimoniIcon,
        label: 'Testimoni',
        backgroundColor: HomePageConstants.menuColors[6],
        onTap: () => _navigateToPage(const TestimoniPage()),
      ),
      _MenuGridItem(
        icon: Icons.video_library,
        label: 'Video',
        backgroundColor: HomePageConstants.menuColors[7],
        onTap: () => _navigateToPage(const VideoPage()),
      ),
      _MenuGridItem(
        icon: themeAssets.lainnyaIcon,
        label: 'Lainnya',
        backgroundColor: HomePageConstants.menuColors[8],
        onTap: _toggleMoreMenu,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.95,
      children: menuItems,
    );
  }
  
  Widget _buildBannerCarousel(List<String> bannerImages) {
    if (bannerImages.isEmpty) {
      return Skeleton.leaf(
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
            color: Colors.grey[300],
          ),
        ),
      );
    }

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => _bannerIndexNotifier.value = index,
              itemCount: bannerImages.length,
              itemBuilder: (context, index) => Image.asset(
                bannerImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<int>(
                valueListenable: _bannerIndexNotifier,
                builder: (context, currentIndex, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bannerImages.asMap().entries.map((entry) {
                      final isActive = currentIndex == entry.key;
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(
                          entry.key,
                          duration: HomePageConstants.pageTransitionDuration,
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          width: isActive ? 12 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isActive
                                ? Colors.white
                                : Colors.white.withAlpha(128),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Row _buildSectionHeader(BuildContext context, {required String title}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement navigation to full list
          },
          child: Text(
            'Lihat Semua',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalList({
    required List<String> images,
    required double height,
    double? cardWidth,
  }) {
    if (images.isEmpty) {
      return Skeleton.leaf(
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
            color: Colors.grey[300],
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
            child: cardWidth != null
                ? _ImageCard(imagePath: images[index], width: cardWidth)
                : _HorizontalAdaptiveCard(imagePath: images[index], height: height),
          );
        },
      ),
    );
  }
  
  Widget _buildMoreMenuOverlay() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showMoreMenuNotifier,
      builder: (context, isShowing, child) {
        if (!isShowing) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            GestureDetector(
              onTap: _closeMoreMenu,
              child: Container(
                color: Colors.black.withAlpha(128),
              ),
            ),
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    MediaQuery.of(context).size.height * _slideAnimation.value,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _MoreMenuSheet(onClose: _closeMoreMenu),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.surface,
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.getCurrentThemeEnum == AppTheme.dark;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isDarkMode ? 'Mode Gelap' : 'Mode Terang',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const Spacer(),
              Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;
    final isSkeleton = Skeletonizer.of(context).enabled;
    Widget iconWidget;

    if(isSkeleton) {
        iconWidget = const SizedBox(width: 30, height: 30);
    } else if (iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        width: 30,
        height: 30,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        placeholderBuilder: (context) => Icon(
          Icons.image_not_supported,
          color: iconColor,
          size: 30,
        ),
      );
    } else {
      iconWidget = Image.asset(
        iconPath,
        width: 30,
        height: 30,
        color: iconColor,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported,
          color: iconColor,
          size: 30,
        ),
      );
    }

    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// --- KODE YANG DIPERBAIKI ---
class _MenuGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _MenuGridItem({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusLarge),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withAlpha(60), // Transparansi disesuaikan
              // Ikon dikembalikan ke dalam CircleAvatar
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ----------------------------

class _HorizontalAdaptiveCard extends StatelessWidget {
  final String imagePath;
  final double height;

  const _HorizontalAdaptiveCard({
    required this.imagePath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 150,
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String imagePath;
  final double width;

  const _ImageCard({
    required this.imagePath,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerticalContentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String imagePath;
  final List<String> headlines;

  const _VerticalContentCard({
    required this.icon,
    required this.title,
    required this.imagePath,
    required this.headlines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : colorScheme.primary;

    return Container(
      padding: HomePageConstants.paddingMedium,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            spreadRadius: 1,
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
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement navigation to full list
                },
                child: Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imagePath.isEmpty 
              ? Skeleton.leaf(
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                  ),
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 64,
                    ),
                  ),
                ),
          ),
          const SizedBox(height: 8),
          ...headlines.map((headline) {
            final isLast = headlines.last == headline;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    headline,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(204),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: theme.dividerColor.withAlpha(128),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _NewsletterSection extends StatefulWidget {
  const _NewsletterSection();

  @override
  State<_NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<_NewsletterSection> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _subscribeNewsletter() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon masukkan email yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        _emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil berlangganan newsletter!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan, coba lagi nanti'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Text(
            'Anda Ingin Mengetahui Informasi Terkini Dari JEC?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan Email Anda Untuk Berlangganan Newsletter JEC',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      hintText: 'someone@example.com',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _subscribeNewsletter,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Berlangganan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreMenuSheet extends StatelessWidget {
  final VoidCallback onClose;

  const _MoreMenuSheet({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0) onClose();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(HomePageConstants.borderRadiusLarge),
            topRight: Radius.circular(HomePageConstants.borderRadiusLarge),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: HomePageConstants.paddingSmall,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            Expanded(
              child: Padding(
                padding: HomePageConstants.paddingMedium,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85,
                  children: [
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.bar_chart,
                      label: 'Tes Mata',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TesMataPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.people,
                      label: 'Tentang JEC',
                      onTap: () {
                        onClose();
                        // TODO: Implement navigation
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.location_on,
                      label: 'Lokasi JEC',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LokasiPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.medical_services,
                      label: 'Layanan JEC',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LayananJecPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.favorite,
                      label: 'Asuransi\nRekanan',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AsuransiPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.book,
                      label: 'E-Book',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EbookPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.chat_bubble,
                      label: 'Testimoni',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TestimoniPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.sports_esports,
                      label: 'Whistle\nblowing',
                      onTap: () {
                        onClose();
                        // TODO: Implement navigation
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.card_giftcard,
                      label: 'Penghargaan',
                      onTap: () {
                        onClose();
                        // TODO: Implement navigation
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.home_work,
                      label: 'Fasilitas',
                      onTap: () {
                        onClose();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FasilitasPage()));
                      },
                    ),
                    _buildMoreMenuItem(
                      context,
                      icon: Icons.share,
                      label: 'Media Sosial',
                      onTap: () {
                        onClose();
                        // TODO: Implement navigation
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(HomePageConstants.borderRadiusMedium),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}