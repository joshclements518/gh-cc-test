import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/services.dart';

void main() {
  group('HarnessWalkService', () {
    late HarnessWalkService service;

    setUp(() {
      service = HarnessWalkService();
    });

    test('starts with zero walk points', () {
      expect(service.walkCount, equals(0));
      expect(service.walkPoints, isEmpty);
    });

    test('records walk points correctly', () {
      service.recordWalkPoint('Point A');
      expect(service.walkCount, equals(1));
      expect(service.walkPoints, contains('Point A'));

      service.recordWalkPoint('Point B');
      expect(service.walkCount, equals(2));
      expect(service.walkPoints, containsAll(['Point A', 'Point B']));
    });

    test('clears walk points', () {
      service.recordWalkPoint('Point A');
      service.recordWalkPoint('Point B');
      expect(service.walkCount, equals(2));

      service.clearWalk();
      expect(service.walkCount, equals(0));
      expect(service.walkPoints, isEmpty);
    });

    test('returns unmodifiable list of walk points', () {
      service.recordWalkPoint('Point A');
      final points = service.walkPoints;
      
      expect(() => points.add('Point B'), throwsUnsupportedError);
    });

    test('maintains order of recorded points', () {
      service.recordWalkPoint('First');
      service.recordWalkPoint('Second');
      service.recordWalkPoint('Third');

      expect(service.walkPoints[0], equals('First'));
      expect(service.walkPoints[1], equals('Second'));
      expect(service.walkPoints[2], equals('Third'));
    });
  });
}
