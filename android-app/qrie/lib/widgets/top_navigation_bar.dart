import 'package:flutter/material.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'mascot_avatar.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;

  const TopNavigationBar({
    super.key,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _showGradeSwitcherDialog(BuildContext context, StudentState state) {
    final grades = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
    final boards = ['CBSE', 'ICSE', 'State Board'];

    String tempGrade = state.profile.grade;
    String tempBoard = state.profile.board;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paperWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.lineGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Select Your Grade & Board',
                      style: AppTypography.headingSmall(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Personalize your syllabus, chapters & practice content instantly.',
                      style: AppTypography.bodySmall(),
                    ),
                    const SizedBox(height: 20),
                    Text('GRADE / CLASS', style: AppTypography.caption(color: AppColors.charcoal)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: grades.map((g) {
                        final isSel = (g == tempGrade);
                        return GestureDetector(
                          onTap: () => setModalState(() => tempGrade = g),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.storybookGreen : AppColors.paperWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? AppColors.eagerGreen : AppColors.lineGray,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              g,
                              style: AppTypography.pillLabel(
                                color: isSel ? AppColors.charcoal : AppColors.pencilGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('EDUCATIONAL BOARD', style: AppTypography.caption(color: AppColors.charcoal)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: boards.map((b) {
                        final isSel = (b == tempBoard);
                        return GestureDetector(
                          onTap: () => setModalState(() => tempBoard = b),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.storybookGreen : AppColors.paperWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? AppColors.eagerGreen : AppColors.lineGray,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              b,
                              style: AppTypography.pillLabel(
                                color: isSel ? AppColors.charcoal : AppColors.pencilGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.eagerGreen,
                          foregroundColor: AppColors.paperWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          state.updateGradeAndBoard(tempGrade, tempBoard);
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'APPLY SYLLABUS',
                          style: AppTypography.buttonLabel(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paperWhite,
        border: Border(
          bottom: BorderSide(color: AppColors.lineGray, width: 2),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              // Duolingo-style sticker Grade selector pill
              Flexible(
                child: GestureDetector(
                  onTap: () => _showGradeSwitcherDialog(context, state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.paperWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.fadedGray, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.pencilGray),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${profile.grade} ${profile.board}'.toUpperCase(),
                            style: AppTypography.navLabel(color: AppColors.charcoal).copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.pencilGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Streak Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.paperWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lineGray, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.fireOrange),
                    const SizedBox(width: 3),
                    Text(
                      '${profile.streakDays}',
                      style: AppTypography.buttonLabel(color: AppColors.fireOrange).copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Gems / XP Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.paperWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lineGray, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.diamond_rounded, size: 15, color: AppColors.sparkBlue),
                    const SizedBox(width: 3),
                    Text(
                      '${profile.gems}',
                      style: AppTypography.buttonLabel(color: AppColors.sparkBlue).copyWith(fontSize: 13),
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
                    border: Border.all(color: AppColors.eagerGreen, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/default_icon.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const MascotAvatar(
                        size: 36,
                        expression: MascotExpression.happy,
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
