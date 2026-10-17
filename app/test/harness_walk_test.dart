import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/harness_walk/harness_walk_screen.dart';
import 'package:harborline_navigator/data/mock_catalog.dart';

void main() {
  testWidgets('HarnessWalkScreen displays routes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HarnessWalkScreen(),
      ),
    );

    // Verify the title is shown
    expect(find.text('Explore Aether of the Seas'), findsOneWidget);

    // Verify at least one route is displayed
    expect(find.text('Welcome Walk'), findsOneWidget);
    
    // Verify route details are shown
    final routes = MockCatalog.harnessWalkRoutes;
    for (final route in routes) {
      expect(find.text(route.title), findsOneWidget);
    }
  });

  testWidgets('HarnessWalkScreen has app bar with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HarnessWalkScreen(),
      ),
    );

    expect(find.widgetWithText(AppBar, 'Ship Tours'), findsOneWidget);
  });
}
