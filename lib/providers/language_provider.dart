// providers/language_provider.dart - COMPLETE VERSION
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('id', 'ID');
  
  Locale get locale => _locale;
  
  // Getter untuk mendapatkan kode bahasa saat ini
  String get currentLanguageCode => _locale.languageCode;
  
  // Getter untuk mendapatkan nama bahasa yang ditampilkan
  String get currentLanguageName => _locale.languageCode == 'id' ? 'IND' : 'ENG';
  
  // Getter untuk mendapatkan flag
  Widget get currentFlag => _buildFlag(_locale.languageCode);
  
  // Constructor - load saved language
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  // Load bahasa yang tersimpan dari SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey) ?? 'id';
      _locale = Locale(
        savedLanguageCode, 
        savedLanguageCode == 'id' ? 'ID' : 'US'
      );
      notifyListeners();
    } catch (e) {
      // Jika gagal load, tetap pakai default (Indonesia)
      debugPrint('Failed to load saved language: $e');
    }
  }
  
  // Mengubah bahasa dan menyimpannya
  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _locale = Locale(
        languageCode, 
        languageCode == 'id' ? 'ID' : 'US'
      );
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to save language preference: $e');
    }
  }
  
  // Toggle antara Indonesia dan Inggris
  void toggleLanguage() {
    final newLanguageCode = _locale.languageCode == 'id' ? 'en' : 'id';
    changeLanguage(newLanguageCode);
  }
  
  // Method untuk mendapatkan teks berdasarkan bahasa (fallback)
  String getText({
    required String indonesian,
    required String english,
  }) {
    return _locale.languageCode == 'id' ? indonesian : english;
  }
  
  // Build widget flag berdasarkan kode bahasa
  Widget _buildFlag(String languageCode) {
    const double flagWidth = 24.0;
    const double flagHeight = 18.0;
    const double borderRadius = 3.0;
    
    if (languageCode == 'id') {
      // Flag Indonesia (Merah Putih)
      return Container(
        width: flagWidth,
        height: flagHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFFF0000), // Merah Indonesia
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Flag Amerika Serikat (Simplified)
      return Container(
        width: flagWidth,
        height: flagHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // Background stripes
              Column(
                children: List.generate(13, (index) {
                  return Expanded(
                    child: Container(
                      width: double.infinity,
                      color: index.isEven 
                        ? const Color(0xFFB22234) // Red stripe
                        : Colors.white, // White stripe
                    ),
                  );
                }),
              ),
              // Blue canton with simplified star
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: flagWidth * 0.4,
                  height: flagHeight * 0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3C3B6E), // Blue canton
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '★',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  
  // Method untuk debug - menampilkan bahasa saat ini
  void printCurrentLanguage() {
    debugPrint('Current language: ${_locale.languageCode} (${_locale.countryCode})');
  }
  
  // Method untuk mendapatkan semua bahasa yang didukung
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {
        'code': 'id',
        'name': 'Indonesia',
        'displayName': 'IND',
      },
      {
        'code': 'en',
        'name': 'English',
        'displayName': 'ENG',
      },
    ];
  }
}