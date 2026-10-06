# ADR-001: Wellness Filter State Representation

**Status**: Accepted  
**Date**: 2025-01-27  
**Context**: Epic 651 — Wellness filter chip on Explore

## Context

The ExploreScreen currently uses a nullable `String? category` state variable to represent the active filter. When `category == null`, all venues are shown ("All" chip selected). When `category` holds a string like `"Spa"` or `"Dining"`, the filter getter performs exact matching: `v.category == category`.

The Wellness filter must match venues where `category == "Spa" OR category == "Fitness"`. The current state model cannot represent this OR condition as a single string value without introducing special-case logic.

From code inspection (`app/lib/features/explore/explore_screen.dart`):
```dart
String? category;

List<Venue> get filtered {
  return MockCatalog.venues.where((v) {
    final matchesC = category == null || v.category == category;
    return matchesQ && matchesC;
  }).toList();
}
```

## Decision

**Recommendation: Use a sentinel string value `"Wellness"` with conditional expansion in the filter logic.**

Modify the `filtered` getter to detect the sentinel and expand it to an OR condition:

```dart
final matchesC = category == null || 
                 (category == "Wellness" ? (v.category == "Spa" || v.category == "Fitness") : v.category == category);
```

The Wellness chip sets `category = "Wellness"` on tap, and its `selected` prop checks `category == "Wellness"`.

### Alternatives Considered

1. **Change state type to `Set<String>?`**: Cleanest data model (a filter is a set of allowed categories), but requires refactoring all chip `onSelected` callbacks and the "All" chip logic (empty set vs null). Broader scope than this single-story epic.

2. **Add parallel `bool isWellnessActive` flag**: Avoids coupling UI labels to filter logic, but introduces dual state (category + flag) and complicates chip selection (must clear flag when other chips are tapped). Increases state complexity.

3. **Use a filter predicate `bool Function(Venue)?`**: Most flexible, but over-engineered for a single OR condition. Future combined filters (e.g., "Dining & Entertainment") would still require predicate composition logic.

## Consequences

### Positive
- Minimal code change: one conditional in the filter getter, one new chip in the row
- Preserves existing `String?` state contract
- Chip selection logic remains simple: `selected: category == "Wellness"`
- No refactoring of existing category chips

### Negative
- Couples the UI label "Wellness" to filter logic (the string `"Wellness"` has special meaning in the filter getter)
- Does not generalize to arbitrary combined filters without adding more sentinel strings
- If "Wellness" were ever added as a real venue category in MockCatalog, it would conflict

### Mitigation
- Document the sentinel in a comment above the filter getter
- If future epics require multiple combined filters, revisit this decision and refactor to a more general model (e.g., ADR-001 would be superseded by a new ADR introducing `Set<String>` or filter predicates)

## Supersedes

None (first ADR for this codebase).

## Related

- See `docs/architecture/data-model.md` for state schema
- See `docs/architecture/sequences/wellness-filter-flow.md` for interaction flow
