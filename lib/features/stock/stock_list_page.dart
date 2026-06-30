import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../data/models/product.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import '../../widgets/responsive_grid.dart';

class StockListPage extends ConsumerWidget {
  const StockListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Product> products = ref.watch(productsProvider);

    return Column(
      children: <Widget>[
        PageHeader(
          title: 'Stocks',
          subtitle:
              '${products.length} item${products.length == 1 ? '' : 's'} in stock',
          actionLabel: 'Add Item',
          onAction: () => context.push(Routes.stocksAdd),
        ),
        Expanded(
          child: products.isEmpty
              ? EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No items in stock',
                  subtitle: 'Add your first item to start tracking inventory.',
                  ctaLabel: 'Add Item',
                  onCta: () => context.push(Routes.stocksAdd),
                )
              : ProductGrid(
                  products: products,
                  onTap: (Product p) => context.push(Routes.product(p.id)),
                  onEdit: (Product p) => context.push(Routes.stocksEdit(p.id)),
                  onDelete: (Product p) => _confirmDelete(context, ref, p),
                ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Product p) async {
    final bool ok = await showConfirmDialog(
      context,
      title: 'Move to Deleted Items?',
      message: 'Move "${p.name}" to Deleted Items?',
      confirmLabel: 'Move',
      destructive: true,
    );
    if (ok) await ref.read(productRepositoryProvider).softDelete(p.id);
  }
}
