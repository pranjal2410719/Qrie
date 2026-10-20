import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/empty_state_view.dart';
import 'lesson_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _flippedFlashcardIndices = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleFlip(int index) {
    setState(() {
      if (_flippedFlashcardIndices.contains(index)) {
        _flippedFlashcardIndices.remove(index);
      } else {
        _flippedFlashcardIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final bookmarkedLessonIds = state.profile.bookmarkedLessonIds;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Tab Selector Header
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: primaryColor,
              indicatorWeight: 2.5,
              labelStyle: AppTypography.caption(color: primaryColor).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              tabs: const [
                Tab(text: 'FORMULAS'),
                Tab(text: 'FLASHCARDS'),
                Tab(text: 'SAVED NOTES'),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFormulasTab(primaryColor),
                _buildFlashcardsTab(primaryColor),
                _buildSavedNotesTab(state, bookmarkedLessonIds, primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulasTab(Color primaryColor) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: MockData.formulaCards.length,
      itemBuilder: (context, index) {
        final card = MockData.formulaCards[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.schoolMint,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (card['subject'] as String).toUpperCase(),
                        style: AppTypography.caption(color: primaryColor).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      card['unit'] as String,
                      style: AppTypography.caption(color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  card['title'] as String,
                  style: AppTypography.subheading(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    card['formula'] as String,
                    style: AppTypography.buttonLabel(color: AppColors.textPrimary).copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, size: 15, color: AppColors.schoolGold),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        card['tip'] as String,
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlashcardsTab(Color primaryColor) {
    final flashcards = [
      {
        'q': 'What organelle synthesizes cellular ATP energy?',
        'a': 'Mitochondria! It uses cellular respiration to convert nutrients into ATP fuel packets.',
        'subject': 'Science • Cell Biology',
      },
      {
        'q': 'How does pressure vary with contact surface area?',
        'a': 'Inversely proportional: P = F / A. Smaller contact area produces dramatically higher pressure.',
        'subject': 'Science • Force & Pressure',
      },
      {
        'q': 'What is the root of 4x + 8 = 32 ?',
        'a': '4x = 24 -> x = 6. Verified by substituting: 4(6) + 8 = 32.',
        'subject': 'Mathematics • Linear Equations',
      },
      {
        'q': 'Which component of blood carries oxygen throughout the body?',
        'a': 'Red Blood Cells (RBCs) via the iron-rich protein Hemoglobin.',
        'subject': 'Science • Transportation in Organisms',
      },
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final card = flashcards[index];
        final isFlipped = _flippedFlashcardIndices.contains(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: isFlipped ? AppColors.schoolMint : AppColors.surface,
            borderColor: isFlipped ? primaryColor.withValues(alpha: 0.4) : AppColors.borderLight,
            hasShadow: true,
            onTap: () => _toggleFlip(index),
            child: SizedBox(
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isFlipped ? Colors.white : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isFlipped ? 'SOLUTION REVEALED' : 'CONCEPT QUESTION',
                          style: AppTypography.caption(
                            color: isFlipped ? primaryColor : AppColors.textMuted,
                          ).copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            'TAP TO FLIP',
                            style: AppTypography.caption(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      isFlipped ? card['a']! : card['q']!,
                      textAlign: TextAlign.center,
                      style: isFlipped
                          ? AppTypography.subheading(color: AppColors.textPrimary)
                          : AppTypography.subheading(color: primaryColor),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    card['subject']!,
                    style: AppTypography.caption(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedNotesTab(StudentState state, Set<String> bookmarkedIds, Color primaryColor) {
    if (bookmarkedIds.isEmpty) {
      return EmptyStateView(
        icon: Icons.bookmark_border_rounded,
        title: 'No Saved Lessons Yet',
        message: 'Tap the bookmark icon on any lesson while studying to create your instant quick revision handbook.',
      );
    }

    final savedLessons = <Map<String, dynamic>>[];
    for (final ch in MockData.chapters) {
      for (final les in ch.lessons) {
        if (bookmarkedIds.contains(les.id)) {
          savedLessons.add({'lesson': les, 'chapter': ch});
        }
      }
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: savedLessons.length,
      itemBuilder: (context, index) {
        final item = savedLessons[index];
        final les = item['lesson'] as dynamic;
        final ch = item['chapter'] as dynamic;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.schoolMint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.bookmark_rounded, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        les.title,
                        style: AppTypography.subheading(color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ch.title,
                        style: AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: 'REVISE',
                  height: 38,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: les, chapter: ch),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
