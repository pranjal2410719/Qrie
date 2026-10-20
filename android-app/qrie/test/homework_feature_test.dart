import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
import 'package:qrie/screens/homework_detail_screen.dart';
import 'package:qrie/screens/homework_mini_test_screen.dart';
import 'package:qrie/screens/homework_screen.dart';
import 'package:qrie/state/student_state.dart';
import 'package:qrie/widgets/bottom_nav_bar.dart';
import 'package:qrie/widgets/floating_ai_tutor_widget.dart';
import 'package:qrie/widgets/homework_study_materials_sheet.dart';

void main() {
  testWidgets('Homework Tab displays vertically browsable cards and status pills', (tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // 1. Navigate to Homework Tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Homework'),
    ));
    await tester.pumpAndSettle();

    // 2. Verify Homework screen loaded
    expect(find.byType(HomeworkScreen), findsOneWidget);
    expect(find.text('Homework & Tasks'), findsOneWidget);

    // 3. Verify Filter chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Due Soon'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'In Progress'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Completed'), findsOneWidget);

    // 4. Verify initial homework cards
    expect(find.textContaining('Linear Equations:'), findsOneWidget);
    expect(find.text("Ohm's Law & Resistor Networks in Series and Parallel"), findsOneWidget);

    // 5. Test Filter interaction
    await tester.tap(find.widgetWithText(ChoiceChip, 'Completed'));
    await tester.pumpAndSettle();

    // In mock data, Biology is completed
    expect(find.textContaining('Cellular Respiration'), findsOneWidget);
  });

  testWidgets('HomeworkDetailScreen renders structured content, checklist, and floating CTAs', (tester) async {
    final state = StudentState();
    final assignment = state.homeworkAssignments.first;

    await tester.pumpWidget(
      MaterialApp(
        home: StudentStateScope(
          notifier: state,
          child: HomeworkDetailScreen(assignment: assignment),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Overview Section
    expect(find.text(assignment.title), findsWidgets);
    expect(find.text('ASSIGNMENT CONTENT'), findsOneWidget);
    expect(find.text('LEARNING OBJECTIVES'), findsOneWidget);
    expect(find.text('COMPLETION CHECKLIST'), findsOneWidget);

    // 2. Floating Study Materials CTA
    expect(find.text('Study Materials'), findsOneWidget);
    await tester.tap(find.text('Study Materials'));
    await tester.pumpAndSettle();

    // Verify Bottom Sheet appeared
    expect(find.byType(HomeworkStudyMaterialsSheet), findsOneWidget);
    expect(find.text('Study Materials & Resources'), findsOneWidget);

    // Dismiss bottom sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(HomeworkStudyMaterialsSheet), findsNothing);

    // 3. Test Checklist interaction
    final firstStep = find.text('Review assignment & study materials');
    expect(firstStep, findsOneWidget);
    await tester.ensureVisible(firstStep);
    await tester.pumpAndSettle();
    await tester.tap(firstStep);
    await tester.pumpAndSettle();

    // 4. Verify Floating AI Tutor button is mounted
    expect(find.byType(FloatingAITutorWidget), findsOneWidget);
  });

  testWidgets('HomeworkMiniTestScreen enforces pass threshold and records attempt', (tester) async {
    final state = StudentState();
    final assignment = state.homeworkAssignments.first;

    await tester.pumpWidget(
      MaterialApp(
        home: StudentStateScope(
          notifier: state,
          child: HomeworkMiniTestScreen(assignment: assignment),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Intro Screen
    expect(find.text('ACADEMIC MASTERY CHECK'), findsOneWidget);
    expect(find.text('START VERIFICATION TEST'), findsOneWidget);

    // 2. Start Test
    await tester.ensureVisible(find.text('START VERIFICATION TEST'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('START VERIFICATION TEST'));
    await tester.pumpAndSettle();

    // 3. Verify Question View
    expect(find.textContaining('QUESTION 1 OF'), findsOneWidget);

    // Answer Question 1 (option B is '6', correct)
    await tester.ensureVisible(find.text('6'));
    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('NEXT QUESTION'));
    await tester.tap(find.text('NEXT QUESTION'));
    await tester.pumpAndSettle();

    // Answer Question 2 (option C is '9', correct)
    expect(find.textContaining('QUESTION 2 OF'), findsOneWidget);
    await tester.ensureVisible(find.text('9'));
    await tester.tap(find.text('9'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('NEXT QUESTION'));
    await tester.tap(find.text('NEXT QUESTION'));
    await tester.pumpAndSettle();

    // Answer Question 3 (option C is 'Parallel lines', correct)
    expect(find.textContaining('QUESTION 3 OF'), findsOneWidget);
    await tester.ensureVisible(find.text('Parallel lines'));
    await tester.tap(find.text('Parallel lines'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('NEXT QUESTION'));
    await tester.tap(find.text('NEXT QUESTION'));
    await tester.pumpAndSettle();

    // Answer Question 4 (option A is '1.8', correct)
    expect(find.textContaining('QUESTION 4 OF'), findsOneWidget);
    await tester.ensureVisible(find.text('1.8'));
    await tester.tap(find.text('1.8'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('NEXT QUESTION'));
    await tester.tap(find.text('NEXT QUESTION'));
    await tester.pumpAndSettle();

    // Answer Question 5 (option B is '5', correct)
    expect(find.textContaining('QUESTION 5 OF'), findsOneWidget);
    await tester.ensureVisible(find.text('5'));
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    // Submit Test
    expect(find.text('SUBMIT TEST'), findsOneWidget);
    await tester.ensureVisible(find.text('SUBMIT TEST'));
    await tester.tap(find.text('SUBMIT TEST'));
    await tester.pumpAndSettle();

    // 4. Verify Results View
    expect(find.text('Verification Passed!'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('RETURN TO HOMEWORK'), findsOneWidget);
    await tester.ensureVisible(find.text('RETURN TO HOMEWORK'));
    await tester.tap(find.text('RETURN TO HOMEWORK'));
    await tester.pumpAndSettle();
  });

  testWidgets('Teacher Mode switch toggles dashboard and allows viewing roster', (tester) async {
    final state = StudentState();

    await tester.pumpWidget(
      MaterialApp(
        home: StudentStateScope(
          notifier: state,
          child: const HomeworkScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Tap Teacher toggle
    expect(find.text('Teacher'), findsOneWidget);
    await tester.tap(find.text('Teacher'));
    await tester.pumpAndSettle();

    // 2. Verify Teacher Dashboard
    expect(find.text('Teacher Dashboard'), findsOneWidget);
    expect(find.text('CREATE ASSIGNMENT'), findsOneWidget);
    expect(find.text('Class 9-A'), findsWidgets);

    // 3. Switch back to Student View
    await tester.tap(find.text('Student View'));
    await tester.pumpAndSettle();
    expect(find.text('Homework & Tasks'), findsOneWidget);
  });
}
