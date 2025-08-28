import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class KontakKamiPage extends StatelessWidget {
  const KontakKamiPage({super.key});

  Future<void> _launchURL(String urlString, {bool forceInApp = false}) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (urlString.startsWith('mailto:') || urlString.startsWith('tel:')) {
        // Email dan telepon tetap buka aplikasi eksternal
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          debugPrint('Could not launch $urlString');
        }
      } else if (urlString.contains('wa.me') && !forceInApp) {
        // WhatsApp: coba buka di in-app browser dulu, jika gagal baru external
        try {
          if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
            await launchUrl(url, mode: LaunchMode.inAppBrowserView);
          }
        } catch (e) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        // URL web lainnya dibuka dalam in-app browser dengan opsi fallback
        try {
          if (!await launchUrl(
            url, 
            mode: LaunchMode.inAppWebView,
            webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true,
              enableDomStorage: true,
            ),
          )) {
            // Fallback ke in-app browser view
            await launchUrl(url, mode: LaunchMode.inAppBrowserView);
          }
        } catch (e) {
          debugPrint('Error with in-app view, trying browser view: $e');
          await launchUrl(url, mode: LaunchMode.inAppBrowserView);
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar dengan hero effect
          SliverAppBar(
            expandedHeight: screenHeight * 0.35,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: 50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    // Hero content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedFadeSlide(
                            delay: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.support_agent,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const AnimatedFadeSlide(
                            delay: Duration(milliseconds: 500),
                            child: Text(
                              'Hubungi Kami',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedFadeSlide(
                            delay: const Duration(milliseconds: 700),
                            child: Text(
                              'Kami siap membantu Anda 24/7',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Contact Section
                    AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 800),
                      child: _buildSectionHeader(
                        'Kontak Cepat',
                        'Pilih metode yang paling nyaman untuk Anda',
                        colorScheme,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contact Cards Grid
                    AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 900),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildContactCard(
                            context,
                            'assets/icons/whatsapp.png',
                            'WhatsApp',
                            'Chat Langsung',
                            Colors.green,
                            () => _launchURL('https://web.whatsapp.com/send?phone=6287729221000'),
                          ),
                          _buildContactCard(
                            context,
                            'assets/icons/telepone.png',
                            'Telepon',
                            'Panggilan Langsung',
                            Colors.blue,
                            () => _launchURL('tel:08041221000'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Email Card (Full Width)
                    AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 1000),
                      child: _buildEmailCard(
                        context,
                        () => _launchURL('mailto:care@jec.co.id'),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Social Media Section
                    AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 1100),
                      child: _buildSectionHeader(
                        'Media Sosial',
                        'Ikuti kami untuk update terbaru',
                        colorScheme,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social Media List
                    ...List.generate(4, (index) {
                      final socialMedia = [
                        {
                          'icon': 'assets/icons/instagram.png',
                          'name': 'Instagram',
                          'subtitle': '@jeceyehospital',
                          'url': 'https://www.instagram.com/jeceyehospital?igsh=MXZvZHdvbDUwMjY5Mg==',
                          'color': const Color(0xFFE4405F),
                        },
                        {
                          'icon': 'assets/icons/facebook.png',
                          'name': 'Facebook',
                          'subtitle': 'JEC Eye Hospital',
                          'url': 'https://share.google/uds4t77vFqfRzQbzs',
                          'color': const Color(0xFF1877F2),
                        },
                        {
                          'icon': 'assets/icons/youtube.png',
                          'name': 'YouTube',
                          'subtitle': 'Jakarta Eye Center',
                          'url': 'https://youtube.com/@jkteyecenter?si=yFVwMcHwxCrvmTot',
                          'color': const Color(0xFFFF0000),
                        },
                        {
                          'icon': 'assets/icons/twitter.png',
                          'name': 'Twitter',
                          'subtitle': '@JECEyeHospital',
                          'url': 'https://share.google/nyx7azHmqIdKOc5ZD',
                          'color': const Color(0xFF1DA1F2),
                        },
                      ][index];

                      return AnimatedFadeSlide(
                        delay: Duration(milliseconds: 1200 + (index * 100)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildSocialMediaCard(
                            context,
                            socialMedia['icon'] as String,
                            socialMedia['name'] as String,
                            socialMedia['subtitle'] as String,
                            socialMedia['color'] as Color,
                            () => _launchURL(socialMedia['url'] as String),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 40),

                    // Bottom CTA
                    AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 1600),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.secondary.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Terima kasih telah mempercayai kami',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tim kami siap memberikan pelayanan terbaik untuk kesehatan mata Anda',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String imagePath,
    String title,
    String subtitle,
    Color accentColor,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                accentColor.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(imagePath, width: 28, height: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailCard(BuildContext context, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colorScheme.primary.withOpacity(0.1),
                colorScheme.secondary.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset('assets/icons/gmail.png', width: 32, height: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'care@jec.co.id',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaCard(
    BuildContext context,
    String imagePath,
    String name,
    String subtitle,
    Color brandColor,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface,
            border: Border.all(
              color: brandColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(imagePath, width: 24, height: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: brandColor,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced AnimatedFadeSlide widget
class AnimatedFadeSlide extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const AnimatedFadeSlide({
    super.key,
    required this.delay,
    required this.child,
  });

  @override
  State<AnimatedFadeSlide> createState() => _AnimatedFadeSlideState();
}

class _AnimatedFadeSlideState extends State<AnimatedFadeSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Timer(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}