import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/main.dart';
import 'package:qrie/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('overflow capture', (tester) async {
    String currentPhase = 'startup';
    FlutterError.onError = (details) {
      // ignore: avoid_print
      print('=== OVERFLOW DETECTED during [$currentPhase] ===');
      // ignore: avoid_print
      print('EXCEPTION: ${details.exceptionAsString()}');
      final collector = details.informationCollector?.call() ?? [];
      for (final d in collector) {
        // ignore: avoid_print
        print('  INFO: ${d.toDescription()}');
      }
    };
    tester.view.physicalSize = const Size(720, 1604);
    tester.view.devicePixelRatio = 2.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.25;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    currentPhase = 'initial HomeScreen';
    await tester.pumpWidget(const QrieApp(skipSplash: true));
    await tester.pumpAndSettle();
    void drain(String context) {
      while (true) {
        final e = tester.takeException();
        if (e == null) break;
      }
    }
    drain('initial HomeScreen');
    for (final label in ['Practice', 'Homework', 'Library', 'Profile', 'Learn']) {
      currentPhase = 'switching to $label';
      await tester.tap(find.descendant(
        of: find.byType(BottomNavBar),
        matching: find.text(label),
      ));
      await tester.pumpAndSettle();
      drain('after tap $label');
    }
    currentPhase = 'opening LessonScreen';
    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();
    drain('in LessonScreen');
    currentPhase = 'back from LessonScreen';
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    drain('after back from LessonScreen');
  });
}
