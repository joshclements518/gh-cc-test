import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/models.dart';
import 'package:harborline_navigator/services/services.dart';

void main() {
  group('PollService', () {
    late PollService pollService;

    setUp(() {
      pollService = PollService();
    });

    test('createPoll creates a poll with question and deadline', () async {
      final poll = await pollService.createPoll(
        question: 'What snack should we order?',
        deadline: 'Friday 12:00 PM',
      );

      expect(poll.id, isNotEmpty);
      expect(poll.question, 'What snack should we order?');
      expect(poll.deadline, 'Friday 12:00 PM');
      expect(poll.options, isEmpty);
    });

    test('createPoll returns unique poll ids', () async {
      final poll1 = await pollService.createPoll(
        question: 'Question 1',
        deadline: 'Friday',
      );
      final poll2 = await pollService.createPoll(
        question: 'Question 2',
        deadline: 'Saturday',
      );

      expect(poll1.id, isNot(equals(poll2.id)));
    });

    test('addOption adds an option to a poll', () async {
      final poll = await pollService.createPoll(
        question: 'What snack?',
        deadline: 'Friday',
      );

      final option = await pollService.addOption(
        pollId: poll.id,
        text: 'Pizza',
      );

      expect(option.id, isNotEmpty);
      expect(option.pollId, poll.id);
      expect(option.text, 'Pizza');
      expect(poll.options, contains(option));
    });

    test('addOption can add multiple options to a poll', () async {
      final poll = await pollService.createPoll(
        question: 'What snack?',
        deadline: 'Friday',
      );

      await pollService.addOption(pollId: poll.id, text: 'Pizza');
      await pollService.addOption(pollId: poll.id, text: 'Tacos');
      await pollService.addOption(pollId: poll.id, text: 'Sushi');

      expect(poll.options.length, 3);
      expect(poll.options[0].text, 'Pizza');
      expect(poll.options[1].text, 'Tacos');
      expect(poll.options[2].text, 'Sushi');
    });

    test('addOption throws exception for non-existent poll', () async {
      expect(
        () => pollService.addOption(pollId: 'nonexistent', text: 'Pizza'),
        throwsA(isA<Exception>()),
      );
    });

    test('getPoll returns the poll by id', () async {
      final createdPoll = await pollService.createPoll(
        question: 'Test question',
        deadline: 'Friday',
      );

      final retrievedPoll = pollService.getPoll(createdPoll.id);

      expect(retrievedPoll, isNotNull);
      expect(retrievedPoll!.id, createdPoll.id);
      expect(retrievedPoll.question, 'Test question');
    });

    test('getPoll returns null for non-existent poll', () {
      final poll = pollService.getPoll('nonexistent');
      expect(poll, isNull);
    });

    test('getAllPolls returns all created polls', () async {
      await pollService.createPoll(question: 'Q1', deadline: 'D1');
      await pollService.createPoll(question: 'Q2', deadline: 'D2');
      await pollService.createPoll(question: 'Q3', deadline: 'D3');

      final polls = pollService.getAllPolls();

      expect(polls.length, 3);
    });

    test('poll options have unique ids', () async {
      final poll = await pollService.createPoll(
        question: 'What snack?',
        deadline: 'Friday',
      );

      final opt1 = await pollService.addOption(pollId: poll.id, text: 'Pizza');
      final opt2 = await pollService.addOption(pollId: poll.id, text: 'Tacos');

      expect(opt1.id, isNot(equals(opt2.id)));
    });

    test('poll is stored in-app state', () async {
      final poll1 = await pollService.createPoll(
        question: 'Question 1',
        deadline: 'Friday',
      );
      await pollService.addOption(pollId: poll1.id, text: 'Option 1');

      // Create a second poll service instance
      final pollService2 = PollService();

      // New instance should have empty state (in-app storage)
      expect(pollService2.getAllPolls(), isEmpty);

      // Original instance should still have the poll
      expect(pollService.getAllPolls(), isNotEmpty);
      expect(pollService.getPoll(poll1.id), isNotNull);
    });
  });

  group('Poll model', () {
    test('Poll initializes with empty options if not provided', () {
      final poll = Poll(
        id: 'poll_1',
        question: 'Test?',
        deadline: 'Friday',
      );

      expect(poll.options, isEmpty);
      expect(poll.options, isA<List<PollOption>>());
    });

    test('Poll can be initialized with options', () {
      final options = [
        PollOption(id: 'opt_1', pollId: 'poll_1', text: 'Option 1'),
        PollOption(id: 'opt_2', pollId: 'poll_1', text: 'Option 2'),
      ];

      final poll = Poll(
        id: 'poll_1',
        question: 'Test?',
        deadline: 'Friday',
        options: options,
      );

      expect(poll.options.length, 2);
      expect(poll.options, equals(options));
    });
  });

  group('PollOption model', () {
    test('PollOption stores all required fields', () {
      final option = PollOption(
        id: 'opt_1',
        pollId: 'poll_1',
        text: 'Pizza',
      );

      expect(option.id, 'opt_1');
      expect(option.pollId, 'poll_1');
      expect(option.text, 'Pizza');
    });
  });
}
