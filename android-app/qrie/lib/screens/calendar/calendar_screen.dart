import 'package:flutter/material.dart';
import '../../data/calendar_repository.dart';
import '../../data/mock_data.dart';
import '../../models/calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/bento_components.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import '../classroom/classroom_screen.dart';
import '../homework_detail_screen.dart';
import '../quiz_solver_screen.dart';
import '../../state/student_state.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? initialDate;

  const CalendarScreen({super.key, this.initialDate});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  List<AcademicCalendarEvent> _events = [];
  bool _isLoading = true;
  String? _error;
  String _activeFilter = 'All';

  final List<String> _filters = [
    'All',
    'Live Lessons',
    'Exams',
    'Study Sessions',
    'School Events',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _loadEventsForDate(_selectedDate);
  }

  Future<void> _loadEventsForDate(DateTime date) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await AcademicCalendarRepository.instance.getEventsForDate(date);
      if (mounted) {
        setState(() {
          _events = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load calendar events';
          _isLoading = false;
        });
      }
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadEventsForDate(date);
  }

  List<AcademicCalendarEvent> _getFilteredEvents() {
    if (_activeFilter == 'All') return _events;
    return _events.where((e) {
      switch (_activeFilter) {
        case 'Live Lessons':
          return e.type == CalendarEventType.liveClass;
        case 'Exams':
          return e.type == CalendarEventType.exam;
        case 'Study Sessions':
          return e.type == CalendarEventType.studySession;
        case 'School Events':
          return e.type == CalendarEventType.schoolEvent;
        default:
          return true;
      }
    }).toList();
  }

  void _handleEventAction(BuildContext context, AcademicCalendarEvent event) {
    final state = StudentStateScope.of(context);

    if (event.type == CalendarEventType.liveClass) {
      final subject = MockData.subjects.firstWhere(
        (s) => s.id == event.subjectId,
        orElse: () => MockData.subjects.first,
      );
      final chapter = MockData.chapters.firstWhere(
        (c) => c.subjectId == subject.id,
        orElse: () => MockData.chapters.first,
      );
      final lesson = chapter.lessons.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClassroomScreen(
            subject: subject,
            chapter: chapter,
            lesson: lesson,
          ),
        ),
      );
    } else if (event.type == CalendarEventType.assignmentDeadline) {
      final hw = state.homeworkAssignments.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeworkDetailScreen(assignment: hw),
        ),
      );
    } else if (event.type == CalendarEventType.exam) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizSolverScreen(subjectId: event.subjectId),
        ),
      );
    }
  }

  String _formatFullDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final weekday = weekdays[dt.weekday - 1];
    final month = months[dt.month - 1];
    return '$weekday, $month ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

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
              'Academic Calendar',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            Text(
              _formatFullDate(_selectedDate),
              style: AppTypography.caption(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _onDateSelected(DateTime.now()),
            child: Text(
              'Today',
              style: TextStyle(
                fontFamily: AppTypography.primaryFont,
                fontWeight: FontWeight.w700,
                color: AppColors.accentCobalt,
                fontSize: 13,
              ),
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Interactive Calendar Strip ─────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: BentoCalendarStrip(
                    initialDate: _selectedDate,
                    onDateSelected: _onDateSelected,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Category Filter Chips ──────────────────────────────────
                _buildFilterChips(),

                const SizedBox(height: 16),

                // ── Date Header & Count ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Scheduled Sessions',
                        style: AppTypography.sectionHeader(color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentCobalt.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${filteredEvents.length} ${filteredEvents.length == 1 ? "Item" : "Items"}',
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentCobalt,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Events Content ─────────────────────────────────────────
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCobalt),
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                else if (_error != null)
                  _buildErrorState()
                else if (filteredEvents.isEmpty)
                  _buildEmptyState()
                else
                  ...filteredEvents.map((ev) => _buildEventCard(context, ev)),
              ],
            ),
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
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _activeFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => _activeFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.bgSurfaceOnyx : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? AppColors.bgSurfaceOnyx : AppColors.borderLight,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, AcademicCalendarEvent event) {
    final startTimeFormatted =
        '${event.dateTime.hour % 12 == 0 ? 12 : event.dateTime.hour % 12}:${event.dateTime.minute.toString().padLeft(2, '0')} ${event.dateTime.hour >= 12 ? 'PM' : 'AM'}';
    final endTimeFormatted = event.endDateTime != null
        ? ' - ${event.endDateTime!.hour % 12 == 0 ? 12 : event.endDateTime!.hour % 12}:${event.endDateTime!.minute.toString().padLeft(2, '0')} ${event.endDateTime!.hour >= 12 ? 'PM' : 'AM'}'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(
          color: event.color.withValues(alpha: 0.25),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: () => _handleEventAction(context, event),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: event.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(event.icon, color: event.color, size: 22),
                    ),
                    const SizedBox(width: 14),
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
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                          const SizedBox(height: 6),
                          Text(
                            event.title,
                            style: AppTypography.subheading(color: AppColors.textPrimary)
                                .copyWith(fontSize: 14.5),
                          ),
                          const SizedBox(height: 3),
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
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.borderLight),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        event.type == CalendarEventType.liveClass
                            ? 'Interactive Live Class'
                            : (event.type == CalendarEventType.exam
                                ? 'Assessment Session'
                                : 'Academic Item'),
                        style: AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.type == CalendarEventType.liveClass
                              ? 'Join Lecture'
                              : (event.type == CalendarEventType.exam
                                  ? 'Start Test'
                                  : 'View Details'),
                          style: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: event.color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: event.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.bgSurfaceSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Nothing scheduled for this day',
              style: AppTypography.subheading(color: AppColors.textPrimary)
                  .copyWith(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Enjoy your free time, complete pending homework, or revise completed chapters.',
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          _error ?? 'Error loading events',
          style: AppTypography.caption(color: AppColors.accentRose),
        ),
      ),
    );
  }
}
