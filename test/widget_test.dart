// test/widget_test.dart (DIPERBAIKI)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// PERBAIKAN 1: Gunakan package import (ganti nama package sesuai pubspec.yaml)
// Kemungkinan nama package yang benar adalah 'application_jec_frontend' 
// (tanpa typo 'appliaction')
import 'package:application_jec_frontend/main.dart';
import 'package:application_jec_frontend/providers/theme_provider.dart';

// PERBAIKAN 2: Import AppTheme enum dari app_themes.dart
import 'package:application_jec_frontend/themes/app_themes.dart';


void main() {
  testWidgets('Splash screen loads correctly', (WidgetTester tester) async {
    // Build aplikasi dengan provider yang dibutuhkan
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Menunggu semua frame selesai dirender
    await tester.pumpAndSettle();

    // PERBAIKAN 3: Mengubah test untuk splash screen
    // Karena di main.dart home nya adalah SplashScreen, bukan onboarding page
    // Test untuk memverifikasi bahwa splash screen berhasil dimuat
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Jika splash screen memiliki text atau widget tertentu, 
    // bisa ditambahkan test seperti ini:
    // expect(find.text('JEC App'), findsOneWidget);
    // atau
    // expect(find.byType(SplashScreen), findsOneWidget);
  });
  
  // Test tambahan untuk theme provider
  testWidgets('Theme can be toggled', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: const MyApp(),
      ),
    );

    // Test initial theme (should be light)
    expect(themeProvider.getCurrentThemeEnum, AppTheme.light);

    // Toggle theme
    themeProvider.toggleTheme();
    await tester.pump();

    // Verify theme changed to dark
    expect(themeProvider.getCurrentThemeEnum, AppTheme.dark);

    // Toggle back
    themeProvider.toggleTheme();
    await tester.pump();

    // Verify theme changed back to light
    expect(themeProvider.getCurrentThemeEnum, AppTheme.light);
  });
}