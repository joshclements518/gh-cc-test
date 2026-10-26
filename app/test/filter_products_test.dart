import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/models.dart';
import 'package:harborline_navigator/utils/filter_products.dart';

void main() {
  group('filterProductsByWellness', () {
    final testVenues = [
      const Venue(
        id: 'v1',
        name: 'Wellness Center',
        deck: 'Deck 12',
        category: 'Wellness',
        blurb: 'Holistic health consultations',
        hours: '8a–6p',
        tags: ['wellness', 'health'],
      ),
      const Venue(
        id: 'v2',
        name: 'Coral Room',
        deck: 'Deck 3',
        category: 'Dining',
        blurb: 'Rotational dining',
        hours: '5:30p–9:30p',
        tags: ['dinner'],
      ),
      const Venue(
        id: 'v3',
        name: 'Meditation Sanctuary',
        deck: 'Deck 13',
        category: 'Wellness',
        blurb: 'Guided meditation sessions',
        hours: '6a–8p',
        tags: ['wellness', 'meditation'],
      ),
      const Venue(
        id: 'v4',
        name: 'Fitness Studio',
        deck: 'Deck 14',
        category: 'Fitness',
        blurb: 'Classes and open gym',
        hours: '6a–9p',
        tags: ['fitness'],
      ),
    ];

    test('returns all venues when wellness filter is inactive', () {
      final result = filterProductsByWellness(testVenues, false);
      expect(result.length, equals(4));
      expect(result, equals(testVenues));
    });

    test('returns only wellness venues when wellness filter is active', () {
      final result = filterProductsByWellness(testVenues, true);
      expect(result.length, equals(2));
      expect(result.every((v) => v.category == 'Wellness'), isTrue);
      expect(result.map((v) => v.id).toList(), equals(['v1', 'v3']));
    });

    test('returns empty list when no wellness venues exist and filter is active', () {
      final nonWellnessVenues = [
        const Venue(
          id: 'v1',
          name: 'Coral Room',
          deck: 'Deck 3',
          category: 'Dining',
          blurb: 'Rotational dining',
          hours: '5:30p–9:30p',
          tags: ['dinner'],
        ),
      ];
      final result = filterProductsByWellness(nonWellnessVenues, true);
      expect(result.length, equals(0));
      expect(result, isEmpty);
    });

    test('handles empty venue list', () {
      final result = filterProductsByWellness([], true);
      expect(result, isEmpty);
    });

    test('is a pure function - does not modify original list', () {
      final original = List<Venue>.from(testVenues);
      filterProductsByWellness(testVenues, true);
      expect(testVenues, equals(original));
    });
  });
}
