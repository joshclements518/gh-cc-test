import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/harness_walk.dart';

void main() {
  group('HarnessWalk', () {
    late HarnessWalk walk;

    setUp(() {
      walk = HarnessWalk();
    });

    test('starts with no steps', () {
      expect(walk.stepCount, equals(0));
      expect(walk.steps, isEmpty);
    });

    test('records steps', () {
      walk.step('first');
      walk.step('second');
      walk.step('third');
      
      expect(walk.stepCount, equals(3));
      expect(walk.steps, equals(['first', 'second', 'third']));
    });

    test('checks if step exists', () {
      walk.step('alpha');
      walk.step('beta');
      
      expect(walk.hasStep('alpha'), isTrue);
      expect(walk.hasStep('beta'), isTrue);
      expect(walk.hasStep('gamma'), isFalse);
    });

    test('validates expected steps', () {
      walk.step('init');
      walk.step('process');
      walk.step('complete');
      
      expect(walk.validate(['init', 'process', 'complete']), isTrue);
      expect(walk.validate(['init', 'complete']), isFalse);
      expect(walk.validate(['init', 'process', 'complete', 'extra']), isFalse);
    });

    test('resets steps', () {
      walk.step('one');
      walk.step('two');
      expect(walk.stepCount, equals(2));
      
      walk.reset();
      expect(walk.stepCount, equals(0));
      expect(walk.steps, isEmpty);
    });

    test('returns immutable steps list', () {
      walk.step('test');
      final steps = walk.steps;
      
      expect(() => steps.add('invalid'), throwsUnsupportedError);
    });
  });
}
