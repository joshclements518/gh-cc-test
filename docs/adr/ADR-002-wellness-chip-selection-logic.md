# ADR-002: Wellness Chip Selection Logic

**Status**: Accepted  
**Date**: 2025-01-27  
**Context**: Epic 651 — Wellness filter chip on Explore

## Context

The ExploreScreen renders a horizontal row of FilterChip widgets. Each chip's `selected` property determines its visual state (highlighted when active). Current logic:

- **All chip**: `selected: category == null`
- **Category chips** (Dining, Spa, Fitness, etc.): `selected: category == c` where `c` is the category string

From code inspection (`app/lib/features/explore/explore_screen.dart`):
```dart
FilterChip(
  label: const Text('All'),
  selected: category == null,
  onSelected: (_) => setState(() => category = null),
),
...cats.map((c) => FilterChip(
  label: Text(c),
  selected: category == c,
  onSelected: (_) => setState(() => category = c),
))
```

The Wellness chip must show as selected when the Wellness filter is active, and deselect when any other chip is tapped.

## Decision

**The Wellness chip uses `selected: category == "Wellness"`** (assuming ADR-001's sentinel value approach).

The chip's `onSelected` callback sets `category = "Wellness"`:

```dart
FilterChip(
  label: const Text('Wellness'),
  selected: category == "Wellness",
  onSelected: (_) => setState(() => category = "Wellness"),
)
```

This maintains consistency with existing category chips: each chip checks if the state variable equals its identifier.

### Alternatives Considered

1. **Separate boolean flag**: `selected: isWellnessActive`. Rejected because it requires parallel state management and complicates deselection (must clear the flag when other chips are tapped).

2. **Check for set membership**: `selected: category != null && {"Spa", "Fitness"}.contains(category)`. Rejected because it would incorrectly show Wellness as selected when the user taps the individual Spa or Fitness chips.

3. **Enum-based state**: Replace `String? category` with an enum `FilterMode { all, wellness, category(String name) }`. Cleaner type safety, but requires broader refactoring beyond this epic's scope.

## Consequences

### Positive
- Consistent with existing chip selection pattern
- Single source of truth: the `category` state variable
- Tapping any other chip automatically deselects Wellness (because `category` changes to a different value)

### Negative
- Tightly couples chip selection to the sentinel string value from ADR-001
- If ADR-001 is superseded (e.g., moving to `Set<String>` state), this logic must also change

### Future Considerations

If the state model evolves to support multi-select filtering (e.g., "show Spa AND Fitness venues together with Dining"), the `selected` logic will need to check set membership rather than equality. At that point, both ADR-001 and ADR-002 would be superseded by a new ADR introducing a richer state model.

## Supersedes

None.

## Related

- ADR-001: Wellness Filter State Representation (defines the sentinel value this logic depends on)
- See `docs/architecture/sequences/wellness-filter-flow.md` for the full interaction flow
