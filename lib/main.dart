// lib/main.dart - COMPLETE WITH LANGUAGE SUPPORT

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'utils/app_localizations.dart';
import 'pages/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting untuk Indonesia dan English
  await initializeDateFormatting('id_ID', null);
  await initializeDateFormatting('en_US', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'JEC Application',
          debugShowCheckedModeBanner: false,
          
          // Theme configuration
          theme: themeProvider.getTheme,
          
          // Localization configuration
          locale: languageProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id', 'ID'), // Indonesia
            Locale('en', 'US'), // English
          ],
          
          // Fallback locale jika tidak ada yang cocok
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            // Fallback ke Indonesia jika tidak ada yang cocok
            return const Locale('id', 'ID');
          },

          home: const SplashScreen(),
        );
      },
    );
  }
}