import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doubt_message.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_chip.dart';
import 'dynamic_wavy_blob.dart';

/// Global Qrie AI Academic Tutor
///
/// Features:
/// - Screen-bounded positioning via LayoutBuilder (can NEVER leave the viewport).
/// - Magnetic edge-snapping on drag release with boundary protection.
/// - Tactile pill capsule design with glowing status indicator.
/// - Clean, smooth, student-friendly conversational sheet.
/// - Socratic & Mini-Test Guardrails mode (conceptual clues, no direct answers).
/// - Formula rendering, follow-up suggestion chips, and typing indicator.
class FloatingAITutorWidget extends StatefulWidget {
  final double bottomOffset;
  final double rightOffset;
  final HomeworkAssignment? contextualHomework;
  final String? contextualQuestion;
  final bool isTestMode;

  const FloatingAITutorWidget({
    super.key,
    this.bottomOffset = 24.0,
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
  Offset? _position;
  late AnimationController _snapController;
  late Animation<Offset> _snapAnimation;

  static const double _buttonSize = 52.0;
  static const double _horizontalPadding = 14.0;
  static const double _verticalPadding = 12.0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _snapToNearestEdge(double maxW, double maxH) {
    if (_position == null) return;
    final minX = _horizontalPadding;
    final maxX = (maxW - _buttonSize - _horizontalPadding).clamp(minX, double.infinity);
    final targetX = (_position!.dx + _buttonSize / 2 < maxW / 2) ? minX : maxX;

    final minY = _verticalPadding;
    final maxY = (maxH - _buttonSize - _verticalPadding).clamp(minY, double.infinity);
    final targetY = _position!.dy.clamp(minY, maxY);

    final start = _position!;
    final end = Offset(targetX, targetY);

    _snapAnimation = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
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
    final hasContext = widget.contextualHomework != null || state.activeHomeworkContext != null || widget.isTestMode || state.isTestGuardrailActive;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;

          if (maxW <= 0 || maxH <= 0) return const SizedBox.shrink();

          final defaultX = (maxW - _buttonSize - widget.rightOffset).clamp(
            _horizontalPadding,
            (maxW - _buttonSize - _horizontalPadding).clamp(_horizontalPadding, double.infinity),
          );
          final defaultY = (maxH - _buttonSize - widget.bottomOffset).clamp(
            _verticalPadding,
            (maxH - _buttonSize - _verticalPadding).clamp(_verticalPadding, double.infinity),
          );

          if (_position == null) {
            _position = Offset(defaultX, defaultY);
          } else {
            // Re-clamp strictly within bounds whenever layout changes
            final safeX = _position!.dx.clamp(
              _horizontalPadding,
              (maxW - _buttonSize - _horizontalPadding).clamp(_horizontalPadding, double.infinity),
            );
            final safeY = _position!.dy.clamp(
              _verticalPadding,
              (maxH - _buttonSize - _verticalPadding).clamp(_verticalPadding, double.infinity),
            );
            if (safeX != _position!.dx || safeY != _position!.dy) {
              _position = Offset(safeX, safeY);
            }
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: _position!.dx,
                top: _position!.dy,
                child: RepaintBoundary(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final newX = (_position!.dx + details.delta.dx).clamp(
                          _horizontalPadding,
                          (maxW - _buttonSize - _horizontalPadding).clamp(_horizontalPadding, double.infinity),
                        );
                        final newY = (_position!.dy + details.delta.dy).clamp(
                          _verticalPadding,
                          (maxH - _buttonSize - _verticalPadding).clamp(_verticalPadding, double.infinity),
                        );
                        _position = Offset(newX, newY);
                      });
                    },
                    onPanEnd: (_) => _snapToNearestEdge(maxW, maxH),
                    child: GestureDetector(
                      onTap: () => _openTutorSheet(context, state),
                      child: DynamicWavyBlob(
                        size: _buttonSize,
                        hasActiveContext: hasContext,
                        isTestMode: widget.isTestMode || state.isTestGuardrailActive,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
  bool _hasInputText = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _hasInputText) {
        setState(() => _hasInputText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 140), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 240),
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
      subtitle = 'Personalized Socratic Academic Partner';
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // 1. Drag Handle
          const SizedBox(height: 10),
          Container(
            width: 38,
            height: 4.5,
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceMuted,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),

          // 2. Clean Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Qrie Avatar with Dynamic Wavy Boundary
                DynamicWavyBlob(
                  size: 38,
                  hasActiveContext: widget.homework != null,
                  isTestMode: widget.isTestMode,
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
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFBFDBFE),
                              ),
                            ),
                            child: const Text(
                              'SOCRATIC',
                              style: TextStyle(
                                color: Color(0xFF1D4ED8),
                                fontSize: 9.0,
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
                // Reset / Clear Chat button
                IconButton(
                  icon: const Icon(Icons.restart_alt_rounded, size: 20, color: AppColors.textSecondary),
                  tooltip: 'Reset Conversation',
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    state.clearDoubtHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Conversation reset to fresh state',
                          style: AppTypography.bodySmall(color: Colors.white),
                        ),
                        backgroundColor: AppColors.bgSurfaceOnyx,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 3. Mini-Test Guardrails / Active Context Banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 14,
                  color: AppColors.accentCobalt,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isTestMode
                        ? 'Verification Guidance: Conceptual clues & formulas active'
                        : 'Study Context: ${widget.homework?.title ?? "General Academic Doubt Resolution"}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 4. Contextual Starter Chips with Edge Blur
          SizedBox(
            height: 40,
            child: BlurredEdgeScroll(
              fadeWidth: 18,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: starterPrompts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = starterPrompts[index];
                  return ChoiceChip(
                    avatar: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: AppColors.accentCobalt,
                    ),
                    label: Text(prompt),
                    selected: false,
                    onSelected: (_) => _handleSend(state, prompt),
                    backgroundColor: AppColors.bgSurfaceSoft,
                    side: const BorderSide(
                      color: AppColors.bgSurfaceMuted,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelStyle: const TextStyle(
                      fontFamily: AppTypography.primaryFont,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1, color: Color(0x0F000000)),

          // 5. Chat History
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length + (_isAITyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return _buildTypingBubble();
                }
                final msg = messages[index];
                return _buildMessageBubble(msg, state);
              },
            ),
          ),

          // 6. Smooth Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(14, 8, 14, 8 + bottomInset),
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
                        style: AppTypography.body(color: AppColors.textPrimary)
                            .copyWith(fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: widget.isTestMode
                              ? 'Ask for a conceptual clue or formula...'
                              : 'Ask a doubt or explain a step...',
                          hintStyle: AppTypography.body(color: AppColors.textMuted)
                              .copyWith(fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (text) => _handleSend(state, text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _hasInputText ? AppColors.accentCobalt : AppColors.bgSurfaceOnyx,
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

  Widget _buildMessageBubble(DoubtMessage msg, StudentState state) {
    if (msg.isStudent) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(top: 4, bottom: 8, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 290),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 8, right: 36),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/Q_logo.png',
                      width: 16,
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Qrie AI Tutor',
                  style: TextStyle(
                    color: AppColors.accentCobalt,
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
                height: 1.42,
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
                  color: AppColors.accentMint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '💡 ${msg.keyConcept}',
                  style: AppTypography.caption(color: const Color(0xFF065F46))
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ),
            ],
            if (msg.followUpSuggestions != null && msg.followUpSuggestions!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.followUpSuggestions!.map((suggestion) {
                  return InkWell(
                    onTap: () => _handleSend(state, suggestion),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_forward_rounded, size: 10, color: AppColors.accentCobalt),
                          const SizedBox(width: 4),
                          Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentCobalt,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
        margin: const EdgeInsets.only(top: 4, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bgSurfaceMuted),
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
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
