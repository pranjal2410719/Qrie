import 'package:flutter/material.dart';
import '../../models/study_material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/floating_ai_tutor_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  final TopicStudyMaterial material;
  final String topicTitle;

  const PdfViewerScreen({
    super.key,
    required this.material,
    required this.topicTitle,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _currentPage = 1;
  late int _totalPages;
  bool _isLoading = true;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _totalPages = widget.material.pageCount ?? 6;
    // Simulate initial document stream load
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate 100 reader canvas
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
              widget.material.title,
              style: AppTypography.subheading(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.topicTitle} • ${widget.material.fileSize}',
              style: AppTypography.caption(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? 'Bookmarked' : 'Bookmark Page',
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _isBookmarked ? AppColors.accentCobalt : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked ? 'Bookmarked Page $_currentPage' : 'Bookmark removed',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Download',
            icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document cached for offline revision.'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCobalt),
                      ),
                      SizedBox(height: 14),
                      Text('Rendering document pages...'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Top page status pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.bgSurfaceSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PAGE $_currentPage OF $_totalPages',
                              style: AppTypography.caption(color: AppColors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left_rounded),
                                onPressed: _currentPage > 1
                                    ? () => setState(() => _currentPage--)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: _currentPage < _totalPages
                                    ? () => setState(() => _currentPage++)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),

                    // Rendered Document Page Simulated Sheet
                    Expanded(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 3.0,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              padding: const EdgeInsets.all(28.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    blurRadius: 18,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'NCERT SYLLABUS NOTES',
                                        style: AppTypography.caption(
                                            color: AppColors.accentCobalt)
                                            .copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        'Page $_currentPage',
                                        style: AppTypography.caption(
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.material.title,
                                    style: AppTypography.headingSmall(),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    height: 2,
                                    width: 60,
                                    color: AppColors.accentCobalt,
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    '1. Core Theoretical Foundations & Principles',
                                    style: AppTypography.subheading(
                                        color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.material.description,
                                    style: AppTypography.bodyMedium(),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgSurfaceSoft,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppColors.borderLight),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.lightbulb_outline_rounded,
                                          color: AppColors.accentAmber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Crucial Exam Concept: Always verify unit conventions and state governing equations before substituting numerical values.',
                                            style: AppTypography.bodySmall(
                                                color: AppColors.textPrimary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '2. Illustrated Summary & Key Equations',
                                    style: AppTypography.subheading(
                                        color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Refer to classroom lesson recordings for step-by-step whiteboard derivations. Review all textbook end-of-chapter exercises and check answers using the AI Tutor.',
                                    style: AppTypography.bodyMedium(),
                                  ),
                                  const SizedBox(height: 40),
                                  Center(
                                    child: Text(
                                      '— End of Page $_currentPage of $_totalPages —',
                                      style: AppTypography.caption(
                                          color: AppColors.textMuted),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          // Floating Qrie AI Assistant
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }
}
