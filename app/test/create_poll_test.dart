import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/polls/create_poll_screen.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  group('CreatePollScreen', () {
    late AppState state;

    setUp(() {
      state = AppState(HarborlineServices());
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: AppScope(
          state: state,
          child: const CreatePollScreen(),
        ),
      );
    }

    testWidgets('displays form with question and deadline inputs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create Poll'), findsOneWidget);
      expect(find.text('Poll Question'), findsOneWidget);
      expect(find.text('Deadline'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Select deadline date'), findsOneWidget);
      expect(find.text('Create Poll'), findsNWidgets(2)); // AppBar + Button
    });

    testWidgets('validates empty question', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to submit with empty question
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      expect(find.text('Question cannot be empty'), findsOneWidget);
    });

    testWidgets('shows error when deadline is not selected', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter question but no deadline
      await tester.enterText(find.byType(TextFormField), 'What snack?');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      expect(find.text('Please select a deadline'), findsOneWidget);
    });

    testWidgets('successfully creates poll with valid inputs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack for Friday?',
      );

      // Select deadline
      await tester.tap(find.text('Select deadline date'));
      await tester.pumpAndSettle();

      // Pick a future date (tomorrow)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text(tomorrow.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Check for success message
      expect(find.textContaining('Poll created successfully!'), findsOneWidget);
      expect(find.textContaining('ID: poll_'), findsOneWidget);

      // Verify form is reset
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('shows loading indicator while submitting', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter valid data
      await tester.enterText(find.byType(TextFormField), 'Test question');

      // Select deadline
      await tester.tap(find.text('Select deadline date'));
      await tester.pumpAndSettle();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text(tomorrow.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Start submission
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pump();

      // Check for loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables submit button while loading', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter valid data
      await tester.enterText(find.byType(TextFormField), 'Test question');

      // Select deadline
      await tester.tap(find.text('Select deadline date'));
      await tester.pumpAndSettle();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text(tomorrow.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Start submission
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pump();

      // Button should be disabled
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create Poll'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('question input accepts text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const testQuestion = 'What snack should we order?';
      await tester.enterText(find.byType(TextFormField), testQuestion);
      await tester.pump();

      expect(find.text(testQuestion), findsOneWidget);
    });

    testWidgets('deadline picker shows calendar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap deadline selector
      await tester.tap(find.text('Select deadline date'));
      await tester.pumpAndSettle();

      // Calendar should appear
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    testWidgets('clears error message on new submission', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First submission without deadline
      await tester.enterText(find.byType(TextFormField), 'Test question');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      expect(find.text('Please select a deadline'), findsOneWidget);

      // Now select deadline and submit again
      await tester.tap(find.text('Select deadline date'));
      await tester.pumpAndSettle();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text(tomorrow.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Error should be cleared
      expect(find.text('Please select a deadline'), findsNothing);
      expect(find.textContaining('Poll created successfully!'), findsOneWidget);
    });
  });
}
