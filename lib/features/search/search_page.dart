import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/product.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/responsive_grid.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Start each visit with a clean query.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String query = ref.watch(searchQueryProvider);
    final List<Product> results = ref.watch(searchResultsProvider);
    final bool hasQuery = query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focus,
          autofocus: true,
          style: const TextStyle(color: AppColors.textOnDark),
          cursorColor: AppColors.gold400,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search name, SKU, category…',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textOnDark),
                    onPressed: () {
                      _controller.clear();
                      _onChanged('');
                      setState(() {});
                    },
                  ),
          ),
          onChanged: (String v) {
            setState(() {});
            _onChanged(v);
          },
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (!hasQuery) {
            return const EmptyState(
              icon: Icons.search,
              title: 'Search your inventory',
              subtitle:
                  'Find items by SKU, name, category, sub-category or metal. Exact SKU matches appear first.',
            );
          }
          if (results.isEmpty) {
            return EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results for "$query"',
              subtitle:
                  'Try a different keyword, a partial SKU, or a category name like "Ring" or "Necklace".',
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Text(
                  '${results.length} result${results.length == 1 ? '' : 's'} for "$query"',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              Expanded(
                child: ProductGrid(
                  products: results,
                  onTap: (Product p) => context.push(Routes.product(p.id)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
