import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// A toggle switch widget for filtering.
///
/// Displays an icon, label, and a switch control to activate/deactivate a filter.
/// Used for the wellness filter in the explore marketplace.
class FilterToggle extends StatelessWidget {
  const FilterToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onChanged,
  });

  /// The emoji or icon to display (e.g., '🏥' for wellness)
  final String icon;

  /// The label text (e.g., 'Wellness only')
  final String label;

  /// Whether the filter is currently active
  final bool isActive;

  /// Callback when the switch is toggled
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HlTokens.line),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeColor: HlTokens.sea,
          ),
        ],
      ),
    );
  }
}
