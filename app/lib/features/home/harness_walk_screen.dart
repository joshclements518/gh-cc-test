import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class HarnessWalkScreen extends StatelessWidget {
  const HarnessWalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final article = MockCatalog.harnessWalk;
    return Scaffold(
      appBar: AppBar(title: const Text('Harness Walk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Adventure Activity'),
                const SizedBox(height: 10),
                DisplayTitle(article.title),
                const SizedBox(height: 12),
                Text(
                  article.body,
                  style: const TextStyle(height: 1.5, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    SoftChip('Deck 14'),
                    SoftChip('Safety'),
                    SoftChip('Guided'),
                  ],
                ),
              ],
            ),
          ),
          const SectionLabel('Tour Details'),
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _DetailRow(
                  icon: Icons.schedule,
                  label: 'Duration',
                  value: '45 minutes',
                ),
                SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Meeting Point',
                  value: 'Deck 14 Forward · Sky Deck',
                ),
                SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.people_outline,
                  label: 'Group Size',
                  value: 'Maximum 8 guests',
                ),
              ],
            ),
          ),
          const SectionLabel('What to Expect'),
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '• Safety harness fitting and instruction\n'
                  '• Guided walk along outer deck rails\n'
                  '• Learn about maritime safety protocols\n'
                  '• Photo opportunities with ocean views\n'
                  '• Equipment provided by crew',
                  style: TextStyle(height: 1.6, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HlTokens.sea,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Reserve Your Spot',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: HlTokens.foam,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: HlTokens.sea, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: HlTokens.inkSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
