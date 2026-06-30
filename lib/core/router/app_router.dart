import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/category/category_items_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/deleted/deleted_items_page.dart';
import '../../features/product/product_details_page.dart';
import '../../features/search/search_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/stock/add_edit_product_page.dart';
import '../../features/stock/stock_list_page.dart';
import '../../widgets/app_scaffold.dart';

/// Route paths in one place.
class Routes {
  Routes._();

  static const String dashboard = '/';
  static const String stocks = '/stocks';
  static const String stocksAdd = '/stocks/add';
  static const String deleted = '/deleted';
  static const String search = '/search';
  static const String settings = '/settings';

  static String category(String name) => '/category/${Uri.encodeComponent(name)}';
  static String stocksEdit(String id) => '/stocks/edit/$id';
  static String product(String id) => '/product/$id';
}

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: Routes.dashboard,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppScaffold(location: state.uri.path, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.dashboard,
          pageBuilder: (context, state) =>
              const NoTransitionPage<void>(child: DashboardPage()),
        ),
        GoRoute(
          path: Routes.stocks,
          pageBuilder: (context, state) =>
              const NoTransitionPage<void>(child: StockListPage()),
        ),
        GoRoute(
          path: Routes.deleted,
          pageBuilder: (context, state) =>
              const NoTransitionPage<void>(child: DeletedItemsPage()),
        ),
        GoRoute(
          path: Routes.settings,
          pageBuilder: (context, state) =>
              const NoTransitionPage<void>(child: SettingsPage()),
        ),
      ],
    ),

    // Full-screen routes (own app bars / back navigation).
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/stocks/add',
      builder: (context, state) => AddEditProductPage(
        initialCategory: state.uri.queryParameters['category'],
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/stocks/edit/:id',
      builder: (context, state) =>
          AddEditProductPage(productId: state.pathParameters['id']),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/category/:name',
      builder: (context, state) => CategoryItemsPage(
        categoryName:
            Uri.decodeComponent(state.pathParameters['name'] ?? ''),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/product/:id',
      builder: (context, state) =>
          ProductDetailsPage(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: Routes.search,
      builder: (context, state) => const SearchPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);
