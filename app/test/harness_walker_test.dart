import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/utils/harness_walker.dart';

void main() {
  group('HarnessWalker', () {
    late HarnessWalker walker;

    setUp(() {
      walker = HarnessWalker();
    });

    test('initializes with default nodes', () {
      expect(walker.availableNodes, isNotEmpty);
      expect(walker.availableNodes, contains('home'));
      expect(walker.availableNodes, contains('plans'));
      expect(walker.availableNodes, contains('explore'));
      expect(walker.availableNodes, contains('messages'));
      expect(walker.availableNodes, contains('account'));
    });

    test('walk returns WalkResult with visited nodes', () {
      final result = walker.walk('home/plans/explore');
      
      expect(result.path, equals('home/plans/explore'));
      expect(result.visited, containsAll(['home', 'plans', 'explore']));
      expect(result.visited.length, equals(3));
      expect(result.timestamp, isNotNull);
    });

    test('walk ignores unknown nodes', () {
      final result = walker.walk('home/unknown/plans');
      
      expect(result.visited, containsAll(['home', 'plans']));
      expect(result.visited.length, equals(2));
      expect(result.visited, isNot(contains('unknown')));
    });

    test('walk handles empty path', () {
      final result = walker.walk('');
      
      expect(result.visited, isEmpty);
    });

    test('walk handles path with leading/trailing slashes', () {
      final result = walker.walk('/home/plans/');
      
      expect(result.visited, containsAll(['home', 'plans']));
      expect(result.visited.length, equals(2));
    });

    test('hasVisited returns true for visited nodes', () {
      walker.walk('home/plans');
      
      expect(walker.hasVisited('home'), isTrue);
      expect(walker.hasVisited('plans'), isTrue);
      expect(walker.hasVisited('explore'), isFalse);
    });

    test('reset clears visited nodes', () {
      walker.walk('home/plans');
      expect(walker.visitedNodes, isNotEmpty);
      
      walker.reset();
      expect(walker.visitedNodes, isEmpty);
      expect(walker.hasVisited('home'), isFalse);
    });

    test('supports custom nodes', () {
      final customWalker = HarnessWalker(initialNodes: ['custom', 'nodes']);
      final result = customWalker.walk('custom/nodes');
      
      expect(result.visited, containsAll(['custom', 'nodes']));
    });

    test('WalkResult toString includes key information', () {
      final result = walker.walk('home');
      final str = result.toString();
      
      expect(str, contains('home'));
      expect(str, contains('visited'));
    });
  });
}
