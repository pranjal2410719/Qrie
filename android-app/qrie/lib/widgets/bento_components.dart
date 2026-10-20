import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 5.2 Horizontal Calendar Strip
// ─────────────────────────────────────────────────────────────────────────────
class BentoCalendarStrip extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const BentoCalendarStrip({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<BentoCalendarStrip> createState() => _BentoCalendarStripState();
}

class _BentoCalendarStripState extends State<BentoCalendarStrip> {
  late DateTime _selectedDate;
  late DateTime _referenceDate;

  final List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _referenceDate = _selectedDate;
  }

  void _shiftWeek(int days) {
    setState(() {
      _referenceDate = _referenceDate.add(Duration(days: days));
    });
  }

  List<DateTime> _getWeekDays() {
    // Return 7 days centered on referenceDate
    final currentWeekday = _referenceDate.weekday % 7; // 0 for Sunday
    final sunday = _referenceDate.subtract(Duration(days: currentWeekday));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final days = _getWeekDays();
    final monthYear = '${_months[_referenceDate.month - 1]} ${_referenceDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Month & Year on left, < > buttons on right
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                monthYear,
                style: AppTypography.sectionHeader(color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                _CalendarNavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _shiftWeek(-7),
                ),
                const SizedBox(width: 8),
                _CalendarNavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _shiftWeek(7),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Day columns
        Row(
          children: days.map((date) {
            final isSelected = date.year == _selectedDate.year &&
                date.month == _selectedDate.month &&
                date.day == _selectedDate.day;
            final dayLabel = _weekDays[date.weekday % 7];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.bgSurfaceOnyx
                            : AppColors.bgSurfaceSoft,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.bgSurfaceOnyx.withValues(alpha: 0.24),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.textOnOnyx
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CalendarNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceSoft,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgSurfaceMuted, width: 1.0),
        ),
        child: Center(
          child: Icon(icon, size: 16, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5.3 Featured Lesson Card ("Map the Path")
// ─────────────────────────────────────────────────────────────────────────────
class FeaturedLessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final String timeLabel;
  final double rating;
  final VoidCallback? onResume;
  final VoidCallback? onCopyLink;

  const FeaturedLessonCard({
    super.key,
    this.title = 'Map the Path',
    this.subtitle = 'Brief 001',
    this.progress = 0.28,
    this.timeLabel = '15:32/56:25',
    this.rating = 5.0,
    this.onResume,
    this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
        border: Border.all(color: AppColors.bgSurfaceMuted, width: 1.0),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: 110x125 3D Character Illustration Card ─────────────────
          Container(
            width: 104,
            height: 125,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9333EA), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
            ),
            child: Stack(
              children: [
                // Floating top-left icon badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                // Character 3D avatar icon / illustration
                const Center(
                  child: Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 46,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // ── Right: Stacked Course Metadata ───────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Title + Subtitle + 32px periwinkle circular button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.cardTitle(
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: AppTypography.caption(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    // 32px periwinkle external link button
                    GestureDetector(
                      onTap: onResume,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.accentPeriwinkle,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.north_east_rounded,
                            size: 15,
                            color: AppColors.bgSurfaceOnyx,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 2: Timeline Row (progress bar + timestamp)
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accentCobalt),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
                      style: AppTypography.caption(color: AppColors.textMuted)
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Row 3: Rating Row (5 solid amber stars + bold score)
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.accentAmber,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTypography.caption(color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 4: Avatar stack + Copy link pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Overlapping avatar stack
                    Flexible(
                      child: SizedBox(
                        height: 24,
                        width: 66,
                        child: Stack(
                          children: [
                            _buildAvatarCircle(0, const Color(0xFF38BDF8), 'A'),
                            _buildAvatarCircle(14, const Color(0xFFE298F8), 'M'),
                            _buildAvatarCircle(28, const Color(0xFFF3C750), 'K'),
                            Positioned(
                              left: 42,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: AppColors.bgSurfaceOnyx,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '+13',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // #F4F5F7 pill button
                    GestureDetector(
                      onTap: onCopyLink,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.bgSurfaceSoft,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'Resume',
                          style: AppTypography.caption(
                                  color: AppColors.textPrimary)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(double left, Color bg, String initial) {
    return Positioned(
      left: left,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5.4 "My Activity" Donut Chart Card
// ─────────────────────────────────────────────────────────────────────────────
class MyActivityDonutCard extends StatelessWidget {
  final String totalTime;
  final String completionPercent;
  final VoidCallback? onMenuTap;

  const MyActivityDonutCard({
    super.key,
    this.totalTime = '40h 32m',
    this.completionPercent = '84%',
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSoft,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
      ),
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Small label + bold metric + white pill badge + ⋮ menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Activity',
                      style: AppTypography.caption(color: AppColors.textSecondary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          totalTime,
                          style: AppTypography.metricHero(
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            completionPercent,
                            style: AppTypography.caption(
                                    color: AppColors.textPrimary)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMenuTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.more_vert_rounded,
                        size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chart & Legend Split
          Row(
            children: [
              // Left: Multi-segment ring chart (110x110)
              SizedBox(
                width: 104,
                height: 104,
                child: CustomPaint(
                  painter: _DonutChartPainter(
                    segments: const [
                      _DonutSegment(percent: 0.40, color: AppColors.bgSurfaceOnyx),
                      _DonutSegment(percent: 0.25, color: Color(0xFF9CA3AF)),
                      _DonutSegment(percent: 0.20, color: AppColors.accentAmber),
                      _DonutSegment(percent: 0.15, color: AppColors.accentPeriwinkle),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.insights_rounded,
                      size: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Right: Vertical stack of 4 legend rows
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _LegendRow(
                      percent: '40%',
                      label: 'Completed',
                      pillColor: AppColors.bgSurfaceOnyx,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 8),
                    _LegendRow(
                      percent: '25%',
                      label: 'In Progress',
                      pillColor: Color(0xFF9CA3AF),
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 8),
                    _LegendRow(
                      percent: '20%',
                      label: 'Tests Passed',
                      pillColor: AppColors.accentAmber,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 8),
                    _LegendRow(
                      percent: '15%',
                      label: 'Practice',
                      pillColor: AppColors.accentPeriwinkle,
                      textColor: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String percent;
  final String label;
  final Color pillColor;
  final Color textColor;

  const _LegendRow({
    required this.percent,
    required this.label,
    required this.pillColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: textColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                percent,
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.caption(color: AppColors.textPrimary)
                .copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DonutSegment {
  final double percent;
  final Color color;
  const _DonutSegment({required this.percent, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSegment> segments;

  const _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    double startAngle = -math.pi / 2;
    const gapAngle = 0.08; // ~4.5 degrees gap between segments

    for (final seg in segments) {
      final sweepAngle = (seg.percent * 2 * math.pi) - gapAngle;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      if (sweepAngle > 0) {
        canvas.drawArc(rect, startAngle + (gapAngle / 2), sweepAngle, false, paint);
      }
      startAngle += seg.percent * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 5.5 3-Column Gamified Offer Tiles ("Hot Offers")
// ─────────────────────────────────────────────────────────────────────────────
class BentoHotOffersGrid extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTileTap;

  const BentoHotOffersGrid({
    super.key,
    this.activeIndex = 1,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    final offers = [
      {'title': 'Launch Boost', 'icon': Icons.rocket_launch_rounded},
      {'title': 'Creative Flow', 'icon': Icons.palette_rounded, 'badge': '20%'},
      {'title': 'Freedom Plan', 'icon': Icons.wb_sunny_rounded},
    ];

    return Row(
      children: List.generate(3, (index) {
        final offer = offers[index];
        final isActive = (index == activeIndex);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 6,
              right: index == 2 ? 0 : 6,
            ),
            child: GestureDetector(
              onTap: () => onTileTap?.call(index),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 108),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.bgSurfaceOnyx
                          : AppColors.bgSurfaceSoft,
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusCardMd),
                      boxShadow: isActive ? DesignTokens.shadowSoft : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          offer['icon'] as IconData,
                          size: 26,
                          color: isActive
                              ? AppColors.accentMustard
                              : AppColors.accentCobalt,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.textOnOnyx
                                : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Floating scalloped pink badge anchored to top-right of active tile
                  if (isActive && offer['badge'] != null)
                    Positioned(
                      top: -6,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accentRose,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          offer['badge'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5.6 2x2 To-Do Bento Grid
// ─────────────────────────────────────────────────────────────────────────────
class BentoTodoGrid extends StatelessWidget {
  final int allCount;
  final int scheduledCount;
  final int activeCount;
  final int overdueCount;
  final ValueChanged<String>? onTileTap;

  const BentoTodoGrid({
    super.key,
    this.allCount = 29,
    this.scheduledCount = 13,
    this.activeCount = 9,
    this.overdueCount = 4,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _BentoTile(
                icon: Icons.dashboard_outlined,
                label: 'All',
                count: allCount,
                bgColor: AppColors.bgSurfaceMuted,
                onTap: () => onTileTap?.call('All'),
              ),
            ),
            const SizedBox(width: DesignTokens.bentoGridGap),
            Expanded(
              child: _BentoTile(
                icon: Icons.calendar_today_outlined,
                label: 'Scheduled',
                count: scheduledCount,
                bgColor: AppColors.accentMustard.withValues(alpha: 0.35),
                onTap: () => onTileTap?.call('Scheduled'),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.bentoGridGap),
        Row(
          children: [
            Expanded(
              child: _BentoTile(
                icon: Icons.access_time_rounded,
                label: 'Active',
                count: activeCount,
                bgColor: AppColors.accentPeriwinkle.withValues(alpha: 0.55),
                onTap: () => onTileTap?.call('Active'),
              ),
            ),
            const SizedBox(width: DesignTokens.bentoGridGap),
            Expanded(
              child: _BentoTile(
                icon: Icons.warning_amber_rounded,
                label: 'Overdue',
                count: overdueCount,
                bgColor: AppColors.accentOrchid.withValues(alpha: 0.40),
                onTap: () => onTileTap?.call('Overdue'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color bgColor;
  final VoidCallback onTap;

  const _BentoTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top-Left: 30x30 dark circle containing 16px icon
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, size: 16, color: AppColors.textPrimary),
              ),
            ),
            // Bottom row: Category label on left, bold count on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppTypography.primaryFont,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5.7 Onyx Milestone Tracker Card ("Next Milestones")
// ─────────────────────────────────────────────────────────────────────────────
class BentoMilestoneTrackerCard extends StatelessWidget {
  final String title;
  final String durationTag;
  final String priority;
  final int attachmentsCount;
  final String assigneeName;
  final VoidCallback? onTap;

  const BentoMilestoneTrackerCard({
    super.key,
    this.title = 'Next Milestones',
    this.durationTag = '⏳ 8h',
    this.priority = 'High',
    this.attachmentsCount = 4,
    this.assigneeName = 'John Doe',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceOnyx,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
          boxShadow: DesignTokens.shadowSoft,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Mint checkmark badge + white title + duration tag + priority pill
            Row(
              children: [
                // Mint checkmark badge
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accentMint.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 15,
                    color: AppColors.accentMint,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.cardTitle(color: AppColors.textOnOnyx),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                // White pill duration tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    durationTag,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bgSurfaceOnyx,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Coral-red priority pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentCoral,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    priority,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Divider: Subtle horizontal hairline (rgba(255,255,255,0.08))
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.08),
            ),

            const SizedBox(height: 12),

            // Bottom Row: Paperclip + Attachments on left; Assignee on right
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        size: 14,
                        color: AppColors.textOnOnyxMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$attachmentsCount files',
                          style: AppTypography.caption(
                              color: AppColors.textOnOnyxMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      assigneeName,
                      style: AppTypography.caption(color: AppColors.textOnOnyx)
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF38BDF8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          assigneeName.isNotEmpty
                              ? assigneeName[0].toUpperCase()
                              : 'J',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
