import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';

void main() {
  testWidgets('App loads directly into student home screen with school branding', (WidgetTester tester) async {
    // Build our app skipping splash for deterministic widget test
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();

    // Verify school organization branding appears
    expect(find.textContaining('Delhi Public School'), findsOneWidget);

    // Verify student grade pill is visible
    expect(find.textContaining('CLASS 8'), findsWidgets);

    // Verify navigation tabs
    expect(find.text('LEARN'), findsOneWidget);
    expect(find.text('PRACTICE'), findsOneWidget);
    expect(find.text('ASK QRIE'), findsOneWidget);
    expect(find.text('LIBRARY'), findsOneWidget);
    expect(find.text('BADGES'), findsOneWidget);

    // Verify Hero card Resume Lesson CTA
    expect(find.text('RESUME LESSON'), findsOneWidget);
  });
}
