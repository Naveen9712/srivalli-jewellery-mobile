import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/constants.dart';
import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/rates.dart';
import '../../widgets/category_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Rates? rates = ref.watch(ratesProvider);
    final int totalItems = ref.watch(totalItemCountProvider);
    ref.watch(productsTickProvider);

    if (totalItems == 0) {
      return Column(
        children: <Widget>[
          const PageHeader(
            title: 'Dashboard',
            subtitle: 'Browse categories and view your saved items',
          ),
          Expanded(
            child: EmptyState(
              icon: Icons.diamond_outlined,
              title: 'No items yet',
              subtitle:
                  'Start building your inventory by adding your first item.',
              ctaLabel: 'Add your first item',
              onCta: () => context.push(Routes.stocksAdd),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 600
                ? 3
                : 2;
        return CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: PageHeader(
                title: 'Dashboard',
                subtitle: 'Browse categories and view your saved items',
              ),
            ),
            if (rates != null)
              SliverToBoxAdapter(child: _RatesStrip(rates: rates)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      _CategoryTile(name: AppData.categories[index]),
                  childCount: AppData.categories.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = ref.watch(categoryCountProvider(name));
    return CategoryCard(
      category: name,
      itemCount: count,
      onTap: () => context.push(Routes.category(name)),
    );
  }
}

class _RatesStrip extends StatelessWidget {
  const _RatesStrip({required this.rates});
  final Rates rates;

  @override
  Widget build(BuildContext context) {
    final RateHistoryEntry? prev = rates.previous;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _RateCard(
              label: 'Gold 22K',
              value: rates.gold22k,
              previous: prev?.gold22k,
              accent: AppColors.gold600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _RateCard(
              label: 'Gold 24K',
              value: rates.gold24k,
              previous: null,
              accent: AppColors.gold500,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _RateCard(
              label: 'Silver 925',
              value: rates.silver925,
              previous: prev?.silver925,
              accent: AppColors.silverMetal,
            ),
          ),
        ],
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({
    required this.label,
    required this.value,
    required this.previous,
    required this.accent,
  });

  final String label;
  final double value;
  final double? previous;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final double? delta = previous == null ? null : value - previous!;
    final bool up = (delta ?? 0) > 0;
    final bool down = (delta ?? 0) < 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(width: 8, height: 8, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${formatCurrency(value)}/g',
              style: AppTextStyles.titleMedium,
            ),
          ),
          if (delta != null && delta != 0) ...<Widget>[
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Icon(
                  up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 13,
                  color: up ? AppColors.success : AppColors.danger,
                ),
                const SizedBox(width: 2),
                Text(
                  formatCurrency(delta.abs()),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: up
                        ? AppColors.success
                        : down
                            ? AppColors.danger
                            : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
