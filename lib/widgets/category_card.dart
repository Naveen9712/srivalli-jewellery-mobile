import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';
import 'category_image.dart';

/// Category tile: image with navy gradient overlay, Playfair name and a
/// count badge in the top-right corner.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.itemCount,
    this.onTap,
  });

  final String category;
  final int itemCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1.05,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CategoryImage(category: category),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0x110F2744),
                      Color(0xCC0F2744),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$itemCount',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.navy900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Text(
                  category,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textOnDark,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
