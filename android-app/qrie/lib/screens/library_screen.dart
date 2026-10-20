import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/mascot_avatar.dart';
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

    return Column(
      children: [
        // Tab Selector Header
        Container(
          color: AppColors.paperWhite,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.eagerGreen,
            unselectedLabelColor: AppColors.pencilGray,
            indicatorColor: AppColors.eagerGreen,
            indicatorWeight: 3,
            labelStyle: AppTypography.navLabel(color: AppColors.eagerGreen),
            tabs: const [
              Tab(text: 'FORMULAS'),
              Tab(text: 'FLASHCARDS'),
              Tab(text: 'SAVED NOTES'),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.lineGray),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFormulasTab(),
              _buildFlashcardsTab(),
              _buildSavedNotesTab(state, bookmarkedLessonIds),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormulasTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.formulaCards.length,
      itemBuilder: (context, index) {
        final card = MockData.formulaCards[index];
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.storybookGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (card['subject'] as String).toUpperCase(),
                      style: AppTypography.caption(color: AppColors.eagerGreenDark),
                    ),
                  ),
                  Text(
                    card['unit'] as String,
                    style: AppTypography.caption(color: AppColors.pencilGray),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                card['title'] as String,
                style: AppTypography.subheading(),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cloudGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lineGray, width: 1.5),
                ),
                child: Text(
                  card['formula'] as String,
                  style: AppTypography.buttonLabel(color: AppColors.charcoal).copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.fireOrange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      card['tip'] as String,
                      style: AppTypography.caption(color: AppColors.pencilGray),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlashcardsTab() {
    final flashcards = [
      {
        'q': 'What organelle synthesizes ATP energy?',
        'a': 'Mitochondria! It uses cellular respiration to convert nutrients into ATP fuel packets.',
        'subject': 'Science',
      },
      {
        'q': 'How does pressure vary with contact surface area?',
        'a': 'Inversely proportional: P = F / A. Smaller surface area produces dramatically higher pressure.',
        'subject': 'Physics',
      },
      {
        'q': 'What is the root of 4x + 8 = 32 ?',
        'a': '4x = 24 ➔ x = 6. Verified by 4(6) + 8 = 32.',
        'subject': 'Math',
      },
      {
        'q': 'Which component of blood carries oxygen throughout the body?',
        'a': 'Red Blood Cells (RBCs) via the iron-rich protein Hemoglobin.',
        'subject': 'Science',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final card = flashcards[index];
        final isFlipped = _flippedFlashcardIndices.contains(index);

        return GestureDetector(
          onTap: () => _toggleFlip(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            height: 180,
            decoration: BoxDecoration(
              color: isFlipped ? AppColors.storybookGreen.withValues(alpha: 0.4) : AppColors.paperWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isFlipped ? AppColors.eagerGreen : AppColors.sparkBlue,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isFlipped ? AppColors.eagerGreenDark : AppColors.sparkBlueDark,
                  offset: const Offset(0, 4),
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
                        color: isFlipped ? AppColors.storybookGreen : const Color(0xFFEAF8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFlipped ? 'SOLUTION REVEALED' : 'CONCEPT QUESTION',
                        style: AppTypography.caption(
                          color: isFlipped ? AppColors.eagerGreenDark : AppColors.sparkBlue,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flip_rounded, size: 12, color: AppColors.pencilGray),
                        const SizedBox(width: 4),
                        Text('TAP TO FLIP', style: AppTypography.caption(color: AppColors.pencilGray)),
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
                        ? AppTypography.subheading(color: AppColors.nightInk)
                        : AppTypography.headingSmall(),
                  ),
                ),
                const Spacer(),
                Text(
                  card['subject']!,
                  style: AppTypography.caption(color: AppColors.pencilGray),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedNotesTab(StudentState state, Set<String> bookmarkedIds) {
    if (bookmarkedIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MascotAvatar(size: 80, expression: MascotExpression.thinking),
              const SizedBox(height: 16),
              Text('No Saved Lessons Yet', style: AppTypography.headingSmall()),
              const SizedBox(height: 8),
              Text(
                'Bookmark lessons while studying to create your instant quick revision handbook.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(16),
      itemCount: savedLessons.length,
      itemBuilder: (context, index) {
        final item = savedLessons[index];
        final les = item['lesson'] as dynamic;
        final ch = item['chapter'] as dynamic;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.storybookGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bookmark_rounded, color: AppColors.eagerGreenDark, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      les.title,
                      style: AppTypography.subheading(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ch.title,
                      style: AppTypography.caption(color: AppColors.pencilGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              DuolingoButton(
                text: 'REVISE',
                height: 38,
                borderRadius: 10,
                style: DuolingoButtonStyle.primaryGreen,
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
        );
      },
    );
  }
}
