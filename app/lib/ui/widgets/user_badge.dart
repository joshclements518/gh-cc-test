import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';

/// User badge displaying current user's display name (ADR-1)
class UserBadge extends StatelessWidget {
  const UserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final userName = state.userName ?? 'Guest';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HlTokens.foam,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HlTokens.sea.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: HlTokens.sea,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            userName,
            style: const TextStyle(
              color: HlTokens.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
