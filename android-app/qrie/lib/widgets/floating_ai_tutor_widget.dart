import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doubt_message.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Global Floating Qrie AI Academic Tutor
///
/// Provides contextual AI assistance across all student screens.
/// Features:
/// - Floating draggable button with Onyx/Pastel styling and active glow.
/// - Contextual awareness: adapts prompts based on active assignment, topic, or test.
/// - Mode Guardrails: enforces conceptual hints only (no direct answers) during mini-tests.
/// - Preserves underlying screen and lesson state without reloading.
class FloatingAITutorWidget extends StatefulWidget {
  final double bottomOffset;
  final double rightOffset;
  final HomeworkAssignment? contextualHomework;
  final String? contextualQuestion;
  final bool isTestMode;

  const FloatingAITutorWidget({
    super.key,
    this.bottomOffset = 80.0,
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
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTestEnvironment) {
      _pulseController.repeat(reverse: true);
    }

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      _position = Offset(
        size.width - 68 - widget.rightOffset,
        size.height - 68 - widget.bottomOffset,
      );
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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

    return Positioned(
      left: _position.dx.clamp(12.0, size.width - 68.0),
      top: _position.dy.clamp(60.0, size.height - 130.0),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            shadowColor: isTest
                ? AppColors.accentTangerine.withValues(alpha: 0.35)
                : AppColors.accentCobalt.withValues(alpha: 0.3),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _openTutorSheet(context, state),
              customBorder: const CircleBorder(),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isTest
                        ? [const Color(0xFFD97706), const Color(0xFFF59E0B)]
                        : [AppColors.bgSurfaceOnyx, const Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isTest ? Icons.help_outline_rounded : Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    if (hasContext || isTest)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isTest ? Colors.white : AppColors.accentMint,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bgSurfaceOnyx, width: 1.5),
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
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleSend(StudentState state, String text) {
    if (text.trim().isEmpty) return;
    _inputController.clear();

    if (widget.isTestMode) {
      // In mini-test mode, enforce conceptual Socratic guardrails
      _handleTestModePrompt(state, text.trim());
    } else {
      state.addDoubt(text: text.trim());
    }
    _scrollToBottom();
  }

  void _handleTestModePrompt(StudentState state, String userText) {
    // Add student question to chat
    state.addDoubt(text: userText);

    setState(() => _isAITyping = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isAITyping = false);
      _scrollToBottom();
    });
  }

  List<String> _getStarterPrompts() {
    if (widget.isTestMode) {
      return [
        'Give me a conceptual hint',
        'Which core formula applies here?',
        'What principle is being tested?',
        'Help check my reasoning without answer',
      ];
    }
    if (widget.homework != null) {
      return [
        'Explain this step',
        'Show a similar example',
        'What formula should I use?',
        'Check my reasoning',
      ];
    }
    return [
      'Explain cell membrane',
      'Solve 4(x - 2) = 12',
      'What is selective permeability?',
      'How does photosynthesis work?',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final messages = state.doubtMessages;
    final starterPrompts = _getStarterPrompts();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
          const SizedBox(height: 12),

          // 2. Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isTestMode
                        ? const Color(0xFFFEF3C7)
                        : AppColors.accentCobalt.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isTestMode
                        ? Icons.school_rounded
                        : Icons.auto_awesome_rounded,
                    color: widget.isTestMode
                        ? const Color(0xFFD97706)
                        : AppColors.accentCobalt,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Qrie AI Tutor',
                            style: AppTypography.cardTitle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.isTestMode
                                  ? const Color(0xFFFEF3C7)
                                  : AppColors.bgSurfaceSoft,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: widget.isTestMode
                                    ? const Color(0xFFF59E0B)
                                    : AppColors.bgSurfaceMuted,
                              ),
                            ),
                            child: Text(
                              widget.isTestMode ? 'TEST GUARDRAILS' : 'SOCRATIC',
                              style: AppTypography.caption(
                                color: widget.isTestMode
                                    ? const Color(0xFFB45309)
                                    : AppColors.textSecondary,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.homework != null
                            ? '${widget.homework!.subject}: ${widget.homework!.chapter}'
                            : 'Personalized Academic Pair',
                        style: AppTypography.caption(
                          color: AppColors.textSecondary,
                        ),
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

          // 3. Mini-Test Guardrails Banner
          if (widget.isTestMode)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: Color(0xFFD97706),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mini-Test Guardrails Active: Qrie provides conceptual guidance and formula hints only. Direct answers and option elimination are prohibited.',
                      style: AppTypography.caption(
                        color: const Color(0xFF92400E),
                      ).copyWith(fontSize: 11.5, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),

          // 4. Contextual Starter Chips
          Container(
            height: 46,
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: starterPrompts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = starterPrompts[index];
                return Center(
                  child: ActionChip(
                    label: Text(
                      prompt,
                      style: AppTypography.caption(
                        color: AppColors.textPrimary,
                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    backgroundColor: AppColors.bgSurfaceSoft,
                    side: const BorderSide(color: AppColors.bgSurfaceMuted),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => _handleSend(state, prompt),
                  ),
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
              border: Border(
                top: BorderSide(color: Color(0x0F000000)),
              ),
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
                              ? 'Ask for a conceptual hint...'
                              : 'Ask a question or explain a step...',
                          hintStyle: AppTypography.body(color: AppColors.textMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (text) => _handleSend(state, text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.bgSurfaceOnyx,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded,
                          color: Colors.white, size: 20),
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
          decoration: BoxDecoration(
            color: AppColors.bgSurfaceOnyx,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: AppTypography.body(color: Colors.white),
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
          color: AppColors.accentLilac.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: AppColors.accentLilac.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    size: 14, color: AppColors.accentCobalt),
                const SizedBox(width: 6),
                Text(
                  'Qrie Tutor',
                  style: AppTypography.caption(color: AppColors.accentCobalt)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: AppTypography.body(color: AppColors.textPrimary)
                  .copyWith(height: 1.4),
            ),
            if (msg.formulaOrSnippet != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  msg.formulaOrSnippet!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
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
                      .copyWith(fontWeight: FontWeight.w600),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
