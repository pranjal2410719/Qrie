import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doubt_message.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Global Floating Qrie AI Academic Tutor
///
/// Features:
/// - Magnetic edge-snapping on drag release (left/right dock).
/// - RepaintBoundary isolation to eliminate frame drops and buffer queue delays.
/// - Socratic & Mini-Test Guardrails mode (conceptual clues, no direct answers).
/// - Rich conversational sheet with syntax-highlighted formulas and topic pills.
/// - Contextual awareness for active homework assignments and quiz questions.
class FloatingAITutorWidget extends StatefulWidget {
  final double bottomOffset;
  final double rightOffset;
  final HomeworkAssignment? contextualHomework;
  final String? contextualQuestion;
  final bool isTestMode;

  const FloatingAITutorWidget({
    super.key,
    this.bottomOffset = 84.0,
    this.rightOffset = 16.0,
    this.contextualHomework,
    this.contextualQuestion,
    this.isTestMode = false,
  });

  @override
  State<FloatingAITutorWidget> createState() => _FloatingAITutorWidgetState();
}

class _FloatingAITutorWidgetState extends State<FloatingAITutorWidget>
    with SingleTickerProviderStateMixin {
  late Offset _position;
  bool _initialized = false;
  late AnimationController _snapController;
  late Animation<Offset> _snapAnimation;

  static const double _buttonSize = 54.0;
  static const double _margin = 14.0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      final defaultX = size.width - _buttonSize - widget.rightOffset;
      final defaultY = (size.height - _buttonSize - widget.bottomOffset).clamp(
        60.0,
        size.height - _buttonSize - 20.0,
      );
      _position = Offset(defaultX, defaultY);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _snapToNearestEdge(Size size) {
    final targetX = (_position.dx + _buttonSize / 2 < size.width / 2)
        ? _margin
        : size.width - _buttonSize - _margin;

    final targetY = _position.dy.clamp(
      70.0,
      size.height - _buttonSize - widget.bottomOffset.clamp(20.0, 140.0),
    );

    final start = _position;
    final end = Offset(targetX, targetY);

    _snapAnimation = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutBack),
    );

    _snapController.reset();
    _snapAnimation.addListener(() {
      setState(() {
        _position = _snapAnimation.value;
      });
    });
    _snapController.forward();
  }

  void _openTutorSheet(BuildContext context, StudentState state) {
    HapticFeedback.mediumImpact();
    final homework = widget.contextualHomework ?? state.activeHomeworkContext;
    final question = widget.contextualQuestion ?? state.activeQuestionContext;
    final isTest = widget.isTestMode || state.isTestGuardrailActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TutorSheetContent(
        homework: homework,
        question: question,
        isTestMode: isTest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final size = MediaQuery.of(context).size;
    final isTest = widget.isTestMode || state.isTestGuardrailActive;
    final hasContext = widget.contextualHomework != null || state.activeHomeworkContext != null;

    final clampedX = _position.dx.clamp(_margin, size.width - _buttonSize - _margin);
    final clampedY = _position.dy.clamp(60.0, size.height - _buttonSize - 20.0);

    return Positioned(
      left: clampedX,
      top: clampedY,
      child: RepaintBoundary(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _position += details.delta;
            });
          },
          onPanEnd: (_) => _snapToNearestEdge(size),
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            shadowColor: isTest
                ? const Color(0xFFD97706).withValues(alpha: 0.35)
                : AppColors.bgSurfaceOnyx.withValues(alpha: 0.35),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _openTutorSheet(context, state),
              customBorder: const CircleBorder(),
              child: Container(
                width: _buttonSize,
                height: _buttonSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isTest
                        ? const [Color(0xFFD97706), Color(0xFFF59E0B)]
                        : const [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isTest
                        ? const Color(0xFFFDE68A)
                        : Colors.white.withValues(alpha: 0.22),
                    width: 1.8,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isTest ? Icons.shield_rounded : Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    // Active indicator dot
                    if (hasContext || isTest)
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: isTest ? Colors.white : const Color(0xFF32C787),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isTest ? const Color(0xFFD97706) : const Color(0xFF0F172A),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorSheetContent extends StatefulWidget {
  final HomeworkAssignment? homework;
  final String? question;
  final bool isTestMode;

  const _TutorSheetContent({
    this.homework,
    this.question,
    required this.isTestMode,
  });

  @override
  State<_TutorSheetContent> createState() => _TutorSheetContentState();
}

class _TutorSheetContentState extends State<_TutorSheetContent> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAITyping = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 160), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleSend(StudentState state, String text) {
    if (text.trim().isEmpty) return;
    final query = text.trim();
    _inputController.clear();
    HapticFeedback.selectionClick();

    setState(() => _isAITyping = true);

    state.addDoubt(
      text: query,
      isTestMode: widget.isTestMode,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isAITyping = false);
        _scrollToBottom();
      }
    });

    _scrollToBottom();
  }

  List<String> _getStarterPrompts() {
    if (widget.isTestMode) {
      return [
        'Give me a conceptual clue',
        'Which core formula applies here?',
        'How do the variables relate?',
        'Help check my reasoning without answer',
      ];
    }
    if (widget.homework != null) {
      return [
        'Explain this problem step-by-step',
        'What formula should I apply?',
        'Show a similar practice example',
        'How do I verify my answer?',
      ];
    }
    return [
      'Explain Ohm\'s law & resistance',
      'Solve linear equations substitution',
      'What is ATP in cellular respiration?',
      'How does photosynthesis work?',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final messages = state.doubtMessages;
    final starterPrompts = _getStarterPrompts();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    String subtitle;
    if (widget.isTestMode) {
      subtitle = 'Topic Verification • Guardrails Active';
    } else if (widget.homework != null) {
      subtitle = '${widget.homework!.subject}: ${widget.homework!.chapter}';
    } else {
      subtitle = 'Personalized Socratic Academic Pair';
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // 1. Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceMuted,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),

          // 2. Header Bar with Flexible text to prevent RenderFlex overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.isTestMode
                        ? const Color(0xFFFEF3C7)
                        : AppColors.accentCobalt.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isTestMode ? Icons.shield_rounded : Icons.auto_awesome_rounded,
                    color: widget.isTestMode ? const Color(0xFFD97706) : AppColors.accentCobalt,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Qrie AI Tutor',
                              style: AppTypography.cardTitle(color: AppColors.textPrimary)
                                  .copyWith(fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.isTestMode
                                  ? const Color(0xFFFEF3C7)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: widget.isTestMode
                                    ? const Color(0xFFFDE68A)
                                    : const Color(0xFFBFDBFE),
                              ),
                            ),
                            child: Text(
                              widget.isTestMode ? 'GUARDRAILS' : 'SOCRATIC',
                              style: TextStyle(
                                color: widget.isTestMode
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF1D4ED8),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: AppTypography.caption(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // 3. Mini-Test Guardrails / Active Context Banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isTestMode ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isTestMode ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isTestMode ? Icons.shield_outlined : Icons.menu_book_rounded,
                  size: 15,
                  color: widget.isTestMode ? const Color(0xFFD97706) : AppColors.accentCobalt,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isTestMode
                        ? 'Test Integrity: Qrie provides conceptual formula hints only. Direct answers are locked.'
                        : 'Current Study Context: ${widget.homework?.title ?? "General Academic Doubt"}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.isTestMode ? const Color(0xFF92400E) : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 4. Contextual Starter Chips
          Container(
            height: 42,
            margin: const EdgeInsets.only(top: 6, bottom: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: starterPrompts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = starterPrompts[index];
                return ActionChip(
                  label: Text(
                    prompt,
                    style: TextStyle(
                      color: widget.isTestMode ? const Color(0xFF92400E) : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                  backgroundColor: widget.isTestMode
                      ? const Color(0xFFFEF3C7).withValues(alpha: 0.6)
                      : AppColors.bgSurfaceSoft,
                  side: BorderSide(
                    color: widget.isTestMode ? const Color(0xFFFDE68A) : AppColors.bgSurfaceMuted,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  onPressed: () => _handleSend(state, prompt),
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0x0F000000)),

          // 5. Chat History
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length + (_isAITyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return _buildTypingBubble();
                }
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // 6. Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomInset),
            decoration: const BoxDecoration(
              color: AppColors.bgCanvas,
              border: Border(top: BorderSide(color: Color(0x0F000000))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurfaceSoft,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.bgSurfaceMuted),
                      ),
                      child: TextField(
                        controller: _inputController,
                        style: AppTypography.body(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: widget.isTestMode
                              ? 'Ask for a conceptual formula hint...'
                              : 'Ask a question or explain a step...',
                          hintStyle: AppTypography.body(color: AppColors.textMuted).copyWith(fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (text) => _handleSend(state, text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.bgSurfaceOnyx,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                      onPressed: () => _handleSend(state, _inputController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(DoubtMessage msg) {
    if (msg.isStudent) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 290),
          decoration: const BoxDecoration(
            color: AppColors.bgSurfaceOnyx,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: AppTypography.body(color: Colors.white).copyWith(fontSize: 13),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: widget.isTestMode
              ? const Color(0xFFFEF3C7).withValues(alpha: 0.3)
              : AppColors.accentLilac.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: widget.isTestMode
                ? const Color(0xFFFDE68A)
                : AppColors.accentLilac.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isTestMode ? Icons.shield_rounded : Icons.auto_awesome_rounded,
                  size: 14,
                  color: widget.isTestMode ? const Color(0xFFD97706) : AppColors.accentCobalt,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.isTestMode ? 'Qrie Guardrail Hint' : 'Qrie Tutor',
                  style: TextStyle(
                    color: widget.isTestMode ? const Color(0xFFD97706) : AppColors.accentCobalt,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: AppTypography.body(color: AppColors.textPrimary).copyWith(
                height: 1.4,
                fontSize: 13,
              ),
            ),
            if (msg.formulaOrSnippet != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  msg.formulaOrSnippet!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
            if (msg.keyConcept != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentMint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '💡 Concept: ${msg.keyConcept}',
                  style: AppTypography.caption(color: const Color(0xFF065F46))
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accentCobalt,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Qrie is thinking...',
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
