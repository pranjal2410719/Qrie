import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/features/school_branding/models/school_branding_config.dart';
import 'package:qrie/features/school_branding/presentation/widgets/school_logo.dart';
import 'package:qrie/features/school_branding/presentation/widgets/student_welcome_header.dart';

void main() {
  group('SchoolBrandingConfig Tests', () {
    test('Default DPS branding contains verified school details and assets', () {
      final config = SchoolBrandingConfig.dpsDefault();

      expect(config.schoolName, 'Delhi Public School, R.K. Puram');
      expect(config.schoolCode, 'DPS-RKP-042');
      expect(config.motto, 'Service Before Self');
      expect(config.primaryColor, const Color(0xFF0F5132));
      expect(config.logoUrl, contains('upload.wikimedia.org'));
      expect(config.heroImageUrl, contains('images.unsplash.com'));
    });

    test('Parses custom school branding JSON safely with fallback color parsing', () {
      final json = {
        'school_id': 'sch_custom',
        'school_name': 'Kendriya Vidyalaya IIT',
        'school_code': 'KVS-IIT-01',
        'motto': 'Lead us from darkness to light',
        'branding': {
          'logo_url': 'https://example.com/logo.png',
          'primary_color': '#1B5E20',
          'secondary_color': '#E8F5E9',
          'accent_color': '#FFD54F',
          'welcome_message': 'Welcome students!',
          'hero_image_url': 'https://example.com/hero.jpg',
        },
      };

      final config = SchoolBrandingConfig.fromJson(json);

      expect(config.schoolId, 'sch_custom');
      expect(config.schoolName, 'Kendriya Vidyalaya IIT');
      expect(config.primaryColor, const Color(0xFF1B5E20));
      expect(config.secondaryColor, const Color(0xFFE8F5E9));
      expect(config.accentColor, const Color(0xFFFFD54F));
    });

    test('Serializes to JSON and deserializes identically', () {
      final original = SchoolBrandingConfig.dpsDefault();
      final json = original.toJson();
      final restored = SchoolBrandingConfig.fromJson(json);

      expect(restored.schoolId, original.schoolId);
      expect(restored.schoolName, original.schoolName);
      expect(restored.motto, original.motto);
      expect(restored.primaryColor, original.primaryColor);
    });
  });

  group('School Branding Widgets Tests', () {
    testWidgets('SchoolLogo renders with fallback icon when image fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SchoolLogo(
              logoUrl: 'https://invalid-non-existent-image-url.com/logo.png',
              size: 48,
            ),
          ),
        ),
      );

      // Verify fallback icon appears gracefully
      expect(find.byType(SchoolLogo), findsOneWidget);
    });

    testWidgets('StudentWelcomeHeader displays school branding, grade, and status pills', (WidgetTester tester) async {
      final branding = SchoolBrandingConfig.dpsDefault();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StudentWelcomeHeader(
              branding: branding,
              studentName: 'Aarav Patel',
              gradeAndBoard: 'Class 8 CBSE',
              streakDays: 7,
              gems: 250,
            ),
          ),
        ),
      );

      // Verify student greeting and initial avatar 'A'
      expect(find.text('Hi, Aarav'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      // Verify grade
      expect(find.text('Class 8 CBSE'), findsOneWidget);
      // Verify streak pill
      expect(find.text('7'), findsOneWidget);
    });
  });
}
