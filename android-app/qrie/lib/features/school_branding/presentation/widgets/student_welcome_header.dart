import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../models/school_branding_config.dart';
import 'school_logo.dart';

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
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Official School Logo
              SchoolLogo(
                logoUrl: branding.logoUrl,
                size: 36,
                borderColor: branding.primaryColor.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 8),

              // School & Student identity (Auto-shrinks to available width)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      branding.schoolName,
                      style: AppTypography.buttonLabel(color: branding.primaryColor).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    GestureDetector(
                      onTap: onGradeTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              gradeAndBoard.toUpperCase(),
                              style: AppTypography.caption(color: AppColors.charcoal).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: AppColors.pencilGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Streak Pill (Material Icon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 15,
                      color: AppColors.fireOrange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$streakDays',
                      style: AppTypography.buttonLabel(color: AppColors.fireOrange).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              // XP / Mastery Pill (Material Icon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.diamond_rounded,
                      size: 14,
                      color: AppColors.sparkBlue,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$gems',
                      style: AppTypography.buttonLabel(color: AppColors.sparkBlue).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Student Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: branding.secondaryColor,
                    border: Border.all(color: branding.primaryColor, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      studentName.isNotEmpty ? studentName[0].toUpperCase() : 'A',
                      style: TextStyle(
                        color: branding.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
