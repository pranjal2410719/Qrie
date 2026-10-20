import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
import 'package:qrie/screens/lesson_screen.dart';
import 'package:qrie/screens/quiz_solver_screen.dart';
import 'package:qrie/state/student_state.dart';

void main() {
  testWidgets('App loads directly into student home screen with school branding', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Verify school organization branding appears
    expect(find.textContaining('Delhi Public School'), findsOneWidget);

    // Verify student grade pill is visible
    expect(find.textContaining('CLASS 8'), findsWidgets);

    // Verify navigation tabs
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Ask Qrie'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify Hero card Resume Lesson CTA
    expect(find.text('RESUME LESSON'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between student views smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Practice tab
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('PRACTICE & MASTERY'), findsOneWidget);
    expect(find.text('START SPEED SPRINT'), findsOneWidget);

    // Tap Ask Qrie tab
    await tester.tap(find.text('Ask Qrie'));
    await tester.pumpAndSettle();
    expect(find.text('Qrie AI Academic Tutor'), findsOneWidget);
    expect(find.text('ASK'), findsOneWidget);

    // Tap Library tab
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('FORMULAS'), findsOneWidget);
    expect(find.text('FLASHCARDS'), findsOneWidget);
    expect(find.text('SAVED NOTES'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Weekly Study Activity'), findsOneWidget);
    expect(find.text('Academic Badges'), findsOneWidget);
    expect(find.text('SCHOOL ORGANIZATION CREDENTIALS'), findsOneWidget);

    // Return to Learn tab
    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    expect(find.text('DAILY LEARNING FOCUS'), findsOneWidget);
  });

  testWidgets('Resume Lesson opens LessonScreen with concept details', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Resume Lesson button
    await tester.tap(find.text('RESUME LESSON'));
    await tester.pumpAndSettle();

    // Verify LessonScreen opened
    expect(find.byType(LessonScreen), findsOneWidget);
    expect(find.text('CORE CONCEPT SUMMARY'), findsOneWidget);
    expect(find.text('PRACTICE THIS CONCEPT'), findsOneWidget);

    // Pop back to home via back button
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(LessonScreen), findsNothing);
  });

  testWidgets('Quiz solver loads questions and handles answer submission', (WidgetTester tester) async {
    final studentState = StudentState();
    await tester.pumpWidget(
      StudentStateScope(
        notifier: studentState,
        child: const MaterialApp(
          home: QuizSolverScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Quiz Question UI
    expect(find.textContaining('QUESTION 1 OF'), findsOneWidget);
    expect(find.text('CHECK ANSWER'), findsOneWidget);

    // Select first option 'A'
    final optionAFinder = find.text('A');
    expect(optionAFinder, findsOneWidget);
    await tester.tap(optionAFinder);
    await tester.pumpAndSettle();

    // Check answer
    await tester.tap(find.text('CHECK ANSWER'));
    await tester.pumpAndSettle();

    // Evaluation sheet displayed with CONTINUE button
    expect(find.text('CONTINUE'), findsOneWidget);
  });
}
