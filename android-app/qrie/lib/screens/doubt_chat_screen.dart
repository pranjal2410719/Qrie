import 'package:flutter/material.dart';
import '../models/doubt_message.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/mascot_avatar.dart';

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

  void _showSnapDoubtModal(StudentState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                      color: AppColors.lineGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.camera_alt_rounded, color: AppColors.sparkBlue, size: 28),
                    const SizedBox(width: 10),
                    Text('Snap Textbook Doubt', style: AppTypography.headingSmall()),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Select or simulate photo capture of a question from your textbook:',
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 16),
                _buildSampleDoubtTile(
                  icon: Icons.functions_rounded,
                  title: 'Quadratic & Linear Equation Problem',
                  subtitle: 'Page 48, Ex 2.3: Solve 4(x - 3) = 28',
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
                  title: 'Plant Anatomy Diagram Problem',
                  subtitle: 'Label parts of chloroplast in diagram',
                  onTap: () {
                    Navigator.pop(ctx);
                    state.addDoubt(
                      text: 'What is the function of stroma and grana in chloroplasts?',
                    );
                    _scrollToBottom();
                  },
                ),
                const SizedBox(height: 16),
                DuolingoButton(
                  text: 'CLOSE',
                  fullWidth: true,
                  style: DuolingoButtonStyle.outlineGray,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cloudGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lineGray, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.storybookGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.eagerGreenDark, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.pillLabel(color: AppColors.charcoal)),
                  Text(subtitle, style: AppTypography.caption()),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.pencilGray),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final messages = state.doubtMessages;

    return Column(
      children: [
        // AI Tutor Status Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.cloudGray,
            border: Border(bottom: BorderSide(color: AppColors.lineGray, width: 1.5)),
          ),
          child: Row(
            children: [
              const MascotAvatar(size: 32, expression: MascotExpression.studying),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qrie AI Tutor', style: AppTypography.pillLabel(color: AppColors.charcoal)),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.eagerGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '24/7 Step-by-Step Doubt Resolution',
                            style: AppTypography.caption(color: AppColors.pencilGray),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.paperWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.sparkBlue, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt_rounded, size: 16, color: AppColors.sparkBlue),
                      const SizedBox(width: 4),
                      Text('SNAP', style: AppTypography.buttonLabel(color: AppColors.sparkBlue).copyWith(fontSize: 11)),
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
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return _buildMessageItem(context, msg, state);
            },
          ),
        ),

        // Quick Suggestion Chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildSuggestionChip('Explain cell membrane', state),
              const SizedBox(width: 8),
              _buildSuggestionChip('Solve 3x - 5 = 16', state),
              const SizedBox(width: 8),
              _buildSuggestionChip('Why is the sky blue?', state),
              const SizedBox(width: 8),
              _buildSuggestionChip('Formula of pressure', state),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Input Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.paperWhite,
            border: Border(top: BorderSide(color: AppColors.lineGray, width: 2)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_rounded, color: AppColors.sparkBlue),
                  onPressed: () => _showSnapDoubtModal(state),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your doubt or question...',
                      hintStyle: AppTypography.bodySmall(color: AppColors.pencilGray),
                      filled: true,
                      fillColor: AppColors.cloudGray,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.lineGray, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.lineGray, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.eagerGreen, width: 2),
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(state, text),
                  ),
                ),
                const SizedBox(width: 8),
                DuolingoButton(
                  text: 'ASK',
                  height: 44,
                  borderRadius: 12,
                  style: DuolingoButtonStyle.primaryGreen,
                  icon: Icons.send_rounded,
                  onPressed: () => _sendMessage(state, _textController.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String label, StudentState state) {
    return GestureDetector(
      onTap: () {
        _sendMessage(state, label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.paperWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lineGray, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTypography.caption(color: AppColors.charcoal),
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, DoubtMessage msg, StudentState state) {
    final isStudent = msg.isStudent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isStudent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isStudent) ...[
            const MascotAvatar(size: 38, expression: MascotExpression.happy),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isStudent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isStudent ? AppColors.sparkBlue : AppColors.paperWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isStudent ? AppColors.sparkBlueDark : AppColors.lineGray,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isStudent ? AppColors.sparkBlueDark : AppColors.lineGray).withValues(alpha: 0.4),
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: AppTypography.bodySmall(
                      color: isStudent ? AppColors.paperWhite : AppColors.charcoal,
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
                      color: AppColors.storybookGreen.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.freshLeaf, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded, size: 16, color: AppColors.eagerGreenDark),
                            const SizedBox(width: 4),
                            Text('KEY FORMULA', style: AppTypography.caption(color: AppColors.eagerGreenDark)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.formulaOrSnippet!,
                          style: AppTypography.buttonLabel(color: AppColors.nightInk).copyWith(fontSize: 13),
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
                      return GestureDetector(
                        onTap: () => _sendMessage(state, sug),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.cloudGray,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.sparkBlue.withValues(alpha: 0.4), width: 1.5),
                          ),
                          child: Text(
                            sug,
                            style: AppTypography.caption(color: AppColors.sparkBlue),
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
