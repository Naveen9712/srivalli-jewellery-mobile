import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';
import '../data/models/product.dart';
import 'category_image.dart';

/// Card representing a product: image (Hero), category chip, gold mono SKU,
/// name, carat/metal badges and selling price. Press-to-scale feedback.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.footer,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Optional extra widget shown at the bottom (e.g. "Deleted ..." label).
  final Widget? footer;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final Product p = widget.product;
    final bool hasPrice = (p.sellingPrice ?? 0) > 0;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppColors.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A0F2744),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Hero(
                      tag: 'product-${p.id}',
                      child: ProductThumb(
                        imagePath: p.imagePath,
                        category: p.category,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Chip(
                      label: p.category,
                      bg: AppColors.navy900.withValues(alpha: 0.78),
                      fg: AppColors.textOnDark,
                    ),
                  ),
                  if (widget.onEdit != null || widget.onDelete != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _MenuButton(
                        onEdit: widget.onEdit,
                        onDelete: widget.onDelete,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      p.uniqueId,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold600,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        _Badge(label: p.carat, color: AppColors.gold600),
                        _Badge(
                          label: p.metalType,
                          color: p.metalType == 'Silver'
                              ? AppColors.silverMetal
                              : AppColors.goldMetal,
                        ),
                      ],
                    ),
                    if (hasPrice) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        formatCurrency(p.sellingPrice!),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.navy900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if (widget.footer != null) ...<Widget>[
                      const SizedBox(height: 10),
                      widget.footer!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({this.onEdit, this.onDelete});
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 18, color: AppColors.navy900),
        padding: EdgeInsets.zero,
        onSelected: (String v) {
          if (v == 'edit') onEdit?.call();
          if (v == 'delete') onDelete?.call();
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          if (onEdit != null)
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.edit_outlined, size: 18),
                title: Text('Edit'),
              ),
            ),
          if (onDelete != null)
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete_outline,
                    size: 18, color: AppColors.danger),
                title: Text('Delete'),
              ),
            ),
        ],
      ),
    );
  }
}
