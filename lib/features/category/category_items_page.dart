import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/constants.dart';
import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../data/models/product.dart';
import '../../widgets/category_image.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import '../../widgets/responsive_grid.dart';

class CategoryItemsPage extends ConsumerWidget {
  const CategoryItemsPage({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Unknown category -> redirect to dashboard.
    if (!AppData.categories.contains(categoryName)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(Routes.dashboard);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final List<Product> products =
        ref.watch(productsByCategoryProvider(categoryName));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            onPressed: () => context.push(Routes.search),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          PageHeader(
            title: categoryName,
            subtitle:
                '${products.length} saved item${products.length == 1 ? '' : 's'}',
            breadcrumbs: <Crumb>[
              Crumb('Dashboard', onTap: () => context.go(Routes.dashboard)),
              Crumb(categoryName),
            ],
            actionLabel: 'Add Item',
            onAction: () =>
                context.push('${Routes.stocksAdd}?category=$categoryName'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.go(Routes.dashboard),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to categories'),
              ),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? EmptyState(
                    illustration: SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CategoryImage(category: categoryName),
                      ),
                    ),
                    icon: iconForCategory(categoryName),
                    title: 'No $categoryName items yet',
                    subtitle: 'Add your first $categoryName to this category.',
                    ctaLabel: 'Add $categoryName item',
                    onCta: () =>
                        context.push('${Routes.stocksAdd}?category=$categoryName'),
                  )
                : ProductGrid(
                    products: products,
                    onTap: (Product p) => context.push(Routes.product(p.id)),
                    onEdit: (Product p) =>
                        context.push(Routes.stocksEdit(p.id)),
                    onDelete: (Product p) => _confirmDelete(context, ref, p),
                  ),
          ),
        ],
      ),
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
