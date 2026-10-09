import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/harness_walk_service.dart';

void main() {
  group('HarnessWalkService', () {
    late HarnessWalkService service;

    setUp(() {
      service = HarnessWalkService();
    });

    test('performWalk returns success message', () {
      final result = service.performWalk();
      expect(result, 'Harness walk completed');
    });

    test('isWalkActive returns true', () {
      expect(service.isWalkActive(), isTrue);
    });

    test('resetWalk completes without error', () {
      expect(() => service.resetWalk(), returnsNormally);
    });
  });
}
