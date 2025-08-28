// lib/pages/auth/splash_screen.dart

import 'dart:async';
import 'dart:math'; // Diperlukan untuk nilai pi dalam animasi
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'onboarding_page.dart'; // Sesuaikan path jika perlu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Atur timer untuk pindah ke halaman selanjutnya setelah 4 detik
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LoopAnimationBuilder<double>(
          // Membuat animasi berputar (2 * pi = 360 derajat)
          tween: Tween(begin: 0.0, end: 2 * pi),
          duration: const Duration(seconds: 2), // Durasi satu putaran penuh
          builder: (context, value, child) {
            return Transform(
              // Transformasi untuk efek 3D flip di sumbu Y (vertikal)
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Memberi efek perspektif 3D
                ..rotateY(value), // Berputar berdasarkan nilai animasi
              alignment: FractionalOffset.center,
              child: child,
            );
          },
          child: Image.asset(
            'assets/logo/jec-logo.png',
            width: 200,
            // Fallback jika gambar tidak ditemukan
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.visibility, size: 150, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }
}