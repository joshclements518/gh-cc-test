import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/utils/harness_utils.dart';

void main() {
  group('Harness Utils Tests', () {
    test('harnessWalkGreeting returns correct message', () {
      expect(harnessWalkGreeting(), 'Welcome to Harness Walk - Story A');
    });

    test('isHarnessWalkEnabled returns true', () {
      expect(isHarnessWalkEnabled(), true);
    });

    test('harnessWalkVersion returns correct version', () {
      expect(harnessWalkVersion(), '1.0.0');
    });
  });
}
