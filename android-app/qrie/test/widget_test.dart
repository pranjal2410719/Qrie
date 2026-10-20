import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
import 'package:qrie/screens/lesson_screen.dart';
import 'package:qrie/screens/quiz_solver_screen.dart';
import 'package:qrie/state/student_state.dart';
import 'package:qrie/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('App loads directly into student home screen with school branding', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Verify student greeting and grade pill are visible
    expect(find.textContaining('Hi,'), findsOneWidget);
    expect(find.textContaining('Class'), findsWidgets);

    // Verify navigation tabs
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Learn')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Practice')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Homework')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Library')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Profile')), findsOneWidget);

    // Verify Hero card Resume CTA
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between student views smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Practice tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Practice'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('PRACTICE & MASTERY'), findsOneWidget);

    // Tap Homework tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Homework'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Homework & Tasks'), findsOneWidget);

    // Tap Library tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Library'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('FORMULAS'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Profile'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Weekly Study Activity'), findsOneWidget);

    // Return to Learn tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Learn'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Tasks & Study Goals'), findsOneWidget);
  });

  testWidgets('Resume Lesson opens LessonScreen with concept details', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Resume button
    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    // Verify LessonScreen opened
    expect(find.byType(LessonScreen), findsOneWidget);

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
