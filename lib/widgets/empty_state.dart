import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'gradient_button.dart';

/// Centered empty-state with icon, title, subtitle and an optional CTA.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.ctaLabel,
    this.onCta,
    this.ctaIcon,
    this.illustration,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final IconData? ctaIcon;

  /// Optional custom illustration shown instead of the default icon badge.
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            illustration ??
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.navy900.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 42, color: AppColors.navy800),
                ),
            const SizedBox(height: 22),
            Text(title,
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (ctaLabel != null && onCta != null) ...<Widget>[
              const SizedBox(height: 22),
              GradientButton(
                label: ctaLabel!,
                icon: ctaIcon ?? Icons.add,
                onPressed: onCta,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
