import 'dart:math' show pi;

import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/empty_state_view.dart';
import 'lesson_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Per-card animation controllers for the 3-D flip
  final Map<int, AnimationController> _flipControllers = {};
  final Map<int, Animation<double>> _flipAnimations = {};
  final Set<int> _flippedCards = {};

  static const _flashcards = [
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
      'a': '4x = 24 → x = 6. Verified by substituting: 4(6) + 8 = 32.',
      'subject': 'Mathematics • Linear Equations',
    },
    {
      'q': 'Which component of blood carries oxygen throughout the body?',
      'a': 'Red Blood Cells (RBCs) via the iron-rich protein Hemoglobin.',
      'subject': 'Science • Transportation in Organisms',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    for (int i = 0; i < _flashcards.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 420),
      );
      _flipControllers[i] = ctrl;
      _flipAnimations[i] = Tween<double>(begin: 0, end: pi).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOutBack),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final ctrl in _flipControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _flipCard(int index) {
    final ctrl = _flipControllers[index]!;
    if (_flippedCards.contains(index)) {
      ctrl.reverse();
      setState(() => _flippedCards.remove(index));
    } else {
      ctrl.forward();
      setState(() => _flippedCards.add(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final bookmarkedLessonIds = state.profile.bookmarkedLessonIds;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          // ── Tab Selector Header ───────────────────────────────────
          Container(
            color: AppColors.bgCanvas,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.accentCobalt,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.accentCobalt,
              indicatorWeight: 2.5,
              labelStyle: AppTypography.caption(color: AppColors.accentCobalt)
                  .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
              unselectedLabelStyle:
                  AppTypography.caption(color: AppColors.textMuted),
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
                _buildFormulasTab(),
                _buildFlashcardsTab(),
                _buildSavedNotesTab(state, bookmarkedLessonIds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── FORMULAS TAB ─────────────────────────────────────────────────────
  Widget _buildFormulasTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.horizontalPadding, vertical: 14),
      itemCount: MockData.formulaCards.length,
      itemBuilder: (context, index) {
        final card = MockData.formulaCards[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
            hasShadow: true,
            borderRadius: DesignTokens.radiusCardMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Mustard subject badge pill
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentMustard.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          (card['subject'] as String).toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption(
                                  color: AppColors.accentAmber)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        card['unit'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style:
                            AppTypography.caption(color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  card['title'] as String,
                  style:
                      AppTypography.subheading(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    card['formula'] as String,
                    style: AppTypography.buttonLabel(
                            color: AppColors.textPrimary)
                        .copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined,
                        size: 14, color: AppColors.accentMustard),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        card['tip'] as String,
                        style: AppTypography.caption(
                            color: AppColors.textSecondary),
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

  // ── FLASHCARDS TAB (3-D flip) ────────────────────────────────────────
  Widget _buildFlashcardsTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.horizontalPadding, vertical: 14),
      itemCount: _flashcards.length,
      itemBuilder: (context, index) {
        final card = _flashcards[index];
        final flipAnim = _flipAnimations[index]!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _flipCard(index),
            child: AnimatedBuilder(
              animation: flipAnim,
              builder: (context, _) {
                final showBack = flipAnim.value > (pi / 2);
                final visibleAngle = showBack
                    ? flipAnim.value - pi
                    : flipAnim.value;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(visibleAngle),
                  child: showBack
                      ? _buildCardFace(
                          label: 'SOLUTION REVEALED',
                          labelColor: AppColors.accentCobalt,
                          content: card['a']!,
                          subject: card['subject']!,
                          backgroundColor: AppColors.bgSurfaceOnyx,
                          contentStyle: AppTypography.subheading(
                              color: AppColors.textOnOnyx),
                          subjectColor: AppColors.textOnOnyxMuted,
                        )
                      : _buildCardFace(
                          label: 'CONCEPT QUESTION',
                          labelColor: AppColors.textMuted,
                          content: card['q']!,
                          subject: card['subject']!,
                          backgroundColor: AppColors.bgSurfaceSoft,
                          contentStyle: AppTypography.subheading(
                              color: AppColors.textPrimary),
                          subjectColor: AppColors.textMuted,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// IMPORTANT: uses mainAxisSize: MainAxisSize.min and NO Spacer() widgets.
  Widget _buildCardFace({
    required String label,
    required Color labelColor,
    required String content,
    required String subject,
    required Color backgroundColor,
    required TextStyle contentStyle,
    required Color subjectColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        boxShadow: DesignTokens.shadowSoft,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: labelColor == AppColors.textMuted
                        ? AppColors.bgSurfaceMuted
                        : AppColors.accentCobalt.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption(color: labelColor)
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_outlined,
                      size: 12,
                      color: backgroundColor == AppColors.bgSurfaceOnyx
                          ? AppColors.textOnOnyxMuted
                          : AppColors.textMuted),
                  const SizedBox(width: 3),
                  Text(
                    'TAP TO FLIP',
                    style: AppTypography.caption(
                        color: backgroundColor == AppColors.bgSurfaceOnyx
                            ? AppColors.textOnOnyxMuted
                            : AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Main content
          Text(
            content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: contentStyle,
          ),
          const SizedBox(height: 10),
          // Subject tag
          Text(
            subject,
            style: AppTypography.caption(color: subjectColor),
          ),
        ],
      ),
    );
  }

  // ── SAVED NOTES TAB ──────────────────────────────────────────────────
  Widget _buildSavedNotesTab(StudentState state, Set<String> bookmarkedIds) {
    if (bookmarkedIds.isEmpty) {
      return const EmptyStateView(
        icon: Icons.bookmark_border_rounded,
        title: 'No Saved Lessons Yet',
        message:
            'Tap the bookmark icon on any lesson while studying to create your instant quick revision handbook.',
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
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.horizontalPadding, vertical: 14),
      itemCount: savedLessons.length,
      itemBuilder: (context, index) {
        final item = savedLessons[index];
        final les = item['lesson'] as dynamic;
        final ch = item['chapter'] as dynamic;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
            hasShadow: true,
            borderRadius: DesignTokens.radiusCardMd,
            child: Row(
              children: [
                // Mint bookmark icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentMint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bookmark_rounded,
                    color: AppColors.accentMint,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        les.title as String,
                        style: AppTypography.subheading(
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ch.title as String,
                        style:
                            AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Cobalt REVISE pill
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LessonScreen(lesson: les, chapter: ch),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentCobalt,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'REVISE',
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
      },
    );
  }
}
