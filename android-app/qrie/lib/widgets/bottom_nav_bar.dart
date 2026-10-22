import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Floating, Detached Bottom Navigation Bar
/// Follows the EdTech "Pastel Bento & Onyx" Design System.
///
/// Features:
/// - Detached, floating rounded container with consistent padding and soft elevation.
/// - Clear separation from screen edges and safe area handling.
/// - Restrained smooth selection transitions with subtle scale & pill highlight.
/// - Automatic keyboard avoidance to prevent overlap.
/// - Destinations:
///   1. Home (renamed from Learn)
///   2. Learn (syllabus & library, replacing old Practice)
///   3. Library
///   4. Profile
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Hide floating bar if software keyboard is open
    if (MediaQuery.of(context).viewInsets.bottom > 50) {
      return const SizedBox.shrink();
    }

    const activeColor = AppColors.bgSurfaceOnyx;
    const activeAccent = AppColors.accentCobalt;
    const inactiveColor = AppColors.textMuted;

    final items = const [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
      ),
      _NavItem(
        icon: Icons.auto_stories_outlined,
        activeIcon: Icons.auto_stories_rounded,
        label: 'Learn',
      ),
      _NavItem(
        icon: Icons.collections_bookmark_outlined,
        activeIcon: Icons.collections_bookmark_rounded,
        label: 'Library',
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    final bottomPadding = math.max(MediaQuery.paddingOf(context).bottom, 10.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, bottomPadding),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0x140D110D), // 8% subtle hairline
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: Semantics(
                button: true,
                selected: isSelected,
                label: item.label,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.bgSurfaceSoft
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 21,
                              color: isSelected ? activeColor : inactiveColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              fontFamily: AppTypography.primaryFont,
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? activeColor : inactiveColor,
                              letterSpacing: -0.1,
                              height: 1.1,
                            ),
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: isSelected ? 4 : 0,
                            height: 2,
                            decoration: BoxDecoration(
                              color: isSelected ? activeAccent : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
