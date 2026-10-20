import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../models/school_branding_config.dart';
import 'school_logo.dart';

class StudentWelcomeHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Official School Logo
            SchoolLogo(
              logoUrl: branding.logoUrl,
              size: 40,
              borderColor: branding.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 10),

            // School & Student identity
            Expanded(
              child: Column(
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
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: onGradeTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gradeAndBoard.toUpperCase(),
                          style: AppTypography.caption(color: AppColors.charcoal).copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
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

            const SizedBox(width: 8),

            // Streak Pill (Material Icon instead of emoji)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: AppColors.fireOrange,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$streakDays',
                    style: AppTypography.buttonLabel(color: AppColors.fireOrange).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // XP / Mastery Pill (Material Icon instead of emoji)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.diamond_rounded,
                    size: 15,
                    color: AppColors.sparkBlue,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$gems',
                    style: AppTypography.buttonLabel(color: AppColors.sparkBlue).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Student Profile Avatar
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 36,
                height: 36,
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
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
