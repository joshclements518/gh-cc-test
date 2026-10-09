import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/services.dart';

void main() {
  group('HarnessWalkService', () {
    late HarnessWalkService service;

    setUp(() {
      service = HarnessWalkService();
    });

    test('starts with empty walks list', () {
      expect(service.walks, isEmpty);
      expect(service.activeWalkCount, 0);
    });

    test('can add a walk', () {
      final walk = WalkActivity(
        id: 'test1',
        name: 'Test Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
        location: 'Deck 5',
      );

      service.addWalk(walk);
      expect(service.walks.length, 1);
      expect(service.walks.first.id, 'test1');
    });

    test('can retrieve a walk by id', () {
      final walk = WalkActivity(
        id: 'test2',
        name: 'Another Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 45),
        location: 'Deck 10',
      );

      service.addWalk(walk);
      final retrieved = service.getWalk('test2');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Another Walk');
    });

    test('returns null for non-existent walk', () {
      final retrieved = service.getWalk('does-not-exist');
      expect(retrieved, isNull);
    });

    test('can remove a walk', () {
      final walk = WalkActivity(
        id: 'test3',
        name: 'Temporary Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 20),
        location: 'Deck 2',
      );

      service.addWalk(walk);
      expect(service.walks.length, 1);

      service.removeWalk('test3');
      expect(service.walks, isEmpty);
    });

    test('tracks active walk count correctly', () {
      service.addWalk(WalkActivity(
        id: 'active1',
        name: 'Active Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
        location: 'Deck 5',
        status: WalkStatus.active,
      ));

      service.addWalk(WalkActivity(
        id: 'scheduled1',
        name: 'Scheduled Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
        location: 'Deck 6',
        status: WalkStatus.scheduled,
      ));

      expect(service.activeWalkCount, 1);
    });

    test('walks list is immutable', () {
      final walk = WalkActivity(
        id: 'immutable1',
        name: 'Test',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
        location: 'Deck 5',
      );

      service.addWalk(walk);
      final walksList = service.walks;
      
      // This should not affect the service's internal list
      expect(() => walksList.add(walk), throwsUnsupportedError);
    });
  });

  group('WalkActivity', () {
    test('can be created with required fields', () {
      final walk = WalkActivity(
        id: 'w1',
        name: 'Morning Walk',
        startTime: DateTime(2026, 10, 9, 8, 0),
        duration: const Duration(minutes: 45),
        location: 'Deck 12',
      );

      expect(walk.id, 'w1');
      expect(walk.name, 'Morning Walk');
      expect(walk.duration, const Duration(minutes: 45));
      expect(walk.status, WalkStatus.scheduled); // default
    });

    test('can be created with custom status', () {
      final walk = WalkActivity(
        id: 'w2',
        name: 'Active Walk',
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
        location: 'Deck 5',
        status: WalkStatus.active,
      );

      expect(walk.status, WalkStatus.active);
    });
  });

  group('WalkStatus', () {
    test('has all expected values', () {
      expect(WalkStatus.values, containsAll([
        WalkStatus.scheduled,
        WalkStatus.active,
        WalkStatus.completed,
      ]));
    });
  });
}
