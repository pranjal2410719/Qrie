import 'package:flutter/material.dart';

class SchoolLogo extends StatelessWidget {
  final String logoUrl;
  final double size;
  final Color? borderColor;
  final String? fallbackInitials;

  const SchoolLogo({
    super.key,
    required this.logoUrl,
    this.size = 40,
    this.borderColor,
    this.fallbackInitials = 'DPS',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? const Color(0xFFE5E5E5),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallback();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: const Color(0xFFE8F5EE),
      child: Center(
        child: Icon(
          Icons.school_rounded,
          size: size * 0.55,
          color: const Color(0xFF0F5132),
        ),
      ),
    );
  }
}
