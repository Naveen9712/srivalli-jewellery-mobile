import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';

/// A button with a gold gradient background (Flutter buttons don't support
/// gradients natively, so we wrap an [Ink] + [InkWell]).
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient = AppColors.goldGradient,
    this.foreground = AppColors.navy900,
    this.expand = false,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final Color foreground;
  final bool expand;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;
    final Widget button = Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Ink(
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x33D4AF37),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 18, color: foreground),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
