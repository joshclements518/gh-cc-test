import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/harness_walk.dart';

void main() {
  group('HarnessWalk', () {
    test('walk returns correct result for positive steps', () {
      final result = HarnessWalk.walk(100);
      
      expect(result.steps, equals(100));
      expect(result.distance, equals(75.0));
      expect(result.status, equals('completed'));
    });
    
    test('walk returns correct result for zero steps', () {
      final result = HarnessWalk.walk(0);
      
      expect(result.steps, equals(0));
      expect(result.distance, equals(0.0));
      expect(result.status, equals('no movement'));
    });
    
    test('walk throws ArgumentError for negative steps', () {
      expect(() => HarnessWalk.walk(-1), throwsArgumentError);
    });
    
    test('walk calculates distance correctly', () {
      final result = HarnessWalk.walk(1000);
      
      expect(result.distance, equals(750.0));
    });
    
    test('WalkResult toString returns formatted string', () {
      const result = WalkResult(steps: 100, distance: 75.0, status: 'completed');
      
      expect(result.toString(), contains('100'));
      expect(result.toString(), contains('75.00'));
      expect(result.toString(), contains('completed'));
    });
  });
  
  group('WalkSession', () {
    test('starts with zero steps and distance', () {
      final session = HarnessWalk.startSession();
      
      expect(session.totalSteps, equals(0));
      expect(session.totalDistance, equals(0.0));
    });
    
    test('addSteps increments totals correctly', () {
      final session = HarnessWalk.startSession();
      
      session.addSteps(50);
      expect(session.totalSteps, equals(50));
      expect(session.totalDistance, equals(37.5));
      
      session.addSteps(50);
      expect(session.totalSteps, equals(100));
      expect(session.totalDistance, equals(75.0));
    });
    
    test('addSteps throws ArgumentError for negative steps', () {
      final session = HarnessWalk.startSession();
      
      expect(() => session.addSteps(-1), throwsArgumentError);
    });
    
    test('getResult returns correct status for active session', () {
      final session = HarnessWalk.startSession();
      session.addSteps(10);
      
      final result = session.getResult();
      expect(result.status, equals('active'));
    });
    
    test('getResult returns correct status for idle session', () {
      final session = HarnessWalk.startSession();
      
      final result = session.getResult();
      expect(result.status, equals('idle'));
    });
    
    test('reset clears all progress', () {
      final session = HarnessWalk.startSession();
      session.addSteps(100);
      
      session.reset();
      
      expect(session.totalSteps, equals(0));
      expect(session.totalDistance, equals(0.0));
    });
    
    test('multiple sessions work independently', () {
      final session1 = HarnessWalk.startSession();
      final session2 = HarnessWalk.startSession();
      
      session1.addSteps(50);
      session2.addSteps(100);
      
      expect(session1.totalSteps, equals(50));
      expect(session2.totalSteps, equals(100));
    });
  });
}
