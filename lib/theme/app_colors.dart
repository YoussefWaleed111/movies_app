import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF121212);
  static const Color backgroundPureBlack = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF1A1A1E);
  static const Color cardBackground = Color(0xFF1E1E24);
  static const Color overlayCardBackground = Color(0xFF19191F);
  static const Color cardBackgroundLight = Color(0xFF282832);
  static const Color placeholderDark = Color(0xFF22222A);
  static const Color placeholderBorder = Color(0xFF383845);

  // Accents & Highlights (Figma Spec: #FFA90A / #FFC107)
  static const Color primaryYellow = Color(0xFFFFA90A);
  static const Color primaryGold = Color(0xFFFFC107);
  static const Color primaryYellowHover = Color(0xFFFFB733);
  static const Color accentRed = Color(0xFFE50914);
  static const Color accentBlue = Color(0xFF1E88E5);
  static const Color accentPurple = Color(0xFF8E24AA);

  // Gradients for Specific Movie Themes (Figma Specs: Avengers, Oppenheimer, Bad Boys, Doctor Strange, 1917)
  static const Gradient avengersGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF152238), Color(0xFF0D111A)],
  );

  static const Gradient oppenheimerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A1805), Color(0xFF1A0A03)],
  );

  static const Gradient badBoysGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3A0B4D), Color(0xFF12041A)],
  );

  static const Gradient doctorStrangeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F1B38), Color(0xFF4A0E17)],
  );

  static const Gradient war1917Gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2A2A1F), Color(0xFF12120D)],
  );

  static const Gradient authBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A26), Color(0xFF121212)],
  );

  static const Gradient heroPosterOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xCC121212),
      Color(0xFF121212),
    ],
  );

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9EA8);
  static const Color textDisabled = Color(0xFF62626E);

  // Status & Shimmer
  static const Color errorRed = Color(0xFFCF6679);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color shimmerBase = Color(0xFF1E1E24);
  static const Color shimmerHighlight = Color(0xFF333340);
}
