import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../features/school_branding/models/school_branding_config.dart';
import '../features/school_branding/presentation/widgets/school_logo.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final dpsBranding = SchoolBrandingConfig.dpsDefault();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Student Identity Card
            AppCard(
              padding: const EdgeInsets.all(18),
              hasShadow: true,
              child: Row(
                children: [
                  SchoolLogo(
                    logoUrl: dpsBranding.logoUrl,
                    size: 60,
                    borderColor: primaryColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: AppTypography.headingSmall(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.schoolMint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${profile.grade} • ${profile.board} Curriculum',
                            style: AppTypography.caption(color: primaryColor).copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delhi Public School, R.K. Puram • Scholar Level 4',
                          style: AppTypography.caption(color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2. 4-Metric Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'DAY STREAK',
                    value: '${profile.streakDays} Days',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricCard(
                    title: 'TOTAL XP',
                    value: '${profile.totalXp}',
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.schoolGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'GEMS EARNED',
                    value: '${profile.gems}',
                    icon: Icons.diamond_rounded,
                    iconColor: AppColors.info,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricCard(
                    title: 'LESSONS DONE',
                    value: '${profile.completedLessonIds.length}',
                    icon: Icons.task_alt_rounded,
                    iconColor: primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 3. Weekly Study Activity Chart
            Text('Weekly Study Activity', style: AppTypography.subheading()),
            const SizedBox(height: 10),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '14.6 HOURS THIS WEEK',
                        style: AppTypography.caption(color: AppColors.textMuted).copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Avg 2.1 hrs/day',
                        style: AppTypography.caption(color: primaryColor).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final hours = MockData.weeklyStudyHours[index];
                      final day = MockData.weekDays[index];
                      final heightFactor = (hours / 4.0).clamp(0.18, 1.0);
                      final isToday = (index == 5); // Saturday

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${hours}h',
                            style: AppTypography.caption(color: AppColors.textMuted).copyWith(fontSize: 10),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 20,
                            height: 75 * heightFactor,
                            decoration: BoxDecoration(
                              color: isToday ? primaryColor : AppColors.schoolMint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            day,
                            style: AppTypography.caption(
                              color: isToday ? AppColors.textPrimary : AppColors.textMuted,
                            ).copyWith(
                              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 4. Badges & Achievements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Academic Badges', style: AppTypography.subheading()),
                Text(
                  '${MockData.badges.where((b) => b['unlocked'] == true).length} of ${MockData.badges.length} Unlocked',
                  style: AppTypography.caption(color: primaryColor).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: MockData.badges.length,
              itemBuilder: (context, index) {
                final badge = MockData.badges[index];
                final isUnlocked = badge['unlocked'] as bool;
                final Color color = isUnlocked ? primaryColor : AppColors.textDisabled;

                return AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUnlocked ? AppColors.schoolMint : AppColors.surfaceSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnlocked ? (badge['icon'] as IconData) : Icons.lock_outline_rounded,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badge['name'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subheading(
                          color: isUnlocked ? AppColors.textPrimary : AppColors.textDisabled,
                        ).copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge['description'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption(color: AppColors.textMuted).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 22),

            // 5. School Organization & Credentials Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_rounded, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SCHOOL ORGANIZATION CREDENTIALS',
                        style: AppTypography.caption(color: primaryColor).copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCredentialRow('Institution', 'Delhi Public School, R.K. Puram'),
                  _buildCredentialRow('School Code', 'DPS-RKP-042'),
                  _buildCredentialRow('Official Motto', 'Service Before Self'),
                  _buildCredentialRow('Affiliation', 'CBSE Board Affiliation #2730017'),
                  _buildCredentialRow('Offline Mode', 'SQLite Outbox Active & Sync Ready'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 6. Grade Switcher Action
            AppButton(
              text: 'CHANGE GRADE & SYLLABUS',
              isFullWidth: true,
              variant: AppButtonVariant.outline,
              icon: Icons.tune_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tap the grade badge in the top app bar to personalize your syllabus anytime.',
                      style: AppTypography.bodySmall(color: Colors.white),
                    ),
                    backgroundColor: AppColors.textPrimary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.subheading(color: AppColors.textPrimary).copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: AppTypography.caption(color: AppColors.textMuted).copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption(color: AppColors.textMuted)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodySmall(color: AppColors.textPrimary).copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
