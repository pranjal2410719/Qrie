import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/mascot_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Profile Hero Sticker Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.paperWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lineGray, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const MascotAvatar(
                  size: 72,
                  expression: MascotExpression.celebration,
                  showBadge: true,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: AppTypography.headingSmall(),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.storybookGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${profile.grade} • ${profile.board} Curriculum',
                          style: AppTypography.caption(color: AppColors.eagerGreenDark),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Member since Oct 2026 • Scholar Level 4',
                        style: AppTypography.caption(color: AppColors.pencilGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Stats 2x2 Grid (Duolingo Sticker Cards)
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'DAY STREAK',
                  value: '${profile.streakDays}',
                  icon: Icons.local_fire_department_rounded,
                  borderColor: AppColors.fireOrange,
                  shadowColor: AppColors.fireOrangeDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'TOTAL XP',
                  value: '${profile.totalXp}',
                  icon: Icons.bolt_rounded,
                  borderColor: AppColors.goldYellow,
                  shadowColor: const Color(0xFFC78900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'GEMS EARNED',
                  value: '${profile.gems}',
                  icon: Icons.diamond_rounded,
                  borderColor: AppColors.sparkBlue,
                  shadowColor: AppColors.sparkBlueDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'LESSONS DONE',
                  value: '${profile.completedLessonIds.length}',
                  icon: Icons.menu_book_rounded,
                  borderColor: AppColors.eagerGreen,
                  shadowColor: AppColors.eagerGreenDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Weekly Study Hours Bar Chart
          Text('Weekly Study Activity', style: AppTypography.headingSmall()),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.paperWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.lineGray, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '14.6 HOURS THIS WEEK',
                        style: AppTypography.caption(color: AppColors.pencilGray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Avg 2.1 hrs/day', style: AppTypography.buttonLabel(color: AppColors.eagerGreenDark).copyWith(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final hours = MockData.weeklyStudyHours[index];
                    final day = MockData.weekDays[index];
                    final heightFactor = (hours / 4.0).clamp(0.15, 1.0);
                    final isToday = (index == 5); // Saturday

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${hours}h', style: AppTypography.caption(color: AppColors.pencilGray).copyWith(fontSize: 10)),
                        const SizedBox(height: 6),
                        Container(
                          width: 22,
                          height: 90 * heightFactor,
                          decoration: BoxDecoration(
                            color: isToday ? AppColors.eagerGreen : AppColors.storybookGreen,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isToday ? AppColors.eagerGreenDark : AppColors.freshLeaf,
                              width: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day,
                          style: AppTypography.buttonLabel(
                            color: isToday ? AppColors.charcoal : AppColors.pencilGray,
                          ).copyWith(fontSize: 12),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 4. Badges Room
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Badges & Achievements',
                  style: AppTypography.headingSmall(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${MockData.badges.where((b) => b['unlocked'] == true).length}/${MockData.badges.length}',
                style: AppTypography.buttonLabel(color: AppColors.sparkBlue),
              ),
            ],
          ),
          const SizedBox(height: 14),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemCount: MockData.badges.length,
            itemBuilder: (context, index) {
              final badge = MockData.badges[index];
              final isUnlocked = badge['unlocked'] as bool;
              final Color color = isUnlocked ? (badge['color'] as Color) : AppColors.fadedGray;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.paperWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnlocked ? color : AppColors.lineGray,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUnlocked ? color.withValues(alpha: 0.3) : const Color(0x0A000000),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isUnlocked ? color.withValues(alpha: 0.15) : AppColors.cloudGray,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isUnlocked ? (badge['icon'] as IconData) : Icons.lock_rounded,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      badge['name'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.buttonLabel(
                        color: isUnlocked ? AppColors.charcoal : AppColors.fadedGray,
                      ).copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      badge['description'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption(color: AppColors.pencilGray).copyWith(fontSize: 9),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          // 5. Instant Profile Switcher (No Auth / Sign-in required)
          Container(
            padding: const EdgeInsets.all(16),
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
                    const Icon(Icons.tune_rounded, color: AppColors.charcoal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'GRADE & CURRICULUM PREFERENCES',
                        style: AppTypography.buttonLabel(color: AppColors.charcoal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Instantly customize your academic grade and syllabus anytime without passwords or login hurdles.',
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 12),
                DuolingoButton(
                  text: 'SWITCH GRADE / BOARD',
                  fullWidth: true,
                  style: DuolingoButtonStyle.outlineGray,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tap the "Class 8 CBSE" pill at the top of the screen to change grades!',
                          style: AppTypography.buttonLabel(color: AppColors.paperWhite),
                        ),
                        backgroundColor: AppColors.charcoal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color borderColor,
    required Color shadowColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: borderColor, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.subheading(color: AppColors.charcoal).copyWith(fontSize: 17),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: AppTypography.caption(color: AppColors.pencilGray).copyWith(fontSize: 10),
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
}
