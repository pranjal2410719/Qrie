import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/storage/local_database.dart';
import '../data/mock_data.dart';
import '../models/quiz_question.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_progress_bar.dart';
import '../widgets/floating_ai_tutor_widget.dart';

class QuizSolverScreen extends StatefulWidget {
  final String? subjectId;

  const QuizSolverScreen({super.key, this.subjectId});

  @override
  State<QuizSolverScreen> createState() => _QuizSolverScreenState();
}

class _QuizSolverScreenState extends State<QuizSolverScreen> {
  final LocalDatabaseService _localDb = LocalDatabaseService();
  final TextEditingController _numericController = TextEditingController();

  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isChecked = false;
  bool _isAnswerCorrect = false;
  int _score = 0;
  int _totalXpEarned = 0;
  bool _isCompleted = false;

  // Adaptive Assistance Ladder
  int _assistanceRung = 0;
  DateTime _questionStartTime = DateTime.now();
  late final String _sessionId;

  @override
  void initState() {
    super.initState();
    _sessionId = 'sess_' + DateTime.now().millisecondsSinceEpoch.toString();
    if (widget.subjectId != null) {
      final filtered = MockData.quizQuestions
          .where((q) => q.subjectId == widget.subjectId)
          .toList();
      _questions = filtered.isNotEmpty ? filtered : MockData.quizQuestions;
    } else {
      _questions = MockData.quizQuestions;
    }
    _questionStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _numericController.dispose();
    super.dispose();
  }

  void _onOptionTap(int index) {
    if (_isChecked) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedOptionIndex = index);
  }

  void _escalateAssistance() {
    if (_isChecked) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_assistanceRung < 3) _assistanceRung++;
    });
  }

  Future<void> _checkAnswer() async {
    final currentQuestion = _questions[_currentIndex];
    bool isCorrect = false;

    if (currentQuestion.questionType == QuestionType.numeric) {
      final userNum = double.tryParse(_numericController.text.trim());
      if (userNum == null) return;
      isCorrect =
          (userNum - (currentQuestion.numericAnswer ?? 0)).abs() < 0.001;
    } else {
      if (_selectedOptionIndex == null || _isChecked) return;
      isCorrect = _selectedOptionIndex == currentQuestion.correctIndex;
    }

    final durationMs =
        DateTime.now().difference(_questionStartTime).inMilliseconds;

    try {
      await _localDb.enqueueEvent(
        eventType: 'learning.answer_submitted',
        payload: {
          'session_id': _sessionId,
          'question_id': currentQuestion.id,
          'item_id': currentQuestion.id,
          'concept_ids': [currentQuestion.topic ?? ('ncert.' + currentQuestion.subjectId + '.' + currentQuestion.id)],
          'subject_id': currentQuestion.subjectId,
          'is_correct': isCorrect,
          'selected_option': _selectedOptionIndex,
          'numeric_input': _numericController.text.trim(),
          'duration_ms': durationMs,
          'assistance_rung': _assistanceRung,
          'is_assisted': _assistanceRung > 0,
        },
      );
    } catch (_) {}

    setState(() {
      _isChecked = true;
      _isAnswerCorrect = isCorrect;
      if (isCorrect) {
        _score++;
        _totalXpEarned += currentQuestion.xpReward;
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _nextQuestion(StudentState state) {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _numericController.clear();
        _isChecked = false;
        _isAnswerCorrect = false;
        _assistanceRung = 0;
        _questionStartTime = DateTime.now();
      });
    } else {
      state.completeLesson(
          'quiz_completed_${DateTime.now().millisecondsSinceEpoch}',
          _totalXpEarned);
      setState(() => _isCompleted = true);
    }
  }

  bool get _canCheckAnswer {
    if (_isChecked) return false;
    final q = _questions[_currentIndex];
    if (q.questionType == QuestionType.numeric) {
      return _numericController.text.trim().isNotEmpty;
    }
    return _selectedOptionIndex != null;
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (_isCompleted) {
      return _QuizCompletionScreen(
        score: _score,
        totalQuestions: _questions.length,
        totalXpEarned: _totalXpEarned,
        primaryColor: primaryColor,
      );
    }

    final currentQ = _questions[_currentIndex];
    final progress =
        (_currentIndex + (_isChecked ? 1 : 0)) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
            // ── Top bar ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 10.0),
              color: AppColors.surface,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 24, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppProgressBar(
                      value: progress,
                      height: 8,
                      fillColor: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.schoolGoldLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.schoolGold
                              .withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: 15, color: AppColors.schoolGold),
                        const SizedBox(width: 2),
                        Text(
                          '+${currentQ.xpReward} XP',
                          style: AppTypography.caption(
                                  color: AppColors.textPrimary)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                height: 1, thickness: 1, color: AppColors.borderLight),

            // ── Question body ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: AppColors.borderLight),
                          ),
                          child: Text(
                            'QUESTION ${_currentIndex + 1} OF ${_questions.length}',
                            style: AppTypography.caption(
                                    color: AppColors.textMuted)
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5),
                          ),
                        ),
                        Text(
                          currentQ.category.toUpperCase(),
                          style:
                              AppTypography.caption(color: primaryColor)
                                  .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    AppCard(
                      padding: const EdgeInsets.all(20),
                      hasShadow: true,
                      child: Text(
                        currentQ.question,
                        style:
                            AppTypography.subheading(
                                    color: AppColors.textPrimary)
                                .copyWith(fontSize: 17, height: 1.4),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (_assistanceRung > 0) ...[
                      _buildAssistanceCard(currentQ, primaryColor),
                      const SizedBox(height: 18),
                    ],

                    if (currentQ.questionType == QuestionType.numeric)
                      _buildNumericInputField(currentQ, primaryColor)
                    else
                      _buildSingleChoiceOptions(currentQ, primaryColor),

                    const SizedBox(height: 14),

                    if (!_isChecked)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _assistanceRung >= 3
                              ? null
                              : _escalateAssistance,
                          icon: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: _assistanceRung >= 3
                                ? AppColors.textDisabled
                                : AppColors.info,
                          ),
                          label: Text(
                            _assistanceRung == 0
                                ? 'Need a hint? (Rung 1: Think it through)'
                                : _assistanceRung == 1
                                    ? 'Show core rule (Rung 2: Formula hint)'
                                    : _assistanceRung == 2
                                        ? 'Show step-by-step (Rung 3: Substep)'
                                        : 'Full assistance active',
                            style: AppTypography.caption(
                              color: _assistanceRung >= 3
                                  ? AppColors.textDisabled
                                  : AppColors.info,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            _buildBottomBanner(context, currentQ, state, primaryColor),
          ],
        ),
        FloatingAITutorWidget(
          bottomOffset: 96,
          rightOffset: 16,
          contextualQuestion: currentQ.prompt,
        ),
      ],
    ),
  ),
);
  }

  // ── Assistance card ──────────────────────────────────────────────────
  Widget _buildAssistanceCard(QuizQuestion currentQ, Color primaryColor) {
    String title = 'Rung 1: Concept Prompt';
    String content =
        currentQ.rethinkPrompt ?? 'Read the question carefully and check the units.';
    Color accentColor = AppColors.info;
    Color surfaceColor = AppColors.infoSurface;

    if (_assistanceRung == 2) {
      title = 'Rung 2: Strategic Formula Hint';
      content = currentQ.hint;
      accentColor = const Color(0xFFB45309);
      surfaceColor = AppColors.warningSurface;
    } else if (_assistanceRung >= 3) {
      title = 'Rung 3: Scaffolded Substep Breakdown';
      content = currentQ.scaffoldSubstep ?? currentQ.hint;
      accentColor = primaryColor;
      surfaceColor = AppColors.schoolMint;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: accentColor.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined,
                  color: accentColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.caption(color: accentColor)
                      .copyWith(
                          fontWeight: FontWeight.w800, letterSpacing: 0.4),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(content,
              style:
                  AppTypography.bodySmall(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  // ── Numeric input ────────────────────────────────────────────────────
  Widget _buildNumericInputField(
      QuizQuestion currentQ, Color primaryColor) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ENTER YOUR NUMERICAL VALUE',
            style: AppTypography.caption(color: AppColors.textMuted)
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _numericController,
            enabled: !_isChecked,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            style: AppTypography.headingSmall(),
            decoration: InputDecoration(
              hintText: '0.0',
              suffixText: 'Value',
              suffixStyle: AppTypography.caption(color: AppColors.textMuted),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: primaryColor, width: 1.8),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  // ── Single choice options ────────────────────────────────────────────
  Widget _buildSingleChoiceOptions(
      QuizQuestion currentQ, Color primaryColor) {
    return Column(
      children: currentQ.options.asMap().entries.map((entry) {
        final index = entry.key;
        final optionText = entry.value;
        final isSelected = (_selectedOptionIndex == index);

        Color cardBg = AppColors.surface;
        Color borderColor = AppColors.borderLight;
        Color textColor = AppColors.textPrimary;
        Widget? trailingIcon;

        if (_isChecked) {
          if (index == currentQ.correctIndex) {
            cardBg = AppColors.successSurface;
            borderColor = AppColors.success;
            textColor = AppColors.success;
            trailingIcon = const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 22);
          } else if (isSelected && !_isAnswerCorrect) {
            cardBg = AppColors.errorSurface;
            borderColor = AppColors.error;
            textColor = AppColors.error;
            trailingIcon = const Icon(Icons.cancel_rounded,
                color: AppColors.error, size: 22);
          }
        } else if (isSelected) {
          cardBg = AppColors.schoolMint;
          borderColor = primaryColor;
          textColor = primaryColor;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: AppCard(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            backgroundColor: cardBg,
            borderColor: borderColor,
            onTap: () => _onOptionTap(index),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : AppColors.borderMedium,
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: AppTypography.buttonLabel(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ).copyWith(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: AppTypography.bodyMedium(color: textColor)
                        .copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  trailingIcon,
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Bottom evaluation banner ─────────────────────────────────────────
  Widget _buildBottomBanner(
    BuildContext context,
    QuizQuestion currentQ,
    StudentState state,
    Color primaryColor,
  ) {
    if (!_isChecked) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
              top: BorderSide(
                  color: AppColors.borderLight, width: 1.2)),
        ),
        child: AppButton(
          text: 'CHECK ANSWER',
          isFullWidth: true,
          variant: _canCheckAnswer
              ? AppButtonVariant.primary
              : AppButtonVariant.outline,
          onPressed: _canCheckAnswer ? _checkAnswer : null,
        ),
      );
    }

    final isCorrect = _isAnswerCorrect;
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.successSurface
            : AppColors.warningSurface,
        border: Border(
          top: BorderSide(
            color: isCorrect
                ? AppColors.successBorder
                : AppColors.warningBorder,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.lightbulb_outline_rounded,
                color: isCorrect
                    ? AppColors.success
                    : const Color(0xFFB45309),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect
                      ? (_assistanceRung > 0
                          ? 'Correct with Assistance'
                          : 'Correct! Great job!')
                      : 'Solution & Explanation:',
                  style: AppTypography.subheading(
                    color: isCorrect
                        ? AppColors.success
                        : const Color(0xFFB45309),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCorrect) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: AppColors.successBorder),
                  ),
                  child: Text(
                    '+${currentQ.xpReward} XP',
                    style: AppTypography.caption(
                            color: AppColors.success)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            currentQ.explanation,
            style:
                AppTypography.bodySmall(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          AppButton(
            text: 'CONTINUE',
            isFullWidth: true,
            variant: isCorrect
                ? AppButtonVariant.primary
                : AppButtonVariant.secondary,
            onPressed: () => _nextQuestion(state),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// Quiz Completion Screen — animated XP counter + staggered entrance
// ════════════════════════════════════════════════════════════════════════

class _QuizCompletionScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int totalXpEarned;
  final Color primaryColor;

  const _QuizCompletionScreen({
    required this.score,
    required this.totalQuestions,
    required this.totalXpEarned,
    required this.primaryColor,
  });

  @override
  State<_QuizCompletionScreen> createState() =>
      _QuizCompletionScreenState();
}

class _QuizCompletionScreenState extends State<_QuizCompletionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Hero trophy
  late Animation<double> _heroScale;
  late Animation<double> _heroOpacity;

  // XP counter
  late Animation<int> _xpCounter;

  // Stats cards entrance
  late Animation<double> _statsOffset;
  late Animation<double> _statsOpacity;

  // Button entrance
  late Animation<double> _btnOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Trophy: scale + fade — 0ms → 400ms
    _heroScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.30, curve: Curves.elasticOut),
      ),
    );
    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
      ),
    );

    // XP counter ticks up — 200ms → 900ms
    _xpCounter = IntTween(begin: 0, end: widget.totalXpEarned).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOut),
      ),
    );

    // Stats cards slide up — 500ms → 900ms
    _statsOffset = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
      ),
    );
    _statsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // Button fades in last — 800ms → 1000ms
    _btnOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.60, 0.85, curve: Curves.easeOut),
      ),
    );

    // Haptic on trophy pop
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) HapticFeedback.mediumImpact();
        });
      }
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracyPercent =
        ((_score / _totalQ) * 100).toInt();
    final isPerfect = _score == _totalQ;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Animated Trophy / Hero Icon ─────────────────────────
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, _) => FadeTransition(
                  opacity: _heroOpacity,
                  child: Transform.scale(
                    scale: _heroScale.value,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            widget.primaryColor.withValues(alpha: 0.2),
                            widget.primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: widget.primaryColor.withValues(alpha: 0.35),
                            width: 2),
                      ),
                      child: Icon(
                        isPerfect
                            ? Icons.emoji_events_rounded
                            : Icons.school_rounded,
                        size: 48,
                        color: isPerfect
                            ? AppColors.schoolGold
                            : widget.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Title ────────────────────────────────────────────────
              FadeTransition(
                opacity: _heroOpacity,
                child: Text(
                  isPerfect ? 'Perfect Score! 🎉' : 'Practice Complete!',
                  style: AppTypography.headingLarge(
                      color: widget.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 6),

              FadeTransition(
                opacity: _heroOpacity,
                child: Text(
                  isPerfect
                      ? 'Flawless! You mastered every question.'
                      : 'You practiced school concepts with steady focus.',
                  style: AppTypography.bodyMedium(
                      color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // ── Animated XP Counter ──────────────────────────────────
              AnimatedBuilder(
                animation: _xpCounter,
                builder: (_, _) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.schoolGoldLight,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: AppColors.schoolGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: AppColors.schoolGold, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        '+${_xpCounter.value} XP Earned',
                        style: AppTypography.headingSmall(
                                color: const Color(0xFFB45309))
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Stats Cards (staggered slide-up) ─────────────────────
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, _) => Transform.translate(
                  offset: Offset(0, _statsOffset.value),
                  child: Opacity(
                    opacity: _statsOpacity.value,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            padding: const EdgeInsets.all(16),
                            hasShadow: true,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.track_changes_rounded,
                                        size: 16,
                                        color: AppColors.textMuted),
                                    SizedBox(width: 4),
                                    Text(
                                      'ACCURACY',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$accuracyPercent%',
                                  style: AppTypography.headingSmall(
                                      color: widget.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: AppCard(
                            padding: const EdgeInsets.all(16),
                            hasShadow: true,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.quiz_outlined,
                                        size: 16,
                                        color: AppColors.textMuted),
                                    SizedBox(width: 4),
                                    Text(
                                      'CORRECT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_score / $_totalQ',
                                  style: AppTypography.headingSmall(
                                      color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ── CTA Button ───────────────────────────────────────────
              AnimatedBuilder(
                animation: _btnOpacity,
                builder: (_, child) =>
                    Opacity(opacity: _btnOpacity.value, child: child),
                child: AppButton(
                  text: 'BACK TO LEARNING DASHBOARD',
                  isFullWidth: true,
                  variant: AppButtonVariant.primary,
                  icon: Icons.home_rounded,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  int get _score => widget.score;
  int get _totalQ => widget.totalQuestions;
}
