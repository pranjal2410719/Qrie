import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/floating_ai_tutor_widget.dart';
import '../widgets/homework_study_materials_sheet.dart';

/// Topic Verification Mini-Test Screen
///
/// Features:
/// - Pastel Bento intro card with mastery threshold, item counts, and attempt limits.
/// - Interactive step-by-step quiz with question jumper pills and smooth option selection.
/// - Integrated Qrie AI Socratic hint trigger preloaded with active question context.
/// - Safe floating AI tutor placement (94dp bottom offset) ensuring zero overlap with action CTAs.
/// - Comprehensive results dashboard with celebratory mastery ring or study remediation links.
class HomeworkMiniTestScreen extends StatefulWidget {
  final HomeworkAssignment assignment;

  const HomeworkMiniTestScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<HomeworkMiniTestScreen> createState() => _HomeworkMiniTestScreenState();
}

class _HomeworkMiniTestScreenState extends State<HomeworkMiniTestScreen> {
  bool _hasStarted = false;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex
  bool _isSubmitted = false;
  HomeworkTestAttempt? _latestAttempt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StudentStateScope.of(context).setTutorContext(
          assignment: widget.assignment,
          isTestMode: true,
        );
      }
    });
  }

  void _submitTest(StudentState state) {
    HapticFeedback.heavyImpact();
    final miniTest = widget.assignment.miniTest;
    if (miniTest == null) return;

    int correctCount = 0;
    for (int i = 0; i < miniTest.questions.length; i++) {
      final selected = _selectedAnswers[i];
      final isCorrect = (selected != null && selected == miniTest.questions[i].correctIndex);
      if (isCorrect) correctCount++;
    }

    final scorePct = ((correctCount / miniTest.questions.length) * 100).round();
    final passed = scorePct >= miniTest.passingPercentage;

    final attempt = HomeworkTestAttempt(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      attemptedAt: DateTime.now(),
      scorePercentage: scorePct,
      correctCount: correctCount,
      totalQuestions: miniTest.questions.length,
      passed: passed,
    );

    state.recordTestAttempt(
      assignmentId: widget.assignment.id,
      attempt: attempt,
      miniTest: miniTest,
    );

    setState(() {
      _latestAttempt = attempt;
      _isSubmitted = true;
    });
  }

  void _restartTest() {
    setState(() {
      _hasStarted = true;
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _isSubmitted = false;
      _latestAttempt = null;
    });
  }

  void _openQrieHint(BuildContext context, StudentState state) {
    HapticFeedback.lightImpact();
    final miniTest = widget.assignment.miniTest;
    final currentQ = (miniTest != null && _currentQuestionIndex < miniTest.questions.length)
        ? miniTest.questions[_currentQuestionIndex]
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildHintSheet(context, state, currentQ),
    );
  }

  Widget _buildHintSheet(BuildContext context, StudentState state, dynamic currentQ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield_rounded, color: Color(0xFFD97706), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qrie Socratic Hint',
                        style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
                      ),
                      Text(
                        'Topic Verification Guardrails Active',
                        style: AppTypography.caption(color: const Color(0xFFB45309)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFD97706), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Conceptual Guidance',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (currentQ != null && currentQ.hint.isNotEmpty)
                        ? currentQ.hint
                        : 'Recall the core principle connecting the variables. Focus on what constraints are kept constant and eliminate choices that violate the fundamental law.',
                    style: const TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'GOT IT, CONTINUE TEST',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final miniTest = widget.assignment.miniTest;
    final progress = state.getProgressForAssignment(widget.assignment.id);

    if (miniTest == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Topic Verification')),
        body: const Center(child: Text('No verification test attached to this assignment.')),
      );
    }

    final attemptsCount = progress.testAttempts.length;
    final canAttempt = attemptsCount < miniTest.maxAttempts;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            state.clearTutorContext();
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOPIC VERIFICATION',
              style: AppTypography.caption(color: AppColors.accentCobalt).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              widget.assignment.title,
              style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded, size: 13, color: Color(0xFFD97706)),
                const SizedBox(width: 4),
                Text(
                  'Pass ${miniTest.passingPercentage}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasStarted && !_isSubmitted)
            _buildIntroView(miniTest, progress, canAttempt)
          else if (_isSubmitted && _latestAttempt != null)
            _buildResultsView(miniTest, progress, _latestAttempt!, canAttempt)
          else
            _buildQuizView(miniTest, state),

          // Global Floating AI Tutor positioned safely above bottom navigation dock
          FloatingAITutorWidget(
            bottomOffset: 94,
            rightOffset: 16,
            contextualHomework: widget.assignment,
            isTestMode: true,
          ),
        ],
      ),
    );
  }

  // ================= 1. INTRO / START VIEW =================
  Widget _buildIntroView(
    HomeworkMiniTest miniTest,
    HomeworkStudentProgress progress,
    bool canAttempt,
  ) {
    final attemptsCount = progress.testAttempts.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pastel Bento Hero Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentMint.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ACADEMIC MASTERY CHECK',
                    style: AppTypography.caption(color: AppColors.accentMint).copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  miniTest.title,
                  style: AppTypography.headline(color: Colors.white).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  miniTest.description.isNotEmpty
                      ? miniTest.description
                      : 'Verify your understanding of this topic through this verified assessment.',
                  style: AppTypography.body(color: const Color(0xFFCBD5E1)).copyWith(
                    height: 1.35,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4-Item Bento Grid
          Row(
            children: [
              _buildBentoTile(
                icon: Icons.assignment_outlined,
                title: 'Questions',
                value: '${miniTest.questions.length} Items',
                accentColor: AppColors.accentCobalt,
              ),
              const SizedBox(width: 10),
              _buildBentoTile(
                icon: Icons.timer_outlined,
                title: 'Est. Time',
                value: '${miniTest.estimatedMinutes} Mins',
                accentColor: AppColors.accentTangerine,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildBentoTile(
                icon: Icons.verified_outlined,
                title: 'Passing Score',
                value: '${miniTest.passingPercentage}% Target',
                accentColor: const Color(0xFF10B981),
              ),
              const SizedBox(width: 10),
              _buildBentoTile(
                icon: Icons.replay_rounded,
                title: 'Attempts',
                value: '$attemptsCount of ${miniTest.maxAttempts} Used',
                accentColor: const Color(0xFF8B5CF6),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Integrity and Tutor Guardrails Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceSoft,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.bgSurfaceMuted),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification Integrity Rules',
                        style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Score at least ${miniTest.passingPercentage}% to satisfy homework verification.\n• Qrie AI Tutor is restricted to conceptual formula guidance only.\n• Direct answers and choice elimination are strictly blocked.',
                        style: AppTypography.caption(color: AppColors.textSecondary).copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          AppButton(
            text: canAttempt ? 'START VERIFICATION TEST' : 'MAX ATTEMPTS REACHED',
            isFullWidth: true,
            variant: canAttempt ? AppButtonVariant.primary : AppButtonVariant.outline,
            onPressed: canAttempt
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() => _hasStarted = true);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBentoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.caption(color: AppColors.textSecondary).copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTypography.body(color: AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 2. ACTIVE QUESTION VIEW =================
  Widget _buildQuizView(HomeworkMiniTest miniTest, StudentState state) {
    final questions = miniTest.questions;
    final q = questions[_currentQuestionIndex];
    final selectedOption = _selectedAnswers[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == questions.length - 1;
    final answeredAll = _selectedAnswers.length == questions.length;

    return Column(
      children: [
        // Top Progress Indicator
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / questions.length,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCobalt),
          minHeight: 3.5,
        ),

        // Question Navigator Header with Question Number, Tabs & Hint Trigger
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.bgSurfaceMuted),
                ),
                child: Text(
                  'QUESTION ${_currentQuestionIndex + 1} OF ${questions.length}',
                  style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Interactive Question Dots/Pills
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(questions.length, (idx) {
                    final isCurrent = idx == _currentQuestionIndex;
                    final isAnswered = _selectedAnswers.containsKey(idx);

                    Color dotColor;
                    if (isCurrent) {
                      dotColor = AppColors.accentCobalt;
                    } else if (isAnswered) {
                      dotColor = const Color(0xFF10B981);
                    } else {
                      dotColor = const Color(0xFFCBD5E1);
                    }

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _currentQuestionIndex = idx);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isCurrent ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dotColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Socratic Hint Launcher
              TextButton.icon(
                icon: const Icon(Icons.auto_awesome_rounded, size: 15, color: Color(0xFFD97706)),
                label: const Text('Hint', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w800, fontSize: 12)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _openQrieHint(context, state),
              ),
            ],
          ),
        ),

        // Question & Options Canvas
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (q.topic != null && q.topic!.isNotEmpty) ...[
                        Text(
                          q.topic!.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.accentCobalt,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        q.prompt,
                        style: AppTypography.headline(color: AppColors.textPrimary).copyWith(
                          fontSize: 17,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Options List
                ...List.generate(q.options.length, (optIndex) {
                  final isSelected = selectedOption == optIndex;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedAnswers[_currentQuestionIndex] = optIndex;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.accentCobalt : const Color(0xFFE2E8F0),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.accentCobalt.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.accentCobalt : AppColors.bgSurfaceSoft,
                              border: Border.all(
                                color: isSelected ? AppColors.accentCobalt : const Color(0xFFCBD5E1),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              String.fromCharCode(65 + optIndex),
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q.options[optIndex],
                              style: TextStyle(
                                color: isSelected ? AppColors.accentCobalt : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Navigation Footer Dock
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0x0F000000))),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (_currentQuestionIndex > 0) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: isLastQuestion
                      ? AppButton(
                          text: answeredAll
                              ? 'SUBMIT TEST'
                              : 'ANSWER ALL (${_selectedAnswers.length}/${questions.length})',
                          isFullWidth: true,
                          variant: AppButtonVariant.primary,
                          onPressed: answeredAll ? () => _submitTest(state) : null,
                        )
                      : AppButton(
                          text: 'NEXT QUESTION',
                          isFullWidth: true,
                          variant: AppButtonVariant.primary,
                          onPressed: selectedOption != null
                              ? () {
                                  setState(() => _currentQuestionIndex++);
                                }
                              : null,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= 3. COMPREHENSIVE RESULTS VIEW =================
  Widget _buildResultsView(
    HomeworkMiniTest miniTest,
    HomeworkStudentProgress progress,
    HomeworkTestAttempt attempt,
    bool canAttempt,
  ) {
    final passed = attempt.passed;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        children: [
          // Result Status Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: passed ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: passed ? const Color(0xFF32C787) : const Color(0xFFFCA5A5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (passed ? const Color(0xFF32C787) : const Color(0xFFEF4444)).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: passed ? const Color(0xFF32C787) : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    passed ? Icons.check_rounded : Icons.close_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  passed ? 'Verification Passed!' : 'Needs Review',
                  style: AppTypography.headline(
                    color: passed ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                  ).copyWith(fontSize: 21),
                ),
                const SizedBox(height: 6),
                Text(
                  passed
                      ? 'Congratulations! You have satisfied the verification test condition for this homework.'
                      : 'You scored below the ${miniTest.passingPercentage}% requirement. Review study notes and retry.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body(
                    color: passed ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                  ).copyWith(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 18),

                // Score Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: passed ? const Color(0xFF6EE7B7) : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${attempt.scorePercentage}%',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: passed ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${attempt.correctCount} of ${attempt.totalQuestions} Correct',
                            style: AppTypography.caption(color: AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Target: ${miniTest.passingPercentage}% Minimum',
                            style: AppTypography.caption(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Question by question explanation breakdown
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'QUESTION BREAKDOWN',
              style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(miniTest.questions.length, (idx) {
            final q = miniTest.questions[idx];
            final selected = _selectedAnswers[idx];
            final isCorrect = selected == q.correctIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCorrect ? const Color(0xFFE2E8F0) : const Color(0xFFFECACA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Question ${idx + 1}',
                          style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.prompt,
                    style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  if (!isCorrect && selected != null)
                    Text(
                      'Your answer: ${q.options[selected]}',
                      style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  Text(
                    'Correct answer: ${q.options[q.correctIndex]}',
                    style: const TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Explanation: ${q.explanation}',
                      style: AppTypography.caption(color: AppColors.textSecondary).copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),

          // If failed: Remediation Study Section
          if (!passed) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.menu_book_rounded, color: Color(0xFFD97706), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Recommended Remediation',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Review the chapter study notes and formula sheets before taking your next attempt.',
                    style: TextStyle(color: Color(0xFFB45309), fontSize: 12.5, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.auto_stories_rounded, size: 16),
                    label: const Text('Open Chapter Study Notes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      HomeworkStudyMaterialsSheet.show(context, widget.assignment);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Action Buttons
          if (passed)
            AppButton(
              text: 'RETURN TO HOMEWORK',
              isFullWidth: true,
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pop(context),
            )
          else ...[
            if (canAttempt)
              AppButton(
                text: 'RETRY MINI-TEST',
                isFullWidth: true,
                variant: AppButtonVariant.primary,
                onPressed: _restartTest,
              ),
            const SizedBox(height: 10),
            AppButton(
              text: 'BACK TO ASSIGNMENT',
              isFullWidth: true,
              variant: AppButtonVariant.outline,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ],
      ),
    );
  }
}
