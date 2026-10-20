import 'dart:async';

import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../features/school_branding/models/school_branding_config.dart';
import '../features/school_branding/presentation/widgets/school_logo.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartCtrl;
  late List<Animation<double>> _barAnimations;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();

    _chartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _barAnimations = List.generate(7, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _chartCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _startTimer = Timer(const Duration(milliseconds: 280), () {
      if (mounted) _chartCtrl.forward();
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _chartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final dpsBranding = SchoolBrandingConfig.dpsDefault();

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.horizontalPadding, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Student Identity Card — Onyx surface, radius 28
            _buildIdentityCard(profile, dpsBranding),

            const SizedBox(height: 20),

            // 2. 2×2 Bento Metric Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'DAY STREAK',
                    value: '${profile.streakDays}',
                    unit: 'days',
                    icon: Icons.local_fire_department_rounded,
                    iconBgColor: AppColors.accentAmber.withValues(alpha: 0.15),
                    iconColor: AppColors.accentAmber,
                  ),
                ),
                const SizedBox(width: DesignTokens.bentoGridGap),
                Expanded(
                  child: _buildMetricCard(
                    title: 'TOTAL XP',
                    value: '${profile.totalXp}',
                    unit: 'points',
                    icon: Icons.bolt_rounded,
                    iconBgColor: AppColors.accentMustard.withValues(alpha: 0.18),
                    iconColor: AppColors.accentMustard,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.bentoGridGap),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'GEMS EARNED',
                    value: '${profile.gems}',
                    unit: 'gems',
                    icon: Icons.diamond_rounded,
                    iconBgColor: AppColors.accentPeriwinkle.withValues(alpha: 0.18),
                    iconColor: AppColors.accentCobalt,
                  ),
                ),
                const SizedBox(width: DesignTokens.bentoGridGap),
                Expanded(
                  child: _buildMetricCard(
                    title: 'LESSONS DONE',
                    value: '${profile.completedLessonIds.length}',
                    unit: 'lessons',
                    icon: Icons.task_alt_rounded,
                    iconBgColor: AppColors.accentMint.withValues(alpha: 0.15),
                    iconColor: AppColors.accentMint,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Weekly Study Activity
            Text('Weekly Study Activity', style: AppTypography.sectionHeader()),
            const SizedBox(height: 12),
            _buildActivityChart(),

            const SizedBox(height: 24),

            // 4. Badges & Achievements
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Academic Badges',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.sectionHeader(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${MockData.badges.where((b) => b['unlocked'] == true).length} of ${MockData.badges.length} Unlocked',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTypography.caption(color: AppColors.accentCobalt)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: DesignTokens.bentoGridGap,
                crossAxisSpacing: DesignTokens.bentoGridGap,
                childAspectRatio: 1.0,
              ),
              itemCount: MockData.badges.length,
              itemBuilder: (context, index) {
                final badge = MockData.badges[index];
                final isUnlocked = badge['unlocked'] as bool;

                return AppCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: DesignTokens.radiusCardMd,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppColors.accentMint.withValues(alpha: 0.18)
                              : AppColors.bgSurfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnlocked
                              ? (badge['icon'] as IconData)
                              : Icons.lock_outline_rounded,
                          color: isUnlocked
                              ? AppColors.accentMint
                              : AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        badge['name'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subheading(
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ).copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge['description'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption(color: AppColors.textMuted)
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 5. School Credentials Card — bgSurfaceMuted
            AppCard(
              padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
              backgroundColor: AppColors.bgSurfaceMuted,
              borderRadius: DesignTokens.radiusCardMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: AppColors.accentCobalt, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SCHOOL ORGANIZATION CREDENTIALS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption(
                                  color: AppColors.accentCobalt)
                              .copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCredentialRow(
                      'Institution', 'Delhi Public School, R.K. Puram'),
                  _buildCredentialRow('School Code', 'DPS-RKP-042'),
                  _buildCredentialRow('Official Motto', 'Service Before Self'),
                  _buildCredentialRow(
                      'Affiliation', 'CBSE Board Affiliation #2730017'),
                  _buildCredentialRow(
                      'Offline Mode', 'SQLite Outbox Active & Sync Ready'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 6. Change Grade CTA — full-width onyx pill
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tap the grade badge in the top app bar to personalize your syllabus anytime.',
                      style: AppTypography.bodySmall(color: Colors.white),
                    ),
                    backgroundColor: AppColors.bgSurfaceOnyx,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceOnyx,
                  borderRadius: BorderRadius.circular(9999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.tune_rounded,
                        color: AppColors.accentCobalt, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Change Grade & Syllabus',
                        style: AppTypography.buttonLabel(color: AppColors.textOnOnyx)
                            .copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Identity Card (Onyx) ────────────────────────────────────────────
  Widget _buildIdentityCard(dynamic profile, SchoolBrandingConfig dpsBranding) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceOnyx,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
      ),
      child: Row(
        children: [
          SchoolLogo(
            logoUrl: dpsBranding.logoUrl,
            size: 60,
            borderColor: AppColors.accentCobalt.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name as String,
                  style: AppTypography.headingExtraSmall(
                      color: AppColors.textOnOnyx),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Cobalt grade badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentCobalt,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    '${profile.grade} • ${profile.board} Curriculum',
                    style: AppTypography.caption(color: AppColors.textOnOnyx)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Delhi Public School, R.K. Puram • Scholar Level 4',
                  style: AppTypography.caption(
                      color: AppColors.textOnOnyxMuted),
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

  // ── Metric Bento Card ───────────────────────────────────────────────
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.metricHero(color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: AppTypography.caption(color: AppColors.textMuted)
                .copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Weekly Activity Chart ───────────────────────────────────────────
  Widget _buildActivityChart() {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      hasShadow: true,
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '14.6 HOURS THIS WEEK',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption(color: AppColors.textMuted)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Avg 2.1 hrs/day',
                style: AppTypography.caption(color: AppColors.accentCobalt)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _chartCtrl,
            builder: (_, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final hours = MockData.weeklyStudyHours[index];
                  final day = MockData.weekDays[index];
                  const maxHeight = 75.0;
                  final heightFactor = (hours / 4.0).clamp(0.18, 1.0);
                  final targetH = maxHeight * heightFactor;
                  final animatedH = targetH * _barAnimations[index].value;
                  final isToday = (index == 5);

                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _barAnimations[index].value,
                          child: Text(
                            '${hours}h',
                            style: AppTypography.caption(color: AppColors.textMuted)
                                .copyWith(fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 18,
                          height: animatedH,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppColors.accentCobalt
                                : AppColors.accentPeriwinkle.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day,
                          style: AppTypography.caption(
                            color: isToday
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ).copyWith(
                            fontWeight: isToday
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
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
          Text(label,
              style: AppTypography.caption(color: AppColors.textMuted)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodySmall(color: AppColors.textPrimary)
                  .copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
