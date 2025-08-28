// lib/auth/onboarding_page.dart
// OPTIMIZED FOR PRODUCTION - Faster loading & smoother animations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

// Optimized Model - Immutable dan const
@immutable
class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> 
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  bool _isAnimating = false;

  // Static data untuk performa lebih baik
  static const List<OnboardingItem> _onboardingData = [
    OnboardingItem(
      image: "assets/docter/Dr. Damara Andalia, SpM.png",
      title: "Dokter Spesialis Terpercaya",
      description:
          "Tim dokter ahli mata terbaik untuk kesehatan penglihatan Anda dengan pengalaman bertahun-tahun.",
    ),
    OnboardingItem(
      image: "assets/dekorasi/prosedur_bedah_icl.webp",
      title: "Teknologi Medis Terkini",
      description:
          "Peralatan diagnostik dan bedah tercanggih untuk hasil akurat dan pemulihan lebih cepat.",
    ),
    OnboardingItem(
      image: "assets/dekorasi/pasien-dokter.png",
      title: "Layanan Prima & Nyaman",
      description:
          "Kemudahan akses jadwal konsultasi dan rekam medis langsung dari smartphone Anda.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _pageController = PageController();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start initial animation
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // FIXED: Method navigasi ke login dengan penempatan kurung kurawal yang benar
  void _navigateToLogin() {
    if (_isAnimating) return;
    
    HapticFeedback.lightImpact();
    _isAnimating = true;
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  void _nextPage() {
    if (_isAnimating) return;
    
    HapticFeedback.selectionClick();
    _isAnimating = true;
    
    if (_currentPage == _onboardingData.length - 1) {
      _navigateToLogin(); // Navigasi ke login ketika di halaman terakhir
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      ).then((_) {
        _isAnimating = false;
        _resetAnimations();
      });
    }
  }

  void _resetAnimations() {
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingData.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                        _isAnimating = false;
                      });
                      _resetAnimations();
                    },
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: OnboardingContent(
                            item: _onboardingData[index],
                            isFirstPage: index == 0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Section - Optimized
                Expanded(
                  flex: 1,
                  child: _buildBottomSection(context, colorScheme),
                ),
              ],
            ),
            
            // Skip Button - Only show when not on last page
            if (_currentPage != _onboardingData.length - 1)
              _buildSkipButton(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page Indicators - Optimized
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => _buildDot(index, colorScheme),
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Action Button - Optimized
          _buildActionButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildSkipButton(ColorScheme colorScheme) {
    return Positioned(
      top: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _navigateToLogin,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Lewati',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index, ColorScheme colorScheme) {
    final isActive = _currentPage == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.onSurface.withOpacity(0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActionButton(ColorScheme colorScheme) {
    final isLastPage = _currentPage == _onboardingData.length - 1;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: _isAnimating ? null : _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: isLastPage ? 6 : 4,
          shadowColor: colorScheme.primary.withOpacity(0.4),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            isLastPage ? 'Mulai Sekarang' : 'Lanjutkan',
            key: ValueKey<bool>(isLastPage),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Optimized Content Widget
class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.item,
    this.isFirstPage = false,
  });

  final OnboardingItem item;
  final bool isFirstPage;

  @override
  Widget build(BuildContext context) {
    return isFirstPage 
        ? _FirstPageContent(item: item)
        : _StandardPageContent(item: item);
  }
}

// Separated untuk better performance
class _FirstPageContent extends StatelessWidget {
  const _FirstPageContent({required this.item});
  
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.08),
                colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        
        // Decorative Circle - Optimized
        Positioned(
          top: size.height * 0.08,
          left: -size.width * 0.15,
          child: Container(
            width: size.width * 0.6,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Content
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildImage(item.image),
              ),
            ),
            Expanded(
              flex: 1,
              child: _TextContent(item: item),
            ),
          ],
        ),
      ],
    );
  }
}

class _StandardPageContent extends StatelessWidget {
  const _StandardPageContent({required this.item});
  
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildImage(item.image),
          ),
        ),
        Expanded(
          flex: 1,
          child: _TextContent(item: item),
        ),
      ],
    );
  }
}

Widget _buildImage(String imagePath) {
  return Hero(
    tag: imagePath,
    child: Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Gambar tidak ditemukan',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _TextContent extends StatelessWidget {
  const _TextContent({required this.item});
  
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}