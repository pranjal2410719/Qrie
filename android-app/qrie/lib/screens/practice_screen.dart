import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import 'quiz_solver_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.horizontalPadding, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Practice Zone Header — Onyx card ────────────────────
            _buildPracticeHeader(),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── Daily Speed Challenge ────────────────────────────────
            _buildSpeedChallengeCard(context),

            const SizedBox(height: 28),

            // ── Subject Practice Sets ────────────────────────────────
            Text(
              'Subject Practice Sets',
              style: AppTypography.sectionHeader(),
            ),
            const SizedBox(height: 14),

            ...MockData.subjects.map((sub) =>
                _buildSubjectPracticeCard(context, sub)),

            const SizedBox(height: 16),

            // ── Exam Diagnostic Card ─────────────────────────────────
            _buildDiagnosticCard(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Practice Zone Header (Onyx surface) ─────────────────────────────
  Widget _buildPracticeHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceOnyx,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentCobalt.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: AppColors.accentPeriwinkle,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRACTICE & MASTERY',
                  style: AppTypography.caption(
                          color: AppColors.textOnOnyxMuted)
                      .copyWith(
                          fontWeight: FontWeight.w800, letterSpacing: 0.6),
                ),
                const SizedBox(height: 3),
                Text(
                  'Strengthen Your Concepts',
                  style:
                      AppTypography.subheading(color: AppColors.textOnOnyx),
                ),
                const SizedBox(height: 2),
                Text(
                  'Adaptive question sets aligned with school syllabus.',
                  style:
                      AppTypography.bodySmall(color: AppColors.textOnOnyxMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentMint.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.accentMint,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── Daily Speed Challenge ────────────────────────────────────────────
  Widget _buildSpeedChallengeCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      backgroundColor: AppColors.bgCanvas,
      borderColor: AppColors.accentMustard.withValues(alpha: 0.50),
      hasShadow: true,
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Timer badge — periwinkle
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentPeriwinkle.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: AppColors.accentCobalt),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'SPEED SPRINT • 60s',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption(
                                  color: AppColors.accentCobalt)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // XP reward
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentMustard.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: 14, color: AppColors.accentMustard),
                    const SizedBox(width: 2),
                    Text(
                      '+50 XP',
                      style: AppTypography.caption(color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Daily 5-Question Brain Booster',
            style: AppTypography.headingExtraSmall(),
          ),
          const SizedBox(height: 6),
          Text(
            'Rapid-fire questions from Science and Linear Equations to boost mental recall.',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuizSolverScreen()),
              );
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentCobalt,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'START SPEED SPRINT',
                      style: AppTypography.buttonLabel(
                          color: AppColors.textOnOnyx),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Subject Practice Card ────────────────────────────────────────────
  Widget _buildSubjectPracticeCard(BuildContext context, dynamic sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
        borderRadius: DesignTokens.radiusCardMd,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (sub.primaryColor as Color).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(sub.icon as IconData,
                    size: 22, color: sub.primaryColor as Color),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name as String,
                    style:
                        AppTypography.subheading(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${sub.chaptersCount} Practice Sets Available',
                    style: AppTypography.caption(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            // Cobalt PRACTICE pill
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QuizSolverScreen(subjectId: sub.id as String),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentCobalt,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'PRACTICE',
                  style:
                      AppTypography.caption(color: AppColors.textOnOnyx)
                          .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Exam Diagnostic Card ─────────────────────────────────────────────
  Widget _buildDiagnosticCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      backgroundColor: AppColors.bgSurfaceMuted,
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined,
                  color: AppColors.accentCobalt, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'EXAM READINESS DIAGNOSTIC',
                  style: AppTypography.caption(color: AppColors.textPrimary)
                      .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive 20-minute diagnostic test tailored to CBSE / ICSE Term standards. Pinpoints concept gaps automatically.',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'TAKE DIAGNOSTIC TEST',
            isFullWidth: true,
            variant: AppButtonVariant.outline,
            icon: Icons.assignment_turned_in_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuizSolverScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
