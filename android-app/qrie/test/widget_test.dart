import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
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
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Home')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Learn')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Library')), findsOneWidget);
    expect(find.descendant(of: find.byType(BottomNavBar), matching: find.text('Profile')), findsOneWidget);

    // Verify Recent Lecture CTA
    expect(find.text('Continue learning'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between student views smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Learn tab (now opens Syllabus & Subject library)
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Learn'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('LEARNING LIBRARY'), findsOneWidget);
    expect(find.text('Syllabus & Subjects'), findsOneWidget);

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

    // Return to Home tab
    await tester.tap(find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.text('Home'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Tasks & Study Goals'), findsOneWidget);
  });

  testWidgets('Resume Lesson opens ClassroomScreen with lecture details', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Tap Continue learning button
    await tester.tap(find.text('Continue learning'));
    await tester.pumpAndSettle();

    // Verify Classroom opened
    expect(find.text('QRIE LIVE CLASSROOM'), findsOneWidget);

    // Pop back to home via back button
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('QRIE LIVE CLASSROOM'), findsNothing);
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
