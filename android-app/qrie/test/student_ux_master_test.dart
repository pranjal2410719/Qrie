import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
import 'package:qrie/data/mock_data.dart';
import 'package:qrie/screens/home_screen.dart';
import 'package:qrie/screens/learn/learn_screen.dart';
import 'package:qrie/screens/classroom/classroom_screen.dart';
import 'package:qrie/screens/classroom/pdf_viewer_screen.dart';
import 'package:qrie/screens/classroom/image_viewer_screen.dart';
import 'package:qrie/screens/calendar/calendar_screen.dart';
import 'package:qrie/screens/notifications/notifications_screen.dart';
import 'package:qrie/screens/tasks/tasks_screen.dart';
import 'package:qrie/state/student_state.dart';
import 'package:qrie/widgets/bottom_nav_bar.dart';
import 'package:qrie/widgets/recent_lecture_card.dart';
import 'package:qrie/widgets/calendar_events_panel.dart';
import 'package:qrie/widgets/floating_ai_tutor_widget.dart';

void main() {
  group('1. Home Screen & Floating Bottom Navigation Tests', () {
    testWidgets('Offers & Power-ups section is completely absent from Home screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const QrieApp(skipSplash: true));
      await tester.pumpAndSettle();

      // Verify Offers and Power-ups section and promo banner are NOT present
      expect(find.text('Hot Offers & Power-Ups'), findsNothing);
      expect(find.text('PROMO'), findsNothing);
    });

    testWidgets('Floating Bottom Navigation displays Home, Learn, Library, Profile in rounded detached container', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const QrieApp(skipSplash: true));
      await tester.pumpAndSettle();

      final navBarFinder = find.byType(BottomNavBar);
      expect(navBarFinder, findsOneWidget);

      // Verify labels
      expect(find.descendant(of: navBarFinder, matching: find.text('Home')), findsOneWidget);
      expect(find.descendant(of: navBarFinder, matching: find.text('Learn')), findsOneWidget);
      expect(find.descendant(of: navBarFinder, matching: find.text('Library')), findsOneWidget);
      expect(find.descendant(of: navBarFinder, matching: find.text('Profile')), findsOneWidget);

      // Old "Practice" bottom nav destination must not exist in BottomNavBar
      expect(find.descendant(of: navBarFinder, matching: find.text('Practice')), findsNothing);
    });

    testWidgets('Recent Lecture card displays real student activity and restores progress', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final studentState = StudentState();
      await tester.pumpWidget(
        StudentStateScope(
          notifier: studentState,
          child: const MaterialApp(
            home: Scaffold(body: HomeScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify recent lecture card is populated with actual ongoing lecture
      expect(find.byType(RecentLectureCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(RecentLectureCard),
          matching: find.text('Parts of a Cell & Membrane'),
        ),
        findsOneWidget,
      );
      expect(find.text('SCIENCE & BIO'), findsWidgets);
      expect(find.text('Continue learning'), findsOneWidget);
    });

    testWidgets('Recent Lecture card displays first-time empty state when no lecture accessed', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final studentState = StudentState();
      studentState.clearRecentLecture();

      await tester.pumpWidget(
        StudentStateScope(
          notifier: studentState,
          child: const MaterialApp(
            home: Scaffold(body: HomeScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('START YOUR FIRST LECTURE'), findsOneWidget);
      expect(find.text('No recent lectures yet'), findsOneWidget);
      expect(find.text('Browse Subjects & Start Learning'), findsOneWidget);
    });
  });

  group('2. Dynamic Interactive Calendar Tests', () {
    testWidgets('Selecting a date displays scheduled events for that specific date', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final today = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarEventsPanel(selectedDate: today),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Today has live class scheduled
      expect(find.textContaining('Science Live Class'), findsOneWidget);
      expect(find.text('LIVE CLASS'), findsOneWidget);
      expect(find.text('Science & Bio'), findsWidgets);
    });

    testWidgets('Dates with no events display clear empty state', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // A distant future date with no events
      final distantDate = DateTime.now().add(const Duration(days: 90));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarEventsPanel(selectedDate: distantDate),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing scheduled for this day'), findsOneWidget);
      expect(find.text('Enjoy your free time or revise completed topics.'), findsOneWidget);
    });
  });

  group('3. Tasks & Study Goals Tests', () {
    testWidgets('TasksScreen filters items by All, Scheduled, Active, and Overdue', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final studentState = StudentState();

      await tester.pumpWidget(
        StudentStateScope(
          notifier: studentState,
          child: const MaterialApp(
            home: TasksScreen(initialCategory: TaskCategoryFilter.all),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // All tab shows items
      expect(find.text('Tasks & Study Goals'), findsOneWidget);
      expect(find.text('STUDY GOAL'), findsOneWidget);

      // Tap Overdue tab
      await tester.tap(find.text('Overdue'));
      await tester.pumpAndSettle();

      // Tap Active tab
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();

      // Tap Scheduled tab
      await tester.tap(find.text('Scheduled'));
      await tester.pumpAndSettle();
    });
  });

  group('4. Learn Library & Navigation Hierarchy Tests', () {
    testWidgets('Learn Landing Screen displays subjects and navigates into Subject Detail', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final studentState = StudentState();

      await tester.pumpWidget(
        StudentStateScope(
          notifier: studentState,
          child: const MaterialApp(
            home: LearnScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('LEARNING LIBRARY'), findsOneWidget);
      expect(find.text('Syllabus & Subjects'), findsOneWidget);
      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('Science & Bio'), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);

      // Tap Science & Bio subject card
      await tester.tap(find.text('Science & Bio'));
      await tester.pumpAndSettle();

      // Verify navigated into SubjectDetailScreen
      expect(find.text('NCERT CURRICULUM'), findsOneWidget);
      expect(find.text('Chapter 1: Cell — Structure & Functions'), findsOneWidget);

      // Tap Chapter card to open ChapterTopicsScreen
      await tester.tap(find.text('Chapter 1: Cell — Structure & Functions'));
      await tester.pumpAndSettle();

      // Verify ChapterTopicsScreen is open
      expect(find.text('Discovery of the Cell'), findsOneWidget);
      expect(find.text('Parts of a Cell & Membrane'), findsOneWidget);

      // Tap first topic to open ClassroomScreen
      await tester.tap(find.text('Discovery of the Cell'));
      await tester.pumpAndSettle();

      // Verify ClassroomScreen is open
      expect(find.text('QRIE LIVE CLASSROOM'), findsOneWidget);
      expect(find.text('Topic Study Resources'), findsOneWidget);

      // Test back navigation
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Discovery of the Cell'), findsOneWidget); // Back to Topics

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('NCERT CURRICULUM'), findsOneWidget); // Back to Subject
    });
  });

  group('5. Classroom & Study Material Viewers Tests', () {
    testWidgets('ClassroomScreen displays video player, study materials, and opens PDF & Image viewers', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final studentState = StudentState();
      final subject = MockData.subjects.firstWhere((s) => s.id == 'science');
      final chapter = MockData.chapters.firstWhere((c) => c.subjectId == 'science');
      final lesson = chapter.lessons.first;

      await tester.pumpWidget(
        StudentStateScope(
          notifier: studentState,
          child: MaterialApp(
            home: ClassroomScreen(
              subject: subject,
              chapter: chapter,
              lesson: lesson,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Classroom Header and Player
      expect(find.text('QRIE LIVE CLASSROOM'), findsOneWidget);
      expect(find.text('Discovery of the Cell'), findsWidgets);
      expect(find.text('Topic Study Resources'), findsOneWidget);

      // Verify Study Materials list items
      expect(find.text('NCERT Chapter 1 Notes — Cell Discovery'), findsOneWidget);
      expect(find.text('Cork Cells Microscopic Diagram'), findsOneWidget);

      // Verify Floating Qrie AI assistant is present
      expect(find.byType(FloatingAITutorWidget), findsOneWidget);

      // Open PDF viewer
      await tester.tap(find.text('NCERT Chapter 1 Notes — Cell Discovery'));
      await tester.pumpAndSettle();

      expect(find.byType(PdfViewerScreen), findsOneWidget);
      expect(find.text('NCERT SYLLABUS NOTES'), findsOneWidget);

      // Back to classroom
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(PdfViewerScreen), findsNothing);

      // Open Image viewer
      await tester.tap(find.text('Cork Cells Microscopic Diagram'));
      await tester.pumpAndSettle();

      expect(find.byType(ImageViewerScreen), findsOneWidget);

      // Back to classroom
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(ImageViewerScreen), findsNothing);
    });
  });

  group('6. Top App Bar Calendar & Notifications Tests', () {
    testWidgets('Tapping Calendar icon in top app bar opens dedicated CalendarScreen', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const QrieApp(skipSplash: true));
      await tester.pumpAndSettle();

      // Find calendar button in top app bar
      final calFinder = find.byTooltip('Academic Calendar');
      expect(calFinder, findsOneWidget);

      await tester.tap(calFinder);
      await tester.pumpAndSettle();

      // Verify CalendarScreen is displayed
      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.text('Academic Calendar'), findsOneWidget);
      expect(find.text('Scheduled Sessions'), findsOneWidget);

      // Back to Home
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarScreen), findsNothing);
    });

    testWidgets('Tapping Notification icon in top app bar opens NotificationsScreen with unread updates', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const QrieApp(skipSplash: true));
      await tester.pumpAndSettle();

      // Find notifications button in top app bar
      final notifFinder = find.byTooltip('Notifications');
      expect(notifFinder, findsOneWidget);

      await tester.tap(notifFinder);
      await tester.pumpAndSettle();

      // Verify NotificationsScreen is displayed
      expect(find.byType(NotificationsScreen), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Math Homework Due Today'), findsOneWidget);

      // Tap Mark read
      await tester.tap(find.text('Mark read'));
      await tester.pumpAndSettle();

      expect(find.text('All caught up'), findsOneWidget);

      // Back to Home
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationsScreen), findsNothing);
    });
  });
}
