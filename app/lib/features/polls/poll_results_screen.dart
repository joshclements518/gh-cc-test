import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class PollResultsScreen extends StatelessWidget {
  const PollResultsScreen({super.key, required this.pollId});
  
  final String pollId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final result = state.services.polls.getPollResult(pollId);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Poll Results'),
          backgroundColor: HlTokens.sea,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Poll not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poll Results'),
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ResultsHero(result: result),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                const SectionLabel('All options'),
                const SizedBox(height: 8),
                ..._buildOptionsList(result),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptionsList(PollResult result) {
    final widgets = <Widget>[];
    
    for (final option in result.poll.options) {
      final percentage = result.totalVotes > 0
          ? (option.voteCount / result.totalVotes * 100).toStringAsFixed(1)
          : '0.0';
      
      final isWinner = option.id == result.winningOption.id;
      
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: HlCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            option.name,
                            style: TextStyle(
                              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (isWinner) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: HlTokens.gold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'WINNER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: result.totalVotes > 0 ? option.voteCount / result.totalVotes : 0,
                          backgroundColor: HlTokens.line,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isWinner ? HlTokens.gold : HlTokens.sea,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${option.voteCount}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: HlTokens.inkSoft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return widgets;
  }
}

class _ResultsHero extends StatelessWidget {
  const _ResultsHero({required this.result});
  
  final PollResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, MediaQuery.paddingOf(context).top + 18, 22, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4AF37), Color(0xFFC5A028), Color(0xFFB8941F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Poll Ended',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            result.poll.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Winning Option',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            result.winningOption.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCell(
                  '${result.totalVotes}',
                  'TOTAL VOTES',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCell(
                  '${result.winningOption.voteCount}',
                  'WINNER VOTES',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCell(
                  '${result.poll.options.length}',
                  'OPTIONS',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell(this.value, this.label);
  
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 10,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
