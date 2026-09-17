import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/services/user_persistence_service.dart';

enum AppNavTab { jaap, library, panchang, profile }

class AppBottomNav extends StatelessWidget {
  final AppNavTab currentTab;

  const AppBottomNav({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
                tab: AppNavTab.jaap,
                icon: Icons.filter_1_rounded,
                label: 'Jaap',
                onTap: () async {
                  final isLoggedIn = await UserPersistenceService.isLoggedIn();
                  if (!context.mounted) return;
                  if (isLoggedIn) {
                    context.go('/naam-jaap');
                  } else {
                    context.go('/jaap-intro');
                  }
                },
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.library,
                icon: Icons.menu_book_rounded,
                label: 'Library',
                onTap: () => context.go('/library'),
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.panchang,
                icon: Icons.calendar_month_outlined,
                label: 'Panchang',
                onTap: () => context.go('/home'),
                activePillBg: activePillBg,
                activeTextColor: activeTextColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context: context,
                tab: AppNavTab.profile,
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                onTap: () => context.go('/profile'),
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
    required VoidCallback onTap,
    required Color activePillBg,
    required Color activeTextColor,
    required Color inactiveColor,
  }) {
    final isActive = currentTab == tab;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          onTap();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? activePillBg : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: isActive ? activeTextColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? activeTextColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
