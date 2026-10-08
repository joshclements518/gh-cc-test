import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/harness_walk.dart';

void main() {
  group('HarnessWalk', () {
    test('creates a walk with name and default step', () {
      final walk = HarnessWalk(name: 'test-walk');
      expect(walk.name, equals('test-walk'));
      expect(walk.step, equals(1));
    });

    test('executes a walk and returns expected string', () {
      final walk = HarnessWalk(name: 'story-1259', step: 2);
      expect(walk.execute(), equals('Harness walk "story-1259" at step 2'));
    });

    test('creates next step with incremented value', () {
      final walk = HarnessWalk(name: 'test-walk', step: 3);
      final next = walk.nextStep();
      expect(next.step, equals(4));
      expect(next.name, equals('test-walk'));
    });

    test('detects completion at step 5', () {
      final walk4 = HarnessWalk(name: 'test-walk', step: 4);
      expect(walk4.isComplete(), isFalse);

      final walk5 = HarnessWalk(name: 'test-walk', step: 5);
      expect(walk5.isComplete(), isTrue);

      final walk6 = HarnessWalk(name: 'test-walk', step: 6);
      expect(walk6.isComplete(), isTrue);
    });
  });
}
