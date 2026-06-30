import 'package:flutter/material.dart';

/// Central colour palette for Srivalli Jewellers.
///
/// Navy is the primary brand colour, gold is used for accents/CTAs, and the
/// status colours follow the agreed semantic scheme.
class AppColors {
  AppColors._();

  // Primary navy
  static const Color navy900 = Color(0xFF0F2744);
  static const Color navy800 = Color(0xFF1E3A5F);
  static const Color navy700 = Color(0xFF2C4F7C);

  // Gold accents
  static const Color gold400 = Color(0xFFF5C542);
  static const Color gold500 = Color(0xFFD4AF37);
  static const Color gold600 = Color(0xFFB8962E);

  // Surfaces & background
  static const Color background = Color(0xFFF0F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF7FAFC);

  // Text
  static const Color textPrimary = Color(0xFF0F2744);
  static const Color textSecondary = Color(0xFF52677D);
  static const Color textMuted = Color(0xFF8A9BB0);
  static const Color textOnDark = Color(0xFFF5F8FC);

  // Borders / dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF1F6);

  // Status
  static const Color success = Color(0xFF10B981); // emerald
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B); // amber
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444); // red
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6); // blue
  static const Color infoBg = Color(0xFFDBEAFE);

  // Metal accents
  static const Color goldMetal = Color(0xFFD4AF37);
  static const Color silverMetal = Color(0xFF9AA7B4);

  // Gradient used for hero / brand surfaces
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy900, navy800],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold400, gold600],
  );
}
