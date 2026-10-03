import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/mock_catalog.dart';
import 'package:harborline_navigator/data/models.dart';

void main() {
  group('Poll model tests', () {
    test('Poll has valid structure', () {
      expect(MockCatalog.polls.isNotEmpty, isTrue);
      final poll = MockCatalog.polls.first;
      expect(poll.id, isNotEmpty);
      expect(poll.title, isNotEmpty);
      expect(poll.shareToken, isNotEmpty);
      expect(poll.options.length, greaterThanOrEqualTo(2));
    });

    test('Poll winningOption returns option with most votes', () {
      final poll = MockCatalog.polls.first;
      final winner = poll.winningOption;
      expect(winner, isNotNull);
      
      // Verify winner has the most votes
      for (final option in poll.options) {
        expect(winner!.voteCount, greaterThanOrEqualTo(option.voteCount));
      }
    });

    test('Poll totalVotes sums all option votes', () {
      final poll = MockCatalog.polls.first;
      final expectedTotal = poll.options.fold<int>(
        0,
        (sum, option) => sum + option.voteCount,
      );
      expect(poll.totalVotes, equals(expectedTotal));
    });

    test('Poll winningOption is null when no options', () {
      const emptyPoll = Poll(
        id: 'empty',
        title: 'Empty Poll',
        shareToken: 'token',
        isActive: true,
        options: [],
      );
      expect(emptyPoll.winningOption, isNull);
      expect(emptyPoll.totalVotes, equals(0));
    });

    test('Poll winningOption handles tie by returning first max', () {
      const pollWithTie = Poll(
        id: 'tie',
        title: 'Tied Poll',
        shareToken: 'token',
        isActive: true,
        options: [
          PollOption(id: 'opt1', text: 'Option 1', voteCount: 10),
          PollOption(id: 'opt2', text: 'Option 2', voteCount: 10),
          PollOption(id: 'opt3', text: 'Option 3', voteCount: 5),
        ],
      );
      final winner = pollWithTie.winningOption;
      expect(winner?.voteCount, equals(10));
    });

    test('Poll status reflects isActive flag', () {
      final poll = MockCatalog.polls.first;
      expect(poll.isActive, isFalse); // Friday snack poll should be closed
    });

    test('Poll options have required fields', () {
      final poll = MockCatalog.polls.first;
      for (final option in poll.options) {
        expect(option.id, isNotEmpty);
        expect(option.text, isNotEmpty);
        expect(option.voteCount, greaterThanOrEqualTo(0));
      }
    });
  });
}
