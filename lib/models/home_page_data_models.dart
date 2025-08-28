// lib/models/home_page_data_models.dart

import 'package:flutter/foundation.dart';

@immutable
class HomePageData {
  final List<String> bannerImages;
  final List<String> promoImages;
  final List<String> socialImages;
  final List<String> eventImages;
  final List<String> achievementHeadlines;
  final List<String> artikelHeadlines;
  final List<String> awardsHeadlines;
  final List<String> cataractHeadlines;
  final String achievementImage;
  final String artikelImage;
  final String awardsImage;
  final String cataractImage;

  const HomePageData({
    required this.bannerImages,
    required this.promoImages,
    required this.socialImages,
    required this.eventImages,
    required this.achievementHeadlines,
    required this.artikelHeadlines,
    required this.awardsHeadlines,
    required this.cataractHeadlines,
    required this.achievementImage,
    required this.artikelImage,
    required this.awardsImage,
    required this.cataractImage,
  });

  // --- PERBAIKAN: Menambahkan factory constructor untuk skeleton data ---
  factory HomePageData.skeleton() {
    return const HomePageData(
      bannerImages: [], // Biarkan kosong agar skeleton yang muncul
      promoImages: [],
      socialImages: [],
      eventImages: [],
      achievementHeadlines: ['Loading...', 'Loading...', 'Loading...'],
      artikelHeadlines: ['Loading...', 'Loading...', 'Loading...'],
      awardsHeadlines: ['Loading...', 'Loading...', 'Loading...'],
      cataractHeadlines: ['Loading...', 'Loading...', 'Loading...'],
      achievementImage: '', // Path kosong agar skeleton yang muncul
      artikelImage: '',
      awardsImage: '',
      cataractImage: '',
    );
  }
  // -----------------------------------------------------------------
}