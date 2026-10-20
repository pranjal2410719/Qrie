import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/storage/local_database.dart';
import '../data/mock_data.dart';
import '../models/quiz_question.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/duolingo_progress_bar.dart';
import '../widgets/mascot_avatar.dart';

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

  // Adaptive Assistance Ladder state
  int _assistanceRung = 0; // 0 = independent, 1 = rethink, 2 = hint, 3 = substep
  DateTime _questionStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _escalateAssistance() {
    if (_isChecked) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_assistanceRung < 3) {
        _assistanceRung++;
      }
    });
  }

  Future<void> _checkAnswer() async {
    final currentQuestion = _questions[_currentIndex];

    bool isCorrect = false;
    if (currentQuestion.questionType == QuestionType.numeric) {
      final userNum = double.tryParse(_numericController.text.trim());
      if (userNum == null) return;
      isCorrect = (userNum - (currentQuestion.numericAnswer ?? 0)).abs() < 0.001;
    } else {
      if (_selectedOptionIndex == null || _isChecked) return;
      isCorrect = _selectedOptionIndex == currentQuestion.correctIndex;
    }

    final durationMs = DateTime.now().difference(_questionStartTime).inMilliseconds;

    // Persist event into offline outbox with client-minted UUID idempotency
    try {
      await _localDb.enqueueEvent(
        eventType: 'learning.answer_submitted',
        payload: {
          'question_id': currentQuestion.id,
          'subject_id': currentQuestion.subjectId,
          'is_correct': isCorrect,
          'selected_option': _selectedOptionIndex,
          'numeric_input': _numericController.text.trim(),
          'duration_ms': durationMs,
          'assistance_rung': _assistanceRung,
          'is_assisted': _assistanceRung > 0,
        },
      );
    } catch (_) {
      // Local DB error fallback
    }

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
      // Completed quiz! Update student XP
      state.completeLesson('quiz_completed_${DateTime.now().millisecondsSinceEpoch}', _totalXpEarned);
      setState(() {
        _isCompleted = true;
      });
    }
  }

  bool get _canCheckAnswer {
    if (_isChecked) return false;
    final currentQ = _questions[_currentIndex];
    if (currentQ.questionType == QuestionType.numeric) {
      return _numericController.text.trim().isNotEmpty;
    }
    return _selectedOptionIndex != null;
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);

    if (_isCompleted) {
      return _buildCompletionScreen(context);
    }

    final currentQ = _questions[_currentIndex];
    final progress = (_currentIndex + (_isChecked ? 1 : 0)) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar with Close & Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28, color: AppColors.pencilGray),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DuolingoProgressBar(
                      value: progress,
                      height: 16,
                      fillColor: AppColors.eagerGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 18, color: AppColors.fireOrange),
                      const SizedBox(width: 4),
                      Text(
                        '${state.profile.streakDays}',
                        style: AppTypography.buttonLabel(color: AppColors.fireOrange),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.lineGray),

            // Main Question Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mascot Speech Prompt
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MascotAvatar(
                          size: 54,
                          expression: _isChecked
                              ? (_isAnswerCorrect ? MascotExpression.celebration : MascotExpression.thinking)
                              : MascotExpression.happy,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.paperWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.lineGray, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              _isChecked
                                  ? (_isAnswerCorrect
                                      ? (_assistanceRung > 0
                                          ? 'Well done with assistance! Practice again later to master unassisted.'
                                          : 'Spot on! Independent mastery achieved!')
                                      : 'Keep going! Check the solution below.')
                                  : 'Question ${_currentIndex + 1} of ${_questions.length}: ${currentQ.category}',
                              style: AppTypography.pillLabel(color: AppColors.charcoal),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Question Text
                    Text(
                      currentQ.question,
                      style: AppTypography.headingSmall(),
                    ),

                    const SizedBox(height: 20),

                    // Adaptive Assistance Display (Rung 1, 2, or 3)
                    if (_assistanceRung > 0) ...[
                      _buildAssistanceCard(currentQ),
                      const SizedBox(height: 18),
                    ],

                    // Question Input (Numeric or Single Choice)
                    if (currentQ.questionType == QuestionType.numeric)
                      _buildNumericInputField(currentQ)
                    else
                      _buildSingleChoiceOptions(currentQ),

                    const SizedBox(height: 16),

                    // Hint Request Button (Ladder Escalation)
                    if (!_isChecked) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _assistanceRung >= 3 ? null : _escalateAssistance,
                          icon: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: _assistanceRung >= 3 ? AppColors.fadedGray : AppColors.sparkBlue,
                          ),
                          label: Text(
                            _assistanceRung == 0
                                ? 'Need a hint? (Rung 1 Rethink)'
                                : _assistanceRung == 1
                                    ? 'Show domain formula (Rung 2 Hint)'
                                    : _assistanceRung == 2
                                        ? 'Show step-by-step (Rung 3 Substep)'
                                        : 'Full assistance active',
                            style: AppTypography.buttonLabel(
                              color: _assistanceRung >= 3 ? AppColors.fadedGray : AppColors.sparkBlue,
                            ).copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Duolingo Evaluation Banner or Check Action
            _buildBottomBanner(context, currentQ, state),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistanceCard(QuizQuestion currentQ) {
    String title = 'Rung 1: Metacognitive Rethink';
    String content = currentQ.rethinkPrompt ?? 'Read the question carefully and check the units.';
    Color accentColor = AppColors.sparkBlue;

    if (_assistanceRung == 2) {
      title = 'Rung 2: Strategic Domain Hint';
      content = currentQ.hint;
      accentColor = AppColors.goldYellow;
    } else if (_assistanceRung >= 3) {
      title = 'Rung 3: Scaffolded Substep';
      content = currentQ.scaffoldSubstep ?? currentQ.hint;
      accentColor = AppColors.fireOrange;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_rounded, color: accentColor, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.buttonLabel(color: accentColor).copyWith(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: AppTypography.bodySmall(color: AppColors.charcoal),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericInputField(QuizQuestion currentQ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isChecked
              ? (_isAnswerCorrect ? AppColors.eagerGreen : AppColors.rubyRed)
              : AppColors.lineGray,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your numerical value:',
            style: AppTypography.caption(color: AppColors.pencilGray),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _numericController,
            enabled: !_isChecked,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTypography.headingSmall(),
            decoration: InputDecoration(
              hintText: '0.0',
              filled: true,
              fillColor: AppColors.cloudGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixText: 'Value',
              suffixStyle: AppTypography.caption(color: AppColors.pencilGray),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleChoiceOptions(QuizQuestion currentQ) {
    return Column(
      children: currentQ.options.asMap().entries.map((entry) {
        final index = entry.key;
        final optionText = entry.value;
        final isSelected = (_selectedOptionIndex == index);

        Color cardBg = AppColors.paperWhite;
        Color borderColor = AppColors.lineGray;
        Color textColor = AppColors.charcoal;

        if (_isChecked) {
          if (index == currentQ.correctIndex) {
            cardBg = AppColors.storybookGreen;
            borderColor = AppColors.eagerGreen;
            textColor = AppColors.nightInk;
          } else if (isSelected && !_isAnswerCorrect) {
            cardBg = AppColors.rubyRedLight;
            borderColor = AppColors.rubyRed;
            textColor = AppColors.rubyRed;
          }
        } else if (isSelected) {
          cardBg = const Color(0xFFEAF8FF);
          borderColor = AppColors.sparkBlue;
          textColor = AppColors.sparkBlue;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            onTap: () => _onOptionTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.4),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? borderColor : AppColors.cloudGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? borderColor : AppColors.fadedGray,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: AppTypography.buttonLabel(
                          color: isSelected ? AppColors.paperWhite : AppColors.pencilGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      optionText,
                      style: AppTypography.bodyMedium(color: textColor).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (_isChecked && index == currentQ.correctIndex)
                    const Icon(Icons.check_circle_rounded, color: AppColors.eagerGreen, size: 24),
                  if (_isChecked && isSelected && !_isAnswerCorrect)
                    const Icon(Icons.cancel_rounded, color: AppColors.rubyRed, size: 24),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBanner(BuildContext context, QuizQuestion currentQ, StudentState state) {
    if (!_isChecked) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.paperWhite,
          border: Border(top: BorderSide(color: AppColors.lineGray, width: 2)),
        ),
        child: DuolingoButton(
          text: 'CHECK',
          fullWidth: true,
          style: _canCheckAnswer
              ? DuolingoButtonStyle.primaryGreen
              : DuolingoButtonStyle.outlineGray,
          onPressed: _canCheckAnswer ? _checkAnswer : null,
        ),
      );
    }

    // Evaluation Bottom Sheet
    final isCorrect = _isAnswerCorrect;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.storybookGreen : AppColors.rubyRedLight,
        border: Border(
          top: BorderSide(
            color: isCorrect ? AppColors.eagerGreen : AppColors.rubyRed,
            width: 2.5,
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
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: isCorrect ? AppColors.eagerGreenDark : AppColors.rubyRed,
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect
                      ? (_assistanceRung > 0 ? 'Assisted Success' : 'Nicely done!')
                      : 'Correct Answer:',
                  style: AppTypography.headingSmall(
                    color: isCorrect ? AppColors.eagerGreenDark : AppColors.rubyRed,
                  ).copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCorrect) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.paperWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${currentQ.xpReward} XP',
                    style: AppTypography.caption(color: AppColors.eagerGreenDark),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isCorrect
                ? currentQ.explanation
                : (currentQ.questionType == QuestionType.numeric
                    ? '${currentQ.numericAnswer}'
                    : currentQ.options[currentQ.correctIndex]),
            style: AppTypography.bodySmall(
              color: isCorrect ? AppColors.nightInk : AppColors.rubyRed,
            ),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 4),
            Text(
              currentQ.explanation,
              style: AppTypography.caption(color: AppColors.charcoal),
            ),
          ],
          const SizedBox(height: 14),
          DuolingoButton(
            text: 'CONTINUE',
            fullWidth: true,
            style: isCorrect ? DuolingoButtonStyle.primaryGreen : DuolingoButtonStyle.dangerRed,
            onPressed: () => _nextQuestion(state),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const MascotAvatar(
                size: 120,
                expression: MascotExpression.celebration,
              ),
              const SizedBox(height: 24),
              Text(
                'Lesson Complete!',
                style: AppTypography.display(color: AppColors.eagerGreen),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You practiced school concepts with flying colors!',
                style: AppTypography.bodyMedium(color: AppColors.pencilGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.paperWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.goldYellow, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFF3C100),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text('⚡ XP EARNED', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.pencilGray)),
                          const SizedBox(height: 6),
                          Text('+$_totalXpEarned', style: AppTypography.headingSmall(color: const Color(0xFFC78900))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.paperWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.eagerGreen, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.eagerGreenDark,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.track_changes_rounded, size: 14, color: AppColors.pencilGray),
                              SizedBox(width: 4),
                              Text('ACCURACY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.pencilGray)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${((_score / _questions.length) * 100).toInt()}%',
                            style: AppTypography.headingSmall(color: AppColors.eagerGreenDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              DuolingoButton(
                text: 'CONTINUE LEARNING',
                fullWidth: true,
                style: DuolingoButtonStyle.primaryGreen,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
