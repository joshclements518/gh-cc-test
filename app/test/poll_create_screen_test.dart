import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/app.dart';
import 'package:harborline_navigator/features/polls/poll_create_screen.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  group('PollCreateScreen', () {
    testWidgets('displays form with question input and deadline picker', (tester) async {
      final state = AppState(HarborlineServices());
      await state.signIn();

      await tester.pumpWidget(
        MaterialApp(
          home: HarborlineApp(state: state),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to poll creation screen
      await tester.push((_) => const PollCreateScreen());
      await tester.pumpAndSettle();

      expect(find.text('Create Poll'), findsOneWidget);
      expect(find.text('NEW POLL'), findsOneWidget);
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Deadline'), findsOneWidget);
      expect(find.text('Create Poll'), findsAtLeastNWidgets(1));
    });

    testWidgets('validates question input is required', (tester) async {
      final state = AppState(HarborlineServices());
      await state.signIn();

      await tester.pumpWidget(
        MaterialApp(
          home: HarborlineApp(state: state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.push((_) => const PollCreateScreen());
      await tester.pumpAndSettle();

      // Try to submit without entering question
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a question'), findsOneWidget);
    });

    testWidgets('submits poll and displays success with poll ID', (tester) async {
      final state = AppState(HarborlineServices());
      await state.signIn();

      await tester.pumpWidget(
        MaterialApp(
          home: HarborlineApp(state: state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.push((_) => const PollCreateScreen());
      await tester.pumpAndSettle();

      // Enter question
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'What snack should we get this Friday?',
      );
      await tester.pumpAndSettle();

      // Open date picker
      await tester.tap(find.text('Select a date'));
      await tester.pumpAndSettle();

      // Select a date (the OK button in the date picker)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Verify success screen
      expect(find.text('Poll Created'), findsOneWidget);
      expect(find.text('SUCCESS'), findsOneWidget);
      expect(find.text('Poll ID:'), findsOneWidget);
      expect(find.textContaining('poll-'), findsOneWidget);
      expect(find.text('Question:'), findsOneWidget);
      expect(find.text('What snack should we get this Friday?'), findsOneWidget);
      expect(find.text('Status:'), findsOneWidget);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('can create another poll after success', (tester) async {
      final state = AppState(HarborlineServices());
      await state.signIn();

      await tester.pumpWidget(
        MaterialApp(
          home: HarborlineApp(state: state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.push((_) => const PollCreateScreen());
      await tester.pumpAndSettle();

      // Create first poll
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'First poll question',
      );
      await tester.tap(find.text('Select a date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Verify success
      expect(find.text('Poll Created'), findsOneWidget);

      // Click "Create Another Poll"
      await tester.tap(find.text('Create Another Poll'));
      await tester.pumpAndSettle();

      // Should be back to form
      expect(find.text('NEW POLL'), findsOneWidget);
      expect(find.text('Select a date'), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> push(WidgetBuilder builder) async {
    final context = element(find.byType(Scaffold).first);
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }
}
