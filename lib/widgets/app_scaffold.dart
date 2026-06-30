import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Persistent shell: branded app bar + bottom navigation for the 4 main tabs.
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const List<_Tab> _tabs = <_Tab>[
    _Tab(Routes.dashboard, Icons.dashboard_outlined, Icons.dashboard_rounded,
        'Dashboard'),
    _Tab(Routes.stocks, Icons.inventory_2_outlined, Icons.inventory_2_rounded,
        'Stocks'),
    _Tab(Routes.deleted, Icons.delete_outline, Icons.delete_rounded, 'Deleted'),
    _Tab(Routes.settings, Icons.settings_outlined, Icons.settings_rounded,
        'Settings'),
  ];

  int get _currentIndex {
    // Highlight the closest matching tab; default to Dashboard.
    if (location == Routes.dashboard) return 0;
    if (location.startsWith(Routes.stocks)) return 1;
    if (location.startsWith(Routes.deleted)) return 2;
    if (location.startsWith(Routes.settings)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BrandAppBar(),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int i) => context.go(_tabs[i].path),
            items: <BottomNavigationBarItem>[
              for (final _Tab t in _tabs)
                BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  activeIcon: Icon(t.activeIcon),
                  label: t.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _BrandAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 16,
      title: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'SJ',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.navy900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Srivalli Jewellers',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnDark,
                ),
              ),
              Text(
                'Jewellery Management',
                style: AppTextStyles.bodySmall
                    .copyWith(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          tooltip: 'Search',
          onPressed: () => context.push(Routes.search),
          icon: const Icon(Icons.search),
        ),
        _NotificationButton(onPressed: () => context.go(Routes.deleted)),
        IconButton(
          tooltip: 'Account',
          onPressed: () => context.go(Routes.settings),
          icon: const Icon(Icons.account_circle_outlined),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          tooltip: 'Notifications',
          onPressed: onPressed,
          icon: const Icon(Icons.notifications_outlined),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.navy900, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tab {
  const _Tab(this.path, this.icon, this.activeIcon, this.label);
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
