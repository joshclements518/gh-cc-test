import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../data/mock_catalog.dart';

class HlCard extends StatelessWidget {
  const HlCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: HlTokens.card,
        borderRadius: BorderRadius.circular(HlTokens.radiusCard),
        border: Border.all(color: HlTokens.line),
        boxShadow: [
          BoxShadow(
            color: HlTokens.ink.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.08 * 16,
        color: HlTokens.sea,
      ),
    );
  }
}

class DisplayTitle extends StatelessWidget {
  const DisplayTitle(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color ?? HlTokens.ink,
        height: 1.2,
        letterSpacing: -0.3,
      ),
    );
  }
}

class SoftChip extends StatelessWidget {
  const SoftChip(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HlTokens.foam,
        borderRadius: BorderRadius.circular(HlTokens.radiusChip),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: HlTokens.seaDeep,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class HarnessWalkCard extends StatelessWidget {
  const HarnessWalkCard({super.key, required this.walk, this.onTap});
  final HarnessWalk walk;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return HlCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HlTokens.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    walk.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: HlTokens.ink,
                    ),
                  ),
                ),
                _DifficultyBadge(walk.difficulty),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              walk.description,
              style: const TextStyle(
                fontSize: 14,
                color: HlTokens.inkSoft,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: HlTokens.inkSoft),
                const SizedBox(width: 4),
                Text(
                  '${walk.durationMinutes} min',
                  style: const TextStyle(
                    fontSize: 13,
                    color: HlTokens.inkSoft,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: HlTokens.inkSoft),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    walk.startLocation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: HlTokens.inkSoft,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge(this.difficulty);
  final WalkDifficulty difficulty;
  
  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      WalkDifficulty.easy => HlTokens.sea,
      WalkDifficulty.moderate => Colors.orange,
      WalkDifficulty.challenging => Colors.red,
    };
    
    final label = switch (difficulty) {
      WalkDifficulty.easy => 'Easy',
      WalkDifficulty.moderate => 'Moderate',
      WalkDifficulty.challenging => 'Challenging',
    };
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(HlTokens.radiusChip),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
