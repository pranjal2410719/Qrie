import 'package:flutter/material.dart';
import '../../models/student_notification.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import '../homework_detail_screen.dart';
import '../quiz_solver_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _activeFilter = 'All';

  final List<String> _filters = ['All', 'Unread', 'Academic', 'Announcements'];

  List<StudentNotification> _getFilteredNotifications(List<StudentNotification> all) {
    switch (_activeFilter) {
      case 'Unread':
        return all.where((n) => !n.isRead).toList();
      case 'Academic':
        return all
            .where((n) =>
                n.type == NotificationType.homework ||
                n.type == NotificationType.liveClass ||
                n.type == NotificationType.exam)
            .toList();
      case 'Announcements':
        return all
            .where((n) =>
                n.type == NotificationType.schoolNotice ||
                n.type == NotificationType.streak)
            .toList();
      case 'All':
      default:
        return all;
    }
  }

  void _handleNotificationTap(BuildContext context, StudentNotification notif, StudentState state) {
    state.markNotificationAsRead(notif.id);

    if (notif.type == NotificationType.homework) {
      final hw = state.homeworkAssignments.firstWhere(
        (h) => h.id == notif.actionPayload,
        orElse: () => state.homeworkAssignments.first,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeworkDetailScreen(assignment: hw),
        ),
      );
    } else if (notif.type == NotificationType.exam) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizSolverScreen(subjectId: notif.actionPayload ?? 'science'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final allNotifs = state.notifications;
    final filtered = _getFilteredNotifications(allNotifs);
    final unreadCount = state.unreadNotificationCount;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            Text(
              unreadCount > 0 ? '$unreadCount unread updates' : 'All caught up',
              style: AppTypography.caption(
                color: unreadCount > 0 ? AppColors.accentCobalt : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: () => state.markAllNotificationsAsRead(),
              icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.accentCobalt),
              label: Text(
                'Mark read',
                style: AppTypography.caption(color: AppColors.accentCobalt)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Filter Bar
              _buildFilterChips(),

              // Notifications List
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final notif = filtered[index];
                          return Dismissible(
                            key: ValueKey(notif.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.accentRose,
                                borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
                              ),
                              child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              state.deleteNotification(notif.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed "${notif.title}"'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: _buildNotificationCard(context, notif, state),
                          );
                        },
                      ),
              ),
            ],
          ),
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _activeFilter == filter;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => setState(() => _activeFilter = filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.bgSurfaceOnyx : AppColors.bgSurfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.bgSurfaceOnyx : AppColors.borderLight,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    StudentNotification notif,
    StudentState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(
          color: notif.isRead ? AppColors.borderLight : AppColors.accentCobalt.withValues(alpha: 0.35),
          width: notif.isRead ? 1.0 : 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: () => _handleNotificationTap(context, notif, state),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notif.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif.icon, color: notif.color, size: 20),
                ),
                const SizedBox(width: 12),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: notif.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              notif.categoryLabel.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppTypography.primaryFont,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: notif.color,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            notif.timeAgoFormatted,
                            style: AppTypography.caption(color: AppColors.textMuted),
                          ),
                          if (!notif.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.accentCobalt,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif.title,
                        style: AppTypography.subheading(color: AppColors.textPrimary)
                            .copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        notif.message,
                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.bgSurfaceSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 32,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You're all caught up!",
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'No notifications in this category. All homework and school updates will appear here.',
              style: AppTypography.caption(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
