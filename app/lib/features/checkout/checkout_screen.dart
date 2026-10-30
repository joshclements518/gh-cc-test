import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: HlTokens.card,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                const SectionLabel('Order Summary'),
                const SizedBox(height: 8),
                HlCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DisplayTitle('Total Breakdown'),
                      const SizedBox(height: 16),
                      _TotalRow('Subtotal', '\$1,299.00'),
                      const SizedBox(height: 8),
                      _TotalRow('Shipping', '\$25.00', highlight: true),
                      const SizedBox(height: 8),
                      _TotalRow('Tax', '\$106.43'),
                      const Divider(height: 24),
                      _TotalRow('Total', '\$1,430.43', bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionLabel('Payment'),
                const SizedBox(height: 8),
                HlCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: HlTokens.foam,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: HlTokens.line),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.credit_card, color: HlTokens.sea),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Visa ending in 4242',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Expires 12/2026',
                                    style: TextStyle(
                                      color: HlTokens.inkSoft,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HlTokens.sea,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Complete Purchase',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(this.label, this.amount, {this.bold = false, this.highlight = false});

  final String label;
  final String amount;
  final bool bold;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: highlight ? HlTokens.sea : HlTokens.ink,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: highlight ? HlTokens.sea : HlTokens.ink,
          ),
        ),
      ],
    );
  }
}
