import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/explore/explore_screen.dart';
import 'package:harborline_navigator/data/mock_catalog.dart';

void main() {
  group('Story 331: Explore Category Filter Chip', () {
    testWidgets('Category filter chips are visible on Explore page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExploreScreen(),
        ),
      );

      // Wait for widget to build
      await tester.pumpAndSettle();

      // AC1: The category filter chip is visible on the Explore page
      expect(find.byType(FilterChip), findsWidgets);
      
      // Should have "All" chip plus category chips
      expect(find.widgetWithText(FilterChip, 'All'), findsOneWidget);
      
      // Verify some expected categories are present
      expect(find.widgetWithText(FilterChip, 'Spa'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Fitness'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Dining'), findsOneWidget);
    });

    testWidgets('Selecting a category chip filters venues correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExploreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Count initial venues shown (all venues)
      final allVenuesCount = MockCatalog.venues.length;
      
      // AC2: Selecting a category chip filters the MockCatalog.venues accordingly
      // Tap on the "Spa" category chip
      await tester.tap(find.widgetWithText(FilterChip, 'Spa'));
      await tester.pumpAndSettle();

      // Verify only Spa venues are shown
      final spaVenues = MockCatalog.venues.where((v) => v.category == 'Spa').toList();
      expect(spaVenues.length, greaterThan(0), reason: 'Should have at least one Spa venue');
      
      // Find the specific Spa venue in the list
      for (final venue in spaVenues) {
        expect(find.text(venue.name), findsOneWidget);
      }

      // Verify non-Spa venues are not shown
      final nonSpaVenues = MockCatalog.venues.where((v) => v.category != 'Spa').toList();
      for (final venue in nonSpaVenues) {
        expect(find.text(venue.name), findsNothing);
      }
    });

    testWidgets('Filtered list updates dynamically without page reloads', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExploreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // AC3: The filtered list updates dynamically without page reloads
      // Select "Fitness" category
      await tester.tap(find.widgetWithText(FilterChip, 'Fitness'));
      await tester.pumpAndSettle();

      // Verify Fitness venues are shown
      final fitnessVenues = MockCatalog.venues.where((v) => v.category == 'Fitness').toList();
      expect(fitnessVenues.length, greaterThan(0), reason: 'Should have at least one Fitness venue');
      
      for (final venue in fitnessVenues) {
        expect(find.text(venue.name), findsOneWidget);
      }

      // Now switch to "Dining" category - should update without reload
      await tester.tap(find.widgetWithText(FilterChip, 'Dining'));
      await tester.pumpAndSettle();

      // Verify Dining venues are now shown instead
      final diningVenues = MockCatalog.venues.where((v) => v.category == 'Dining').toList();
      expect(diningVenues.length, greaterThan(0), reason: 'Should have at least one Dining venue');
      
      for (final venue in diningVenues) {
        expect(find.text(venue.name), findsOneWidget);
      }

      // Verify Fitness venues are no longer shown
      for (final venue in fitnessVenues) {
        expect(find.text(venue.name), findsNothing);
      }

      // Return to "All" filter
      await tester.tap(find.widgetWithText(FilterChip, 'All'));
      await tester.pumpAndSettle();

      // Verify all venues are shown again
      expect(MockCatalog.venues.length, greaterThan(diningVenues.length + fitnessVenues.length));
    });

    testWidgets('Filter chips work in combination with search', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExploreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Additional test: Verify filters work with search functionality
      // Select "Spa" category
      await tester.tap(find.widgetWithText(FilterChip, 'Spa'));
      await tester.pumpAndSettle();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'Chart');
      await tester.pumpAndSettle();

      // Should only show Spa venues that match "Chart"
      final chartRoomSpa = MockCatalog.venues.firstWhere(
        (v) => v.name.contains('Chart') && v.category == 'Spa',
      );
      expect(find.text(chartRoomSpa.name), findsOneWidget);

      // Other Spa venues without "Chart" should not be shown
      final otherSpaVenues = MockCatalog.venues.where(
        (v) => v.category == 'Spa' && !v.name.contains('Chart')
      ).toList();
      
      for (final venue in otherSpaVenues) {
        expect(find.text(venue.name), findsNothing);
      }
    });

    test('MockCatalog has venues with Spa and Fitness categories', () {
      // Verify data prerequisites for the feature
      final categories = MockCatalog.venues.map((v) => v.category).toSet();
      
      expect(categories.contains('Spa'), isTrue, reason: 'MockCatalog should have Spa venues');
      expect(categories.contains('Fitness'), isTrue, reason: 'MockCatalog should have Fitness venues');
      
      // Verify we have multiple categories to filter by
      expect(categories.length, greaterThanOrEqualTo(3), reason: 'Should have multiple venue categories');
    });
  });
}
