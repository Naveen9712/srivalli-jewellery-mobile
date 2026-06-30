import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants/constants.dart';
import '../core/theme/app_colors.dart';

/// Maps a category to a representative icon (used as a graceful fallback when
/// no artwork asset is present).
IconData iconForCategory(String category) {
  switch (category) {
    case 'Ring':
      return Icons.ring_volume_outlined;
    case 'Necklace':
      return Icons.diamond_outlined;
    case 'Bangle':
      return Icons.circle_outlined;
    case 'Chain':
      return Icons.link_rounded;
    case 'Earring':
      return Icons.spa_outlined;
    case 'Pendant':
      return Icons.bookmark_border_rounded;
    case 'Bracelet':
      return Icons.watch_outlined;
    case 'Anklet':
      return Icons.waves_rounded;
    case 'Coin':
      return Icons.monetization_on_outlined;
    default:
      return Icons.auto_awesome_outlined;
  }
}

/// Shows the per-category placeholder asset if it exists, otherwise a styled
/// gradient + icon. Never throws on a missing asset.
class CategoryImage extends StatelessWidget {
  const CategoryImage({
    super.key,
    required this.category,
    this.fit = BoxFit.cover,
  });

  final String category;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppData.categoryAsset(category),
      fit: fit,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          _fallback(),
    );
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.goldGradient),
      child: Center(
        child: Icon(
          iconForCategory(category),
          size: 42,
          color: Colors.white.withValues(alpha: 0.92),
        ),
      ),
    );
  }
}

/// Resolves a product's display image: stored file -> category fallback.
class ProductThumb extends StatelessWidget {
  const ProductThumb({
    super.key,
    required this.imagePath,
    required this.category,
    this.fit = BoxFit.cover,
  });

  final String? imagePath;
  final String category;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;
    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (_, __, ___) => CategoryImage(category: category, fit: fit),
      );
    }
    return CategoryImage(category: category, fit: fit);
  }
}
