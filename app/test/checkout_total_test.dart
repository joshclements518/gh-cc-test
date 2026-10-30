import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/checkout/checkout_screen.dart';

void main() {
  group('checkout-total', () {
    testWidgets('checkout shows shipping before payment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CheckoutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify checkout screen renders
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Total Breakdown'), findsOneWidget);

      // Verify shipping is shown in the totals
      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text('\$25.00'), findsOneWidget);

      // Verify payment section appears after totals
      expect(find.text('Payment'), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Complete Purchase'), findsOneWidget);

      // Verify the order of elements: shipping appears before payment section
      final shippingFinder = find.text('Shipping');
      final paymentFinder = find.text('Payment Method');

      expect(shippingFinder, findsOneWidget);
      expect(paymentFinder, findsOneWidget);

      // Get positions to verify shipping is rendered above payment
      final shippingPosition = tester.getTopLeft(shippingFinder);
      final paymentPosition = tester.getTopLeft(paymentFinder);

      expect(shippingPosition.dy < paymentPosition.dy, true,
          reason: 'Shipping should appear before payment section');
    });

    testWidgets('checkout displays all total components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CheckoutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all total components are present
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text('Tax'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);

      // Verify amounts
      expect(find.text('\$1,299.00'), findsOneWidget);
      expect(find.text('\$25.00'), findsOneWidget);
      expect(find.text('\$106.43'), findsOneWidget);
      expect(find.text('\$1,430.43'), findsOneWidget);
    });

    testWidgets('complete purchase button triggers success message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CheckoutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the complete purchase button
      await tester.tap(find.text('Complete Purchase'));
      await tester.pumpAndSettle();

      // Verify success message appears
      expect(find.text('Order placed successfully!'), findsOneWidget);
    });
  });
}
