import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/mock_catalog.dart';

void main() {
  test('F1 sample data minimums', () {
    expect(MockCatalog.reservation.id.isNotEmpty, isTrue);
    expect(MockCatalog.itinerary.length, greaterThanOrEqualTo(3));
    expect(MockCatalog.venues.length, greaterThanOrEqualTo(8));
    expect(MockCatalog.inbox.length, greaterThanOrEqualTo(5));
    expect(MockCatalog.chats.length, greaterThanOrEqualTo(2));
    expect(MockCatalog.folio.length, greaterThanOrEqualTo(3));
    expect(MockCatalog.guest.displayName.isNotEmpty, isTrue);
  });

  test('Harness walk routes exist', () {
    expect(MockCatalog.harnessWalkRoutes.length, greaterThanOrEqualTo(3));
    for (final route in MockCatalog.harnessWalkRoutes) {
      expect(route.id.isNotEmpty, isTrue);
      expect(route.title.isNotEmpty, isTrue);
      expect(route.description.isNotEmpty, isTrue);
      expect(route.duration.isNotEmpty, isTrue);
      expect(route.distance.isNotEmpty, isTrue);
      expect(route.stops.length, greaterThanOrEqualTo(3));
    }
  });
}
