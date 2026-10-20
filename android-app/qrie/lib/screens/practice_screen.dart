import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import 'quiz_solver_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Practice Zone Header Card
            AppCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: AppColors.schoolMint,
              borderColor: primaryColor.withValues(alpha: 0.25),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.track_changes_rounded, color: primaryColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRACTICE & MASTERY',
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Strengthen Your Concepts',
                          style: AppTypography.subheading(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Adaptive question sets aligned with school syllabus.',
                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Daily Speed Challenge Hero Card
            AppCard(
              padding: const EdgeInsets.all(20),
              backgroundColor: AppColors.surface,
              borderColor: AppColors.schoolGold.withValues(alpha: 0.4),
              hasShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.schoolGoldLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFB45309)),
                            const SizedBox(width: 4),
                            Text(
                              'SPEED SPRINT • 60 SECONDS',
                              style: AppTypography.caption(color: const Color(0xFFB45309)).copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, size: 15, color: AppColors.schoolGold),
                          const SizedBox(width: 2),
                          Text(
                            '+50 XP',
                            style: AppTypography.caption(color: AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Daily 5-Question Brain Booster',
                    style: AppTypography.headingSmall(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rapid-fire questions from Science and Linear Equations to boost mental recall.',
                    style: AppTypography.bodySmall(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    text: 'START SPEED SPRINT',
                    isFullWidth: true,
                    icon: Icons.bolt_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizSolverScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Subject-wise Practice Sets Header
            Text('Subject Practice Sets', style: AppTypography.subheading()),
            const SizedBox(height: 12),

            // Subject Practice Cards
            ...MockData.subjects.map((sub) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: sub.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sub.primaryColor.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Icon(sub.icon, size: 22, color: sub.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sub.name,
                              style: AppTypography.subheading(color: AppColors.textPrimary),
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
                      AppButton(
                        text: 'PRACTICE',
                        height: 40,
                        variant: AppButtonVariant.secondary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizSolverScreen(subjectId: sub.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),

            // Exam Diagnostic Card
            AppCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, color: AppColors.info, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'EXAM READINESS DIAGNOSTIC',
                          style: AppTypography.caption(color: AppColors.textPrimary).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
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
                          builder: (_) => const QuizSolverScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
