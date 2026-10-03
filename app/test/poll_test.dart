import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/models.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  group('Poll functionality', () {
    test('Poll model should be created with required fields', () {
      final poll = Poll(
        id: 'test-123',
        title: 'Friday Snack Vote',
        options: ['Chips', 'Cookies', 'Fruit'],
        shareToken: 'ABC123',
        createdAt: DateTime.now(),
      );

      expect(poll.id, 'test-123');
      expect(poll.title, 'Friday Snack Vote');
      expect(poll.options.length, 3);
      expect(poll.shareToken, 'ABC123');
      expect(poll.createdAt, isNotNull);
    });

    test('AppState should store and retrieve polls', () {
      final state = AppState(HarborlineServices());
      
      final poll1 = Poll(
        id: 'poll-1',
        title: 'Snack Vote 1',
        options: ['Option A', 'Option B'],
        shareToken: 'TOKEN1',
      );

      final poll2 = Poll(
        id: 'poll-2',
        title: 'Snack Vote 2',
        options: ['Option X', 'Option Y', 'Option Z'],
        shareToken: 'TOKEN2',
      );

      expect(state.polls.length, 0);

      state.savePoll(poll1);
      expect(state.polls.length, 1);
      expect(state.polls.first.title, 'Snack Vote 1');

      state.savePoll(poll2);
      expect(state.polls.length, 2);
    });

    test('AppState should retrieve poll by token', () {
      final state = AppState(HarborlineServices());
      
      final poll = Poll(
        id: 'poll-1',
        title: 'Snack Vote',
        options: ['Chips', 'Cookies'],
        shareToken: 'ABC123',
      );

      state.savePoll(poll);

      final retrieved = state.getPollByToken('ABC123');
      expect(retrieved, isNotNull);
      expect(retrieved?.id, 'poll-1');
      expect(retrieved?.title, 'Snack Vote');

      final notFound = state.getPollByToken('INVALID');
      expect(notFound, isNull);
    });

    test('Poll should support multiple options', () {
      final poll = Poll(
        id: 'poll-1',
        title: 'Many Options',
        options: ['A', 'B', 'C', 'D', 'E', 'F'],
        shareToken: 'TOKEN',
      );

      expect(poll.options.length, 6);
      expect(poll.options.contains('A'), isTrue);
      expect(poll.options.contains('F'), isTrue);
    });
  });
}
