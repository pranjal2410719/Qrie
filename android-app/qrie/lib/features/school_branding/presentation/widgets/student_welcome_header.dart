import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../models/school_branding_config.dart';

/// Ultra-Minimalist & Smooth Top App Bar
/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
///
/// Features:
/// - Crisp, borderless aesthetic with subtle hairline bottom divider.
/// - 40×40 circular avatar with student initial and soft glow.
/// - Auto-fitting student greeting + Grade/Board dropdown selector.
/// - Sleek compact streak indicator pill (flame + count).
/// - 38×38 rounded notification icon button with smooth feedback.
class StudentWelcomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final SchoolBrandingConfig branding;
  final String studentName;
  final String gradeAndBoard;
  final int streakDays;
  final int gems;
  final VoidCallback? onGradeTap;
  final VoidCallback? onProfileTap;

  const StudentWelcomeHeader({
    super.key,
    required this.branding,
    required this.studentName,
    required this.gradeAndBoard,
    this.streakDays = 5,
    this.gems = 180,
    this.onGradeTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final firstName = studentName.trim().split(' ').first;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        border: Border(
          bottom: BorderSide(
            color: Color(0x0D0D110D), // ultra-subtle hairline
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── 40x40 circular avatar with soft gradient ───────────────
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onProfileTap?.call();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      studentName.isNotEmpty
                          ? studentName[0].toUpperCase()
                          : 'R',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Minimalist Greeting + Grade Subtitle (Fitted to avoid overflows) ─
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hi, $firstName',
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onGradeTap?.call();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gradeAndBoard.isNotEmpty
                                  ? gradeAndBoard
                                  : 'Class 10 CBSE',
                              style: TextStyle(
                                fontFamily: AppTypography.primaryFont,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ── Minimalist Streak Pill ───────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentAmber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: AppColors.accentAmber,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$streakDays',
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        color: AppColors.accentAmber,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ── 38x38 Clean Notification Button ──────────────────────────
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.bgSurfaceSoft,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    size: 19,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You are all caught up!',
                          style: AppTypography.bodySmall(color: Colors.white),
                        ),
                        backgroundColor: AppColors.bgSurfaceOnyx,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
