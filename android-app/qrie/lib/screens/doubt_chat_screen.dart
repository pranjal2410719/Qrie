import 'package:flutter/material.dart';
import '../models/doubt_message.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class DoubtChatScreen extends StatefulWidget {
  const DoubtChatScreen({super.key});

  @override
  State<DoubtChatScreen> createState() => _DoubtChatScreenState();
}

class _DoubtChatScreenState extends State<DoubtChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(StudentState state, String text) {
    if (text.trim().isEmpty) return;
    state.addDoubt(text: text.trim());
    _textController.clear();
    _scrollToBottom();
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

  void _showSnapDoubtModal(StudentState state, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, color: primaryColor, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Snap Textbook Doubt',
                        style: AppTypography.headingSmall(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select or simulate camera capture of a textbook question:',
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                _buildSampleDoubtTile(
                  icon: Icons.functions_rounded,
                  title: 'Linear Equation Problem',
                  subtitle: 'Page 48, Ex 2.3: Solve 4(x - 3) = 28',
                  primaryColor: primaryColor,
                  onTap: () {
                    Navigator.pop(ctx);
                    state.addDoubt(
                      text: 'Can you solve this textbook equation: 4(x - 3) = 28 ?',
                    );
                    _scrollToBottom();
                  },
                ),
                const SizedBox(height: 10),
                _buildSampleDoubtTile(
                  icon: Icons.science_rounded,
                  title: 'Plant Anatomy & Cell Biology',
                  subtitle: 'Chloroplast structure, stroma, and grana functions',
                  primaryColor: primaryColor,
                  onTap: () {
                    Navigator.pop(ctx);
                    state.addDoubt(
                      text: 'What is the function of stroma and grana in chloroplasts?',
                    );
                    _scrollToBottom();
                  },
                ),
                const SizedBox(height: 16),
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
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.schoolMint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subheading(color: AppColors.textPrimary).copyWith(fontSize: 14),
                ),
                const SizedBox(height: 1),
                Text(subtitle, style: AppTypography.caption(color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDisabled),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final messages = state.doubtMessages;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // AI Tutor Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.schoolMint,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.psychology_rounded, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qrie AI Academic Tutor',
                        style: AppTypography.subheading(color: AppColors.textPrimary).copyWith(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Instant step-by-step doubt resolution',
                              style: AppTypography.caption(color: AppColors.textMuted),
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
                InkWell(
                  onTap: () => _showSnapDoubtModal(state, primaryColor),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'SNAP',
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageItem(context, msg, state, primaryColor);
              },
            ),
          ),

          // Quick Suggestion Chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSuggestionChip('Explain cell membrane', state, primaryColor),
                const SizedBox(width: 8),
                _buildSuggestionChip('Solve 3x - 5 = 16', state, primaryColor),
                const SizedBox(width: 8),
                _buildSuggestionChip('Photosynthesis equation', state, primaryColor),
                const SizedBox(width: 8),
                _buildSuggestionChip('Formula of pressure', state, primaryColor),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.2)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: primaryColor),
                    onPressed: () => _showSnapDoubtModal(state, primaryColor),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTypography.bodyMedium(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask any textbook question...',
                        hintStyle: AppTypography.bodySmall(color: AppColors.textDisabled),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 1.5),
                        ),
                      ),
                      onSubmitted: (text) => _sendMessage(state, text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'ASK',
                    height: 42,
                    variant: AppButtonVariant.primary,
                    icon: Icons.send_rounded,
                    onPressed: () => _sendMessage(state, _textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, StudentState state, Color primaryColor) {
    return InkWell(
      onTap: () => _sendMessage(state, label),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Text(
          label,
          style: AppTypography.caption(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    DoubtMessage msg,
    StudentState state,
    Color primaryColor,
  ) {
    final isStudent = msg.isStudent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        mainAxisAlignment: isStudent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isStudent) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.schoolMint,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_rounded, color: primaryColor, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isStudent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isStudent ? primaryColor : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isStudent ? primaryColor : AppColors.borderLight,
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: AppTypography.bodyMedium(
                      color: isStudent ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),

                // Formula or Key Concept Box
                if (msg.formulaOrSnippet != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.schoolMint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.25), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded, size: 16, color: primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              'CORE FORMULA / RULE',
                              style: AppTypography.caption(color: primaryColor).copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.formulaOrSnippet!,
                          style: AppTypography.subheading(color: AppColors.textPrimary).copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],

                // Follow up suggested chips
                if (msg.followUpSuggestions != null && msg.followUpSuggestions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: msg.followUpSuggestions!.map((sug) {
                      return InkWell(
                        onTap: () => _sendMessage(state, sug),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            sug,
                            style: AppTypography.caption(color: primaryColor).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
