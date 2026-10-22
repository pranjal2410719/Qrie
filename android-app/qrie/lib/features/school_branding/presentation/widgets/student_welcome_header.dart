import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../../screens/calendar/calendar_screen.dart';
import '../../../../screens/notifications/notifications_screen.dart';
import '../../models/school_branding_config.dart';

/// Ultra-Minimalist & Smooth Top App Bar
/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
///
/// Features:
/// - Crisp, borderless aesthetic with subtle hairline bottom divider.
/// - 40×40 circular avatar with student initial and soft glow.
/// - Auto-fitting student greeting + Grade/Board dropdown selector.
/// - 38×38 rounded calendar icon button routing to dedicated CalendarScreen.
/// - 38×38 rounded notification icon button with unread badge routing to NotificationsScreen.
class StudentWelcomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final SchoolBrandingConfig branding;
  final String studentName;
  final String gradeAndBoard;
  final int streakDays;
  final int gems;
  final String? profileImageUrl;
  final VoidCallback? onGradeTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onNotificationTap;
  final int unreadNotificationsCount;

  const StudentWelcomeHeader({
    super.key,
    required this.branding,
    required this.studentName,
    required this.gradeAndBoard,
    this.streakDays = 5,
    this.gems = 180,
    this.profileImageUrl = 'assets/default_icon.png',
    this.onGradeTap,
    this.onProfileTap,
    this.onCalendarTap,
    this.onNotificationTap,
    this.unreadNotificationsCount = 0,
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
              // ── 40x40 circular profile avatar with image ───────────────
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onProfileTap?.call();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: branding.primaryColor.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              studentName.isNotEmpty
                                  ? studentName[0].toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          profileImageUrl ?? 'assets/default_icon.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ],
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

              // ── 38x38 Clean Academic Calendar Button (In place of streak pill) ──
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
                  tooltip: 'Academic Calendar',
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    size: 20,
                    color: AppColors.accentCobalt,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onCalendarTap != null) {
                      onCalendarTap!.call();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CalendarScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(width: 8),

              // ── 38x38 Clean Notification Button with Dynamic Unread Badge ────
              Stack(
                clipBehavior: Clip.none,
                children: [
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
                      tooltip: 'Notifications',
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        if (onNotificationTap != null) {
                          onNotificationTap!.call();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  if (unreadNotificationsCount > 0)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          color: AppColors.accentRose,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
