import 'package:flutter/material.dart';

/// School Organization Branding Configuration
class SchoolBrandingConfig {
  final String schoolId;
  final String schoolName;
  final String schoolCode;
  final String motto;
  final String logoUrl;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String welcomeMessage;
  final String heroImageUrl;

  const SchoolBrandingConfig({
    required this.schoolId,
    required this.schoolName,
    required this.schoolCode,
    required this.motto,
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.welcomeMessage,
    required this.heroImageUrl,
  });

  /// Real verified Delhi Public School branding from internet
  factory SchoolBrandingConfig.dpsDefault() {
    return const SchoolBrandingConfig(
      schoolId: 'sch_dps_rkp',
      schoolName: 'Delhi Public School, R.K. Puram',
      schoolCode: 'DPS-RKP-042',
      motto: 'Service Before Self',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/DPSGF.png',
      primaryColor: Color(0xFF0F5132), // DPS Forest Green
      secondaryColor: Color(0xFFE8F5EE), // Soft Mint
      accentColor: Color(0xFFD4AF37), // Gold
      welcomeMessage: 'Welcome back to your school learning portal!',
      heroImageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80',
    );
  }

  /// Neutral Qrie branding fallback
  factory SchoolBrandingConfig.neutralQrie() {
    return const SchoolBrandingConfig(
      schoolId: 'sch_qrie_default',
      schoolName: 'Qrie Learning Academy',
      schoolCode: 'QRIE-001',
      motto: 'Curiosity Driven Mastery',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/DPSGF.png',
      primaryColor: Color(0xFF58CC02), // Eager Green
      secondaryColor: Color(0xFFD7FFB8), // Storybook Green
      accentColor: Color(0xFF1CB0F6), // Spark Blue
      welcomeMessage: 'Ready to discover something new today?',
      heroImageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=600&q=80',
    );
  }

  factory SchoolBrandingConfig.fromJson(Map<String, dynamic> json) {
    final branding = (json['branding'] as Map<String, dynamic>?) ?? {};

    return SchoolBrandingConfig(
      schoolId: json['school_id'] as String? ?? 'sch_default',
      schoolName: json['school_name'] as String? ?? 'School Learning Portal',
      schoolCode: json['school_code'] as String? ?? 'SCHOOL-001',
      motto: json['motto'] as String? ?? 'Excellence in Education',
      logoUrl: branding['logo_url'] as String? ??
          'https://upload.wikimedia.org/wikipedia/commons/0/0f/DPSGF.png',
      primaryColor: _parseHexColor(branding['primary_color'] as String?, const Color(0xFF0F5132)),
      secondaryColor: _parseHexColor(branding['secondary_color'] as String?, const Color(0xFFE8F5EE)),
      accentColor: _parseHexColor(branding['accent_color'] as String?, const Color(0xFFD4AF37)),
      welcomeMessage: branding['welcome_message'] as String? ?? 'Welcome back to your studies!',
      heroImageUrl: branding['hero_image_url'] as String? ??
          'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_id': schoolId,
      'school_name': schoolName,
      'school_code': schoolCode,
      'motto': motto,
      'branding': {
        'logo_url': logoUrl,
        'primary_color': '#${primaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        'secondary_color': '#${secondaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        'accent_color': '#${accentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        'welcome_message': welcomeMessage,
        'hero_image_url': heroImageUrl,
      },
    };
  }

  static Color _parseHexColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
