import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/polls/poll_create_screen.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/data/models.dart';

class MockPollService extends PollService {
  Poll? lastCreatedPoll;
  bool shouldFail = false;
  String? failureMessage;

  @override
  Future<Poll> createPoll({
    required String question,
    required DateTime deadline,
  }) async {
    if (shouldFail) {
      throw Exception(failureMessage ?? 'Failed to create poll');
    }

    lastCreatedPoll = Poll(
      id: '12345',
      question: question,
      deadline: deadline,
    );
    return lastCreatedPoll!;
  }
}

void main() {
  group('PollCreateScreen', () {
    late MockPollService mockPollService;

    setUp(() {
      mockPollService = MockPollService();
    });

    testWidgets('renders form with question and deadline inputs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      expect(find.text('Create Poll'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Deadline'), findsOneWidget);
      expect(find.text('Create Poll'), findsNWidgets(2)); // AppBar + Button
    });

    testWidgets('validates required fields before submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Try to submit without filling fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter a question'), findsOneWidget);
    });

    testWidgets('calls POST /polls on successful submission',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Fill in question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we order?',
      );

      // Select deadline by tapping the deadline field
      await tester.tap(find.text('Tap to select deadline'));
      await tester.pumpAndSettle();

      // Select a date
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select a time
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Verify the poll was created
      expect(mockPollService.lastCreatedPoll, isNotNull);
      expect(
        mockPollService.lastCreatedPoll!.question,
        'What snack should we order?',
      );
    });

    testWidgets('displays new poll id after successful creation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Fill in question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we order?',
      );

      // Select deadline
      await tester.tap(find.text('Tap to select deadline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Should display the poll ID
      expect(find.text('Poll created successfully!'), findsOneWidget);
      expect(find.text('Poll ID: 12345'), findsOneWidget);
    });

    testWidgets('clears form after successful creation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Fill in question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we order?',
      );

      // Select deadline
      await tester.tap(find.text('Tap to select deadline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Form should be cleared
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller!.text, isEmpty);
      expect(find.text('Tap to select deadline'), findsOneWidget);
    });

    testWidgets('displays error message on API failure',
        (WidgetTester tester) async {
      mockPollService.shouldFail = true;
      mockPollService.failureMessage = 'Network error';

      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Fill in question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we order?',
      );

      // Select deadline
      await tester.tap(find.text('Tap to select deadline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Should display error message
      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('disables submit button while submitting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PollCreateScreen(pollService: mockPollService),
        ),
      );

      // Fill in question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we order?',
      );

      // Select deadline
      await tester.tap(find.text('Tap to select deadline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pump(); // Don't settle, to catch the loading state

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
