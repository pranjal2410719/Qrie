import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Ultra-Minimalist & Smooth Bottom Navigation Bar
/// Follows the EdTech "Pastel Bento & Onyx" Design System.
///
/// Features:
/// - Pure white surface with ultra-subtle top hairline divider.
/// - Smooth animated selection pill with light haptic feedback.
/// - Scaled active iconography (Cobalt / Onyx) with clean typography.
/// - Unread notification badge for the AI Doubt Chat ("Ask Qrie").
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
    const activeColor = AppColors.bgSurfaceOnyx;
    const activeAccent = AppColors.accentCobalt;
    const inactiveColor = AppColors.textMuted;

    final items = const [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Learn',
      ),
      _NavItem(
        icon: Icons.track_changes_outlined,
        activeIcon: Icons.track_changes_rounded,
        label: 'Practice',
      ),
      _NavItem(
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
        label: 'Homework',
      ),
      _NavItem(
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book_rounded,
        label: 'Library',
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        border: Border(
          top: BorderSide(
            color: Color(0x0D0D110D), // ultra-subtle 5% hairline
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final showBadge = index == 2 && unreadCount > 0;

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
                        duration: const Duration(milliseconds: 220),
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
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                AnimatedScale(
                                  scale: isSelected ? 1.08 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutBack,
                                  child: Icon(
                                    isSelected ? item.activeIcon : item.icon,
                                    size: 21,
                                    color: isSelected ? activeColor : inactiveColor,
                                  ),
                                ),
                                if (showBadge)
                                  Positioned(
                                    top: -2,
                                    right: -5,
                                    child: Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentRose,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.bgCanvas,
                                          width: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              style: TextStyle(
                                fontFamily: AppTypography.primaryFont,
                                fontSize: 10,
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
                              duration: const Duration(milliseconds: 200),
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
