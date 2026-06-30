import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../widgets/category_card.dart';
import '../../widgets/category_image.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/gradient_button.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Product? product = ref.watch(productByIdProvider(productId));

    if (product == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(Routes.stocks);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final bool deleted = product.isDeleted;
    final bool hasPrice = (product.sellingPrice ?? 0) > 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name, overflow: TextOverflow.ellipsis),
          actions: <Widget>[
            if (!deleted)
              IconButton(
                tooltip: 'Edit',
                onPressed: () => context.push(Routes.stocksEdit(product.id)),
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: <Widget>[
            // Image
            Hero(
              tag: 'product-${product.id}',
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: ProductThumb(
                  imagePath: product.imagePath,
                  category: product.category,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Breadcrumb(product: product),
                  const SizedBox(height: 12),
                  Text(product.category, style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  Text(product.name, style: AppTextStyles.displayMedium),
                  const SizedBox(height: 6),
                  Text(
                    product.uniqueId,
                    style: GoogleFonts.robotoMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold600,
                    ),
                  ),
                  if (hasPrice) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(product.sellingPrice!),
                      style: AppTextStyles.numberLarge,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _StatusBadge(product: product),
                      _Badge(label: product.carat, color: AppColors.gold600),
                      _Badge(
                        label: product.metalType,
                        color: product.metalType == 'Silver'
                            ? AppColors.silverMetal
                            : AppColors.goldMetal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _QuickFacts(product: product),
                  const SizedBox(height: 16),
                  _Actions(product: product),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const TabBar(
              labelColor: AppColors.navy900,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.gold500,
              tabs: <Widget>[
                Tab(text: 'Additional information'),
                Tab(text: 'Overview'),
              ],
            ),
            SizedBox(
              height: 520,
              child: TabBarView(
                children: <Widget>[
                  _AdditionalInfo(product: product),
                  _Overview(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () => context.go(Routes.dashboard),
          child: Text('Dashboard',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMuted)),
        ),
        const _Sep(),
        InkWell(
          onTap: () => context.push(Routes.category(product.category)),
          child: Text(product.category,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMuted)),
        ),
        const _Sep(),
        Text(product.name,
            style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.navy800, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
      );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final Color bg;
    late final String label;
    if (product.isDeleted) {
      color = AppColors.danger;
      bg = AppColors.dangerBg;
      label = 'Deleted';
    } else if (product.isLowStock) {
      color = AppColors.warning;
      bg = AppColors.warningBg;
      label = 'Low Stock';
    } else {
      color = AppColors.success;
      bg = AppColors.successBg;
      label = 'In Stock';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: AppTextStyles.bodySmall
              .copyWith(color: color, fontWeight: FontWeight.w700)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
    );
  }
}

class _QuickFacts extends StatelessWidget {
  const _QuickFacts({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final List<List<String>> facts = <List<String>>[
      <String>['Sub-category', product.subCategory ?? '—'],
      <String>['Weight', formatWeight(product.netWeight)],
      <String>['Quantity', '${product.quantity}'],
      <String>['Date added', formatDate(product.createdAt)],
      if (product.deletedAt != null)
        <String>['Deleted on', formatDate(product.deletedAt!)],
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 14,
        children: <Widget>[
          for (final List<String> f in facts)
            SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(f[0], style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(f[1],
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product.isDeleted) {
      return Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GradientButton(
              label: 'View deleted items',
              icon: Icons.delete_outline,
              expand: true,
              onPressed: () => context.go(Routes.deleted),
            ),
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            onPressed: () async {
              final bool ok = await showConfirmDialog(
                context,
                title: 'Move to Deleted Items?',
                message: 'Move "${product.name}" to Deleted Items?',
                confirmLabel: 'Move',
                destructive: true,
              );
              if (ok) {
                await ref.read(productRepositoryProvider).softDelete(product.id);
                if (context.mounted) context.go(Routes.stocks);
              }
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
          ),
        ),
      ],
    );
  }
}

class _AdditionalInfo extends StatelessWidget {
  const _AdditionalInfo({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final Map<String, String?> rows = <String, String?>{
      'SKU / Unique No.': product.uniqueId,
      'Name': product.name,
      'Category': product.category,
      'Sub-category': product.subCategory,
      'Metal type': product.metalType,
      'Carat': product.carat,
      'Gross weight': product.grossWeight == null
          ? null
          : formatWeight(product.grossWeight!),
      'Net weight': formatWeight(product.netWeight),
      'Stone weight': product.stoneWeight == null
          ? null
          : formatWeight(product.stoneWeight!),
      'Wastage %': product.wastage?.toString(),
      'Making charges': product.makingCharges == null
          ? null
          : formatCurrency(product.makingCharges!),
      'Purchase price': product.purchasePrice == null
          ? null
          : formatCurrency(product.purchasePrice!),
      'Selling price': product.sellingPrice == null
          ? null
          : formatCurrency(product.sellingPrice!),
      'Quantity': '${product.quantity}',
      'HUID': product.huid,
      'Design code': product.designCode,
      'Vendor': product.vendor,
      'Status': product.status,
      'Created': formatLongDate(product.createdAt),
      'Updated': product.updatedAt == null
          ? null
          : formatLongDate(product.updatedAt!),
      'Deleted': product.deletedAt == null
          ? null
          : formatLongDate(product.deletedAt!),
    };
    final List<MapEntry<String, String?>> populated = rows.entries
        .where((MapEntry<String, String?> e) =>
            e.value != null && e.value!.trim().isNotEmpty)
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: populated.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final MapEntry<String, String?> e = populated[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text(e.key, style: AppTextStyles.bodyMedium),
              ),
              Expanded(
                child: Text(e.value!,
                    style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = ref.watch(categoryCountProvider(product.category));
    final String stockPhrase = product.isDeleted
        ? 'currently in Deleted Items'
        : 'in stock since ${formatDate(product.createdAt)}';
    final String sub =
        product.subCategory != null ? '${product.subCategory} ' : '';
    final String line =
        '${product.carat} ${product.metalType} $sub${product.category} '
        'weighing ${formatWeight(product.netWeight)}, $stockPhrase.';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.auto_awesome, color: AppColors.gold600),
              const SizedBox(width: 10),
              Expanded(
                child: Text(line,
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.4)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Category', style: AppTextStyles.label),
        const SizedBox(height: 8),
        SizedBox(
          width: 170,
          child: CategoryCard(
            category: product.category,
            itemCount: count,
            onTap: () => context.push(Routes.category(product.category)),
          ),
        ),
      ],
    );
  }
}
