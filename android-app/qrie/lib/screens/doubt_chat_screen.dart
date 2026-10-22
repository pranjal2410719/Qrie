import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doubt_message.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_chip.dart';
import '../widgets/dynamic_wavy_blob.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// Doubt Chat Screen with High-Contrast Onyx student bubbles,
/// soft pastel AI bubbles, and pill-shaped interactive chips.
class DoubtChatScreen extends StatefulWidget {
  const DoubtChatScreen({super.key});

  @override
  State<DoubtChatScreen> createState() => _DoubtChatScreenState();
}

class _DoubtChatScreenState extends State<DoubtChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;

  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _dotControllers[i].reverse();
          } else if (status == AnimationStatus.dismissed) {
            _dotControllers[i].forward();
          }
        });
    });

    _dotAnimations = _dotControllers
        .map((c) => Tween<double>(begin: 0.0, end: -6.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();
  }

  void _startTypingAnimation() {
    for (int i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 140), () {
        if (mounted && _isTyping) {
          _dotControllers[i].forward();
        }
      });
    }
  }

  void _stopTypingAnimation() {
    for (final ctrl in _dotControllers) {
      ctrl.reset();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    for (final ctrl in _dotControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _sendMessage(StudentState state, String text) {
    if (text.trim().isEmpty) return;
    state.addDoubt(text: text.trim());
    _textController.clear();
    _scrollToBottom();

    // Show typing indicator
    setState(() => _isTyping = true);
    _startTypingAnimation();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        _stopTypingAnimation();
        setState(() => _isTyping = false);
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnapDoubtModal(StudentState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCanvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.accentPeriwinkle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: AppColors.bgSurfaceOnyx, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Snap Textbook Doubt',
                            style: AppTypography.cardTitle(
                                color: AppColors.textPrimary),
                          ),
                          Text(
                            'Select or simulate camera capture of a question',
                            style: AppTypography.caption(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildSampleDoubtTile(
                  icon: Icons.functions_rounded,
                  title: 'Linear Equation Problem',
                  subtitle: 'Page 48, Ex 2.3: Solve 4(x - 3) = 28',
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(state,
                        'Can you solve this textbook equation: 4(x - 3) = 28 ?');
                  },
                ),
                const SizedBox(height: 10),
                _buildSampleDoubtTile(
                  icon: Icons.science_rounded,
                  title: 'Plant Anatomy & Cell Biology',
                  subtitle:
                      'Chloroplast structure, stroma, and grana functions',
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(state,
                        'What is the function of stroma and grana in chloroplasts?');
                  },
                ),
                const SizedBox(height: 18),
                AppButton(
                  text: 'CLOSE',
                  isFullWidth: true,
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSampleDoubtTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      borderRadius: DesignTokens.radiusCardMd,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentCobalt.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentCobalt, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subheading(
                          color: AppColors.textPrimary)
                      .copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTypography.caption(
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final messages = state.doubtMessages;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          // ── Top AI Tutor Status Bar ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.bgCanvas,
              boxShadow: [
                BoxShadow(
                  color: Color(0x080D0D11),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const DynamicWavyBlob(
                  size: 40,
                  hasActiveContext: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qrie AI Academic Tutor',
                        style: AppTypography.cardTitle(
                                color: AppColors.textPrimary)
                            .copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.accentMint,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Instant step-by-step doubt resolution',
                              style: AppTypography.caption(
                                  color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Snap Doubt Quick Button
                GestureDetector(
                  onTap: () => _showSnapDoubtModal(state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accentPeriwinkle.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            size: 15, color: AppColors.bgSurfaceOnyx),
                        const SizedBox(width: 5),
                        Text(
                          'SNAP',
                          style: AppTypography.caption(
                                  color: AppColors.bgSurfaceOnyx)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Chat message list ──────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = messages[index];
                return _buildMessageItem(context, msg, state);
              },
            ),
          ),

          // ── Quick Suggestion Chips with Blurred Edge Fade ──────────────────
          SizedBox(
            height: 40,
            child: BlurredEdgeScroll(
              fadeWidth: 20,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSuggestionChip('Explain cell membrane', state),
                  const SizedBox(width: 8),
                  _buildSuggestionChip('Solve 3x - 5 = 16', state),
                  const SizedBox(width: 8),
                  _buildSuggestionChip('Photosynthesis equation', state),
                  const SizedBox(width: 8),
                  _buildSuggestionChip('Formula of pressure', state),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Input bar ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.bgCanvas,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A0D0D11),
                  offset: Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: AppColors.textSecondary),
                    onPressed: () => _showSnapDoubtModal(state),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgSurfaceSoft,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: AppTypography.body(
                            color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Ask any textbook question...',
                          hintStyle: AppTypography.body(
                              color: AppColors.textMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (text) => _sendMessage(state, text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(state, _textController.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.bgSurfaceOnyx,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_upward_rounded,
                            color: Colors.white, size: 22),
                      ),
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

  // ── Typing indicator ───────────────────────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF38BDF8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceSoft,
              borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _dotAnimations[i],
                  builder: (_, _) => Transform.translate(
                    offset: Offset(0, _dotAnimations[i].value),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 5.0 : 0.0),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, StudentState state) {
    return ChoiceChip(
      avatar: const Icon(
        Icons.auto_awesome_rounded,
        size: 14,
        color: AppColors.accentCobalt,
      ),
      label: Text(label),
      selected: false,
      onSelected: (_) {
        HapticFeedback.selectionClick();
        _sendMessage(state, label);
      },
      backgroundColor: const Color(0xFFF1F5F9),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999),
      ),
      labelStyle: AppTypography.caption(color: AppColors.textPrimary)
          .copyWith(fontWeight: FontWeight.w600, fontSize: 12),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    DoubtMessage msg,
    StudentState state,
  ) {
    final isStudent = msg.isStudent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        mainAxisAlignment:
            isStudent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isStudent) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/Q_logo.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isStudent
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Chat bubble: Pitch Onyx for student, soft gray for AI
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isStudent
                        ? AppColors.bgSurfaceOnyx
                        : AppColors.bgSurfaceSoft,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight: isStudent ? const Radius.circular(4) : null,
                      bottomLeft: !isStudent ? const Radius.circular(4) : null,
                    ),
                    boxShadow: isStudent ? DesignTokens.shadowSoft : null,
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontFamily: AppTypography.primaryFont,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: isStudent ? FontWeight.w500 : FontWeight.w400,
                      color: isStudent
                          ? AppColors.textOnOnyx
                          : AppColors.textPrimary,
                    ),
                  ),
                ),

                // Formula / snippet block
                if (msg.formulaOrSnippet != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accentMintSoft.withValues(alpha: 0.40),
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusCardMd),
                      border: Border.all(
                          color: AppColors.accentMint.withValues(alpha: 0.35),
                          width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                size: 16, color: AppColors.accentMint),
                            const SizedBox(width: 6),
                            Text(
                              'CORE FORMULA / RULE',
                              style: AppTypography.caption(
                                      color: AppColors.accentMint)
                                  .copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          msg.formulaOrSnippet!,
                          style: AppTypography.subheading(
                                  color: AppColors.textPrimary)
                              .copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],

                // Follow-up chips
                if (msg.followUpSuggestions != null &&
                    msg.followUpSuggestions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: msg.followUpSuggestions!.map((sug) {
                      return GestureDetector(
                        onTap: () => _sendMessage(state, sug),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurfaceSoft,
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                                color: AppColors.bgSurfaceMuted, width: 1.0),
                          ),
                          child: Text(
                            sug,
                            style: AppTypography.caption(
                                    color: AppColors.textPrimary)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          if (isStudent) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
