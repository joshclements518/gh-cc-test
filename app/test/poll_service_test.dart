import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/services.dart';

void main() {
  group('PollService', () {
    late PollService pollService;

    setUp(() {
      pollService = PollService();
    });

    test('createPoll returns poll with correct schema', () {
      final question = 'What snack should we get this Friday?';
      final deadline = DateTime(2026, 11, 6);

      final poll = pollService.createPoll(
        question: question,
        deadline: deadline,
      );

      expect(poll.pollId, isNotEmpty);
      expect(poll.pollId, startsWith('poll-'));
      expect(poll.question, equals(question));
      expect(poll.deadline, equals(deadline));
      expect(poll.status, equals('open'));
    });

    test('createPoll stores poll in memory', () {
      final question = 'What snack should we get?';
      final deadline = DateTime(2026, 11, 6);

      final poll = pollService.createPoll(
        question: question,
        deadline: deadline,
      );

      final retrieved = pollService.getPoll(poll.pollId);
      expect(retrieved, isNotNull);
      expect(retrieved!.pollId, equals(poll.pollId));
      expect(retrieved.question, equals(question));
    });

    test('createPoll generates unique poll IDs', () {
      final deadline = DateTime(2026, 11, 6);

      final poll1 = pollService.createPoll(
        question: 'Question 1',
        deadline: deadline,
      );
      final poll2 = pollService.createPoll(
        question: 'Question 2',
        deadline: deadline,
      );

      expect(poll1.pollId, isNot(equals(poll2.pollId)));
    });

    test('getAllPolls returns all created polls', () {
      final deadline = DateTime(2026, 11, 6);

      pollService.createPoll(question: 'Q1', deadline: deadline);
      pollService.createPoll(question: 'Q2', deadline: deadline);
      pollService.createPoll(question: 'Q3', deadline: deadline);

      final allPolls = pollService.getAllPolls();
      expect(allPolls.length, equals(3));
    });

    test('poll toJson returns correct JSON structure', () {
      final question = 'Test question';
      final deadline = DateTime(2026, 11, 6);

      final poll = pollService.createPoll(
        question: question,
        deadline: deadline,
      );

      final json = poll.toJson();
      expect(json['pollId'], equals(poll.pollId));
      expect(json['question'], equals(question));
      expect(json['deadline'], equals(deadline.toIso8601String()));
      expect(json['status'], equals('open'));
    });
  });
}
