import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../data/calendar_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';

class CalendarEventsPanel extends StatefulWidget {
  final DateTime selectedDate;

  const CalendarEventsPanel({
    super.key,
    required this.selectedDate,
  });

  @override
  State<CalendarEventsPanel> createState() => _CalendarEventsPanelState();
}

class _CalendarEventsPanelState extends State<CalendarEventsPanel> {
  List<AcademicCalendarEvent> _events = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void didUpdateWidget(covariant CalendarEventsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate.year != widget.selectedDate.year ||
        oldWidget.selectedDate.month != widget.selectedDate.month ||
        oldWidget.selectedDate.day != widget.selectedDate.day) {
      _fetchEvents();
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await AcademicCalendarRepository.instance
          .getEventsForDate(widget.selectedDate);
      if (mounted) {
        setState(() {
          _events = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Unable to load scheduled events.';
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateHeader(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      return 'Today, ${months[date.month - 1]} ${date.day}';
    }
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: selected date + events count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.event_note_rounded,
                        size: 18, color: AppColors.accentCobalt),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDateHeader(widget.selectedDate),
                        style: AppTypography.subheading(color: AppColors.textPrimary)
                            .copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!_isLoading && _events.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentCobalt.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_events.length} ${_events.length == 1 ? "Event" : "Events"}',
                    style: TextStyle(
                      fontFamily: AppTypography.primaryFont,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCobalt,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Content body
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                ),
              ),
            )
          else if (_error != null)
            _buildErrorState()
          else if (_events.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: _events.map((ev) => _buildEventItem(ev)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEventItem(AcademicCalendarEvent event) {
    final startTimeFormatted =
        '${event.dateTime.hour % 12 == 0 ? 12 : event.dateTime.hour % 12}:${event.dateTime.minute.toString().padLeft(2, '0')} ${event.dateTime.hour >= 12 ? 'PM' : 'AM'}';
    final endTimeFormatted = event.endDateTime != null
        ? ' - ${event.endDateTime!.hour % 12 == 0 ? 12 : event.endDateTime!.hour % 12}:${event.endDateTime!.minute.toString().padLeft(2, '0')} ${event.endDateTime!.hour >= 12 ? 'PM' : 'AM'}'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(event.icon, color: event.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.typeLabel.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: event.color,
                        ),
                      ),
                    ),
                    Text(
                      event.subjectName,
                      style: AppTypography.caption(color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: (event.status == 'completed'
                                ? AppColors.accentMint
                                : AppColors.textMuted)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.status.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: event.status == 'completed'
                              ? AppColors.accentMint
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  event.title,
                  style: AppTypography.subheading(color: AppColors.textPrimary)
                      .copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  '$startTimeFormatted$endTimeFormatted${event.roomOrLink != null ? " • ${event.roomOrLink}" : ""}',
                  style: AppTypography.caption(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 28,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              'Nothing scheduled for this day',
              style: AppTypography.subheading(color: AppColors.textPrimary)
                  .copyWith(fontSize: 13.5),
            ),
            const SizedBox(height: 3),
            Text(
              'Enjoy your free time or revise completed topics.',
              style: AppTypography.caption(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          _error ?? 'Error loading events',
          style: AppTypography.caption(color: AppColors.accentRose),
        ),
      ),
    );
  }
}
