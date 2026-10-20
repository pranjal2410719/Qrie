import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.school_rounded, label: 'LEARN'),
      _NavItem(icon: Icons.track_changes_rounded, label: 'PRACTICE'),
      _NavItem(icon: Icons.psychology_rounded, label: 'ASK QRIE'),
      _NavItem(icon: Icons.menu_book_rounded, label: 'LIBRARY'),
      _NavItem(icon: Icons.military_tech_rounded, label: 'BADGES'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paperWhite,
        border: Border(
          top: BorderSide(color: AppColors.lineGray, width: 2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = (index == currentIndex);
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.storybookGreen.withValues(alpha: 0.5) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: AppColors.eagerGreen.withValues(alpha: 0.4), width: 1.5)
                              : null,
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isSelected ? AppColors.eagerGreen : AppColors.fadedGray,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.navLabel(
                          color: isSelected ? AppColors.eagerGreen : AppColors.fadedGray,
                        ).copyWith(fontSize: 10),
                      ),
                    ],
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
  final String label;

  const _NavItem({required this.icon, required this.label});
}
