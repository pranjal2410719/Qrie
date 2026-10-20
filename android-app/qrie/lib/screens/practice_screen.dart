import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/mascot_avatar.dart';
import 'quiz_solver_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot Header Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.storybookGreen.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.eagerGreen, width: 2),
            ),
            child: Row(
              children: [
                const MascotAvatar(
                  size: 64,
                  expression: MascotExpression.excited,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRACTICE ZONE',
                        style: AppTypography.caption(color: AppColors.eagerGreenDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Strengthen Your Weak Concepts',
                        style: AppTypography.headingSmall(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Adaptive practice tests adjust to your performance.',
                        style: AppTypography.bodySmall(color: AppColors.pencilGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Daily Speed Challenge
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.paperWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.fireOrange, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.fireOrangeDark,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '⚡ SPEED SPRINT • 60 SECONDS',
                        style: AppTypography.caption(color: AppColors.fireOrangeDark),
                      ),
                    ),
                    Text(
                      '+50 XP',
                      style: AppTypography.buttonLabel(color: AppColors.fireOrangeDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Daily 5-Question Brain Booster',
                  style: AppTypography.subheading(),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mixed rapid-fire questions from Science and Linear Equations.',
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 16),
                DuolingoButton(
                  text: 'START SPRINT',
                  fullWidth: true,
                  style: DuolingoButtonStyle.highlightGold,
                  icon: Icons.bolt_rounded,
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

          Text('Subject-wise Quizzes', style: AppTypography.headingSmall()),
          const SizedBox(height: 14),

          // Subject Practice Cards
          ...MockData.subjects.map((sub) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.paperWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lineGray, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: sub.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sub.primaryColor, width: 2),
                    ),
                    child: Center(
                      child: Text(sub.emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.name,
                          style: AppTypography.subheading(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${sub.chaptersCount} Practice Sets',
                          style: AppTypography.caption(color: AppColors.pencilGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  DuolingoButton(
                    text: 'PRACTICE',
                    height: 38,
                    borderRadius: 10,
                    style: DuolingoButtonStyle.primaryGreen,
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
            );
          }),

          const SizedBox(height: 20),

          // Diagnostic Test Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cloudGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lineGray, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.sparkBlue, size: 22),
                    const SizedBox(width: 8),
                    Text('EXAM READINESS DIAGNOSTIC', style: AppTypography.buttonLabel(color: AppColors.charcoal)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Comprehensive 20-min test tailored to CBSE / ICSE Term 1 standards. Identify learning gaps instantly.',
                  style: AppTypography.bodySmall(color: AppColors.pencilGray),
                ),
                const SizedBox(height: 14),
                DuolingoButton(
                  text: 'TAKE DIAGNOSTIC TEST',
                  fullWidth: true,
                  style: DuolingoButtonStyle.secondaryBlue,
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

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
