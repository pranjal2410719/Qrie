import 'package:flutter/material.dart';
import '../../models/study_material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/floating_ai_tutor_widget.dart';

class ImageViewerScreen extends StatefulWidget {
  final TopicStudyMaterial material;
  final String topicTitle;

  const ImageViewerScreen({
    super.key,
    required this.material,
    required this.topicTitle,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final TransformationController _transformController = TransformationController();
  bool _hasError = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate canvas for diagrams
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.material.title,
              style: AppTypography.subheading(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.topicTitle,
              style: AppTypography.caption(color: AppColors.accentPeriwinkle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reset Zoom',
            icon: const Icon(Icons.center_focus_strong_rounded, color: Colors.white),
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 4.0,
              child: _hasError
                  ? _buildErrorView()
                  : Image.network(
                      widget.material.fileUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.accentMint),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading high-resolution diagram...',
                                style: AppTypography.bodySmall(
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorView();
                      },
                    ),
            ),
          ),

          // Caption bar at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xCC1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pinch_rounded, color: AppColors.schoolGold, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.material.description,
                      style: AppTypography.caption(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Qrie AI Assistant
          const FloatingAITutorWidget(
            bottomOffset: 90,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.broken_image_rounded,
              color: AppColors.accentRose,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load diagram',
              style: AppTypography.subheading(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Please verify network connectivity or try again.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(color: Colors.white70),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bgSurfaceOnyx,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white24),
                ),
              ),
              onPressed: () {
                setState(() {
                  _hasError = false;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
