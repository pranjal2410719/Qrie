import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/screens/profile_screen.dart';
import 'package:qrie/state/student_state.dart';

void main() {
  Widget buildTestableProfileScreen({StudentState? state, VoidCallback? onBack}) {
    final studentState = state ?? StudentState();
    return MaterialApp(
      home: StudentStateScope(
        notifier: studentState,
        child: ProfileScreen(onBack: onBack),
      ),
    );
  }

  group('ProfileScreen Redesign Layout Tests', () {
    testWidgets('Renders top header with back and settings buttons', (tester) async {
      bool backTriggered = false;
      await tester.pumpWidget(
        buildTestableProfileScreen(onBack: () => backTriggered = true),
      );
      await tester.pumpAndSettle();

      // Top header label
      expect(find.text('Student Profile'), findsOneWidget);

      // Back and settings icons in header
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pump();
      expect(backTriggered, isTrue);
    });

    testWidgets('Renders overlapping circular profile avatar and student identity', (tester) async {
      final state = StudentState();
      await tester.pumpWidget(buildTestableProfileScreen(state: state));
      await tester.pumpAndSettle();

      // Student name from state
      expect(find.text(state.profile.name), findsOneWidget);

      // Verification checkmark
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);

      // Grade & Curriculum badge
      expect(
        find.text('${state.profile.grade} • ${state.profile.board} Curriculum'),
        findsOneWidget,
      );

      // School info & learning profile
      expect(find.textContaining('Delhi Public School, R.K. Puram'), findsWidgets);
      expect(find.text('Curious Explorer • Scholar Level 4'), findsOneWidget);

      // Camera edit badge on avatar
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });

    testWidgets('Renders quick action row with Edit, Syllabus, Doubts, Settings', (tester) async {
      await tester.pumpWidget(buildTestableProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Syllabus'), findsOneWidget);
      expect(find.text('Doubts'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(find.byIcon(Icons.psychology_outlined), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    });

    testWidgets('Renders three-item statistics row with real profile metrics', (tester) async {
      final state = StudentState();
      await tester.pumpWidget(buildTestableProfileScreen(state: state));
      await tester.pumpAndSettle();

      // Labels
      expect(find.text('DAY STREAK'), findsOneWidget);
      expect(find.text('LESSONS'), findsOneWidget);
      expect(find.text('TOTAL XP'), findsOneWidget);

      // Values from profile state
      expect(find.text('${state.profile.streakDays}'), findsWidgets);
      expect(find.text('${state.profile.completedLessonIds.length}'), findsWidgets);
      expect(find.text('${state.profile.totalXp}'), findsOneWidget);
    });

    testWidgets('Renders secondary section with Badges, Weekly Activity, and Credentials', (tester) async {
      await tester.pumpWidget(buildTestableProfileScreen());
      await tester.pumpAndSettle();

      // Card 1: Badges
      expect(find.text('Badges'), findsOneWidget);
      expect(find.textContaining('Unlocked'), findsWidgets);

      // Card 2: Study Activity
      expect(find.text('Study Activity'), findsOneWidget);
      expect(find.textContaining('14.6h'), findsOneWidget);

      // Card 3: School Credentials
      expect(find.text('SCHOOL CREDENTIALS & ENROLMENT'), findsOneWidget);
      expect(find.text('CBSE Board Affiliation #2730017'), findsOneWidget);
    });

    testWidgets('Tapping Edit opens sheet and updates student name', (tester) async {
      final state = StudentState();
      await tester.pumpWidget(buildTestableProfileScreen(state: state));
      await tester.pumpAndSettle();

      // Tap Edit quick action
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify sheet is open
      expect(find.text('Edit Student Profile'), findsOneWidget);
      expect(find.text('SAVE CHANGES'), findsOneWidget);

      // Enter new name
      await tester.enterText(find.byType(TextField), 'Ananya Verma');
      await tester.pump();

      // Tap Save
      await tester.tap(find.text('SAVE CHANGES'));
      await tester.pumpAndSettle();

      // Verify state was updated
      expect(state.profile.name, 'Ananya Verma');
      expect(find.text('Ananya Verma'), findsOneWidget);
    });

    testWidgets('Layout does not overflow on narrow screen (320px width)', (tester) async {
      tester.view.physicalSize = const Size(320 * 2.0, 640 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableProfileScreen());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
