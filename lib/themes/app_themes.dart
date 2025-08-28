// app_themes.dart (KODE BARU DENGAN WARNA BIRU NAVY)

import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
}

// DIUBAH: Ditambahkan bonusIcon
@immutable
class ThemeAssetData extends ThemeExtension<ThemeAssetData> {
  final IconData tesMataIcon;
  final IconData fasilitasIcon;
  final IconData lokasiJecIcon;
  final IconData layananJecIcon;
  final IconData asuransiIcon;
  final IconData ebookIcon;
  final IconData testimoniIcon;
  final IconData bonusIcon; // BARU
  final IconData lainnyaIcon;

  const ThemeAssetData({
    required this.tesMataIcon,
    required this.fasilitasIcon,
    required this.lokasiJecIcon,
    required this.layananJecIcon,
    required this.asuransiIcon,
    required this.ebookIcon,
    required this.testimoniIcon,
    required this.bonusIcon, // BARU
    required this.lainnyaIcon,
  });

  @override
  ThemeExtension<ThemeAssetData> copyWith({
    IconData? tesMataIcon,
    IconData? fasilitasIcon,
    IconData? lokasiJecIcon,
    IconData? layananJecIcon,
    IconData? asuransiIcon,
    IconData? ebookIcon,
    IconData? testimoniIcon,
    IconData? bonusIcon, // BARU
    IconData? lainnyaIcon,
  }) {
    return ThemeAssetData(
      tesMataIcon: tesMataIcon ?? this.tesMataIcon,
      fasilitasIcon: fasilitasIcon ?? this.fasilitasIcon,
      lokasiJecIcon: lokasiJecIcon ?? this.lokasiJecIcon,
      layananJecIcon: layananJecIcon ?? this.layananJecIcon,
      asuransiIcon: asuransiIcon ?? this.asuransiIcon,
      ebookIcon: ebookIcon ?? this.ebookIcon,
      testimoniIcon: testimoniIcon ?? this.testimoniIcon,
      bonusIcon: bonusIcon ?? this.bonusIcon, // BARU
      lainnyaIcon: lainnyaIcon ?? this.lainnyaIcon,
    );
  }

  @override
  ThemeExtension<ThemeAssetData> lerp(ThemeExtension<ThemeAssetData>? other, double t) {
    if (other is! ThemeAssetData) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}


// DIUBAH: Ditambahkan data untuk bonusIcon
const aplicationIcons = ThemeAssetData(
  tesMataIcon: Icons.bar_chart,
  fasilitasIcon: Icons.home_work,
  lokasiJecIcon: Icons.location_on,
  layananJecIcon: Icons.medical_services,
  asuransiIcon: Icons.shield_outlined,
  ebookIcon: Icons.book,
  testimoniIcon: Icons.chat,
  bonusIcon: Icons.card_giftcard, // BARU
  lainnyaIcon: Icons.apps,
);

// DIUBAH: Warna tema diubah menjadi biru navy (Indigo)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo, // DIUBAH
    brightness: Brightness.light,
    primary: Colors.indigo, // DIUBAH
    secondary: Colors.orange,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  useMaterial3: true,
  extensions: const <ThemeExtension<dynamic>>[
    aplicationIcons,
  ],
);

// DIUBAH: Warna tema diubah menjadi biru navy (Indigo)
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo, // DIUBAH
    brightness: Brightness.dark,
    primary: Colors.indigoAccent, // DIUBAH
    secondary: Colors.orangeAccent,
    surface: const Color(0xFF121212),
    onSurface: Colors.white,
  ),
  useMaterial3: true,
  extensions: const <ThemeExtension<dynamic>>[
    aplicationIcons,
  ],
);