import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppNavTab { jaap, library, panchang, profile }

class AppBottomNav extends StatelessWidget {
  final AppNavTab currentTab;

  const AppBottomNav({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const Color activePillBg = Color(0xFFFBE4DC);
    const Color activeTextColor = Color(0xFF2E2428);
    const Color inactiveColor = Color(0xFF8A8287);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                tab: AppNavTab.jaap,
                icon: Icons.filter_1_rounded,
                label: 'Jaap',
                route: '/naam-jaap',
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.library,
                icon: Icons.menu_book_rounded,
                label: 'Library',
                route: '/amrit-vachan',
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.panchang,
                icon: Icons.calendar_month_outlined,
                label: 'Panchang',
                route: '/home',
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.profile,
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                route: '/profile',
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required AppNavTab tab,
    required IconData icon,
    required String label,
    required String route,
    required Color activePillBg,
    required Color activeTextColor,
    required Color inactiveColor,
  }) {
    final isActive = currentTab == tab;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activePillBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? activeTextColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeTextColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
