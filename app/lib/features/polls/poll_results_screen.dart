import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class PollResultsScreen extends StatelessWidget {
  const PollResultsScreen({super.key, required this.poll});
  final Poll poll;

  @override
  Widget build(BuildContext context) {
    final winner = poll.winningOption;
    final totalVotes = poll.totalVotes;

    return Scaffold(
      appBar: AppBar(title: Text(poll.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (winner != null) ...[
            HlCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('Winner'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [HlTokens.sea, HlTokens.seaDeep],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          winner.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${winner.voteCount} votes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel('All Results'),
                    Text(
                      '$totalVotes total votes',
                      style: const TextStyle(
                        color: HlTokens.inkSoft,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...poll.options.map((option) {
                  final percentage = totalVotes > 0
                      ? (option.voteCount / totalVotes * 100)
                      : 0.0;
                  final isWinner = option.id == winner?.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: TextStyle(
                                  fontWeight: isWinner
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              '${option.voteCount} votes',
                              style: const TextStyle(
                                color: HlTokens.inkSoft,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            minHeight: 8,
                            backgroundColor: HlTokens.foam,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isWinner ? HlTokens.seaDeep : HlTokens.sea,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: HlTokens.inkSoft,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Poll Info'),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Status',
                  value: poll.isActive ? 'Active' : 'Closed',
                  valueColor: poll.isActive ? HlTokens.sea : HlTokens.inkSoft,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Share Token',
                  value: poll.shareToken,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: HlTokens.inkSoft,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? HlTokens.ink,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
