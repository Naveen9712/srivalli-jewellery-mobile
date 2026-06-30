import 'package:flutter/material.dart';

import '../data/models/product.dart';
import 'product_card.dart';

/// Responsive grid of [ProductCard]s with shared callbacks.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.footerBuilder,
    this.itemExtent,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
  });

  final List<Product> products;
  final void Function(Product product)? onTap;
  final void Function(Product product)? onEdit;
  final void Function(Product product)? onDelete;
  final Widget Function(Product product)? footerBuilder;

  /// Fixed pixel height per card. Defaults to 290 (or 360 when a footer is set).
  final double? itemExtent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final double extent =
        itemExtent ?? (footerBuilder != null ? 360 : 290);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double w = constraints.maxWidth;
        final int columns = w >= 1100
            ? 4
            : w >= 800
                ? 3
                : 2;
        return GridView.builder(
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: extent,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final Product p = products[index];
            return ProductCard(
              product: p,
              onTap: onTap == null ? null : () => onTap!(p),
              onEdit: onEdit == null ? null : () => onEdit!(p),
              onDelete: onDelete == null ? null : () => onDelete!(p),
              footer: footerBuilder?.call(p),
            );
          },
        );
      },
    );
  }
}
