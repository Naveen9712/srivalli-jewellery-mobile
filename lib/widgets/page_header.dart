import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'gradient_button.dart';

/// A breadcrumb entry: a label and an optional tap target.
class Crumb {
  const Crumb(this.label, {this.onTap});
  final String label;
  final VoidCallback? onTap;
}

/// Standard page header: optional breadcrumb, display-font title, subtitle and
/// an optional trailing gold action button.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
  });

  final String title;
  final String? subtitle;
  final List<Crumb>? breadcrumbs;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...<Widget>[
            _Breadcrumbs(crumbs: breadcrumbs!),
            const SizedBox(height: 10),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: AppTextStyles.displayMedium),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: AppTextStyles.bodyMedium),
                    ],
                  ],
                ),
              ),
              if (actionLabel != null && onAction != null) ...<Widget>[
                const SizedBox(width: 12),
                GradientButton(
                  label: actionLabel!,
                  icon: actionIcon ?? Icons.add,
                  onPressed: onAction,
                  height: 46,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.crumbs});
  final List<Crumb> crumbs;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < crumbs.length; i++) {
      final Crumb c = crumbs[i];
      final bool isLast = i == crumbs.length - 1;
      children.add(
        InkWell(
          onTap: c.onTap,
          child: Text(
            c.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isLast ? AppColors.navy800 : AppColors.textMuted,
              fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      );
      if (!isLast) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
        ));
      }
    }
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children);
  }
}
