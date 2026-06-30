import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import '../../widgets/responsive_grid.dart';

class DeletedItemsPage extends ConsumerWidget {
  const DeletedItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Product> deleted = ref.watch(deletedProductsProvider);

    return Column(
      children: <Widget>[
        const PageHeader(
          title: 'Deleted Items',
          subtitle: 'Restore items or remove them permanently',
        ),
        Expanded(
          child: deleted.isEmpty
              ? const EmptyState(
                  icon: Icons.delete_outline,
                  title: 'No deleted items',
                  subtitle:
                      'Items you delete are moved here instead of being permanently removed, so you can restore them anytime.',
                )
              : ProductGrid(
                  products: deleted,
                  onTap: (Product p) => context.push(Routes.product(p.id)),
                  footerBuilder: (Product p) => _DeletedFooter(product: p),
                ),
        ),
      ],
    );
  }
}

class _DeletedFooter extends ConsumerWidget {
  const _DeletedFooter({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (product.deletedAt != null)
          Text(
            'Deleted ${formatDate(product.deletedAt!)}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
          ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: _MiniButton(
                icon: Icons.restore,
                label: 'Restore',
                color: AppColors.success,
                onTap: () =>
                    ref.read(productRepositoryProvider).restore(product.id),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniButton(
                icon: Icons.delete_forever,
                label: 'Delete',
                color: AppColors.danger,
                onTap: () async {
                  final bool ok = await showConfirmDialog(
                    context,
                    title: 'Delete permanently?',
                    message:
                        '"${product.name}" will be permanently removed. This cannot be undone.',
                    confirmLabel: 'Delete forever',
                    destructive: true,
                  );
                  if (ok) {
                    await ref
                        .read(productRepositoryProvider)
                        .permanentlyDelete(product.id);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 5),
              Text(label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
