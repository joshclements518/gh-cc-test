# ADR-1: Wellness Chip Representation

## Status
Accepted

## Context
The Harborline Explore application needs a way to filter venues by wellness-related categories. Currently, users can filter by individual venue categories (Dining, Entertainment, Recreation, Spa, Fitness, Youth, Lounge, Services), but there's no grouped filter for wellness activities.

## Decision
We will implement a "Wellness" filter chip that groups together Spa and Fitness venue categories. This provides users with a convenient way to find health and wellness options aboard the ship.

### UI Representation
- The Wellness chip will appear in the horizontal filter chip row alongside existing category chips
- Label: "Wellness"
- When selected, it will filter venues to show only those with category "Spa" or "Fitness"
- The chip will use Flutter's standard `FilterChip` widget for visual consistency

### Implementation Details
- The filter logic will be implemented in `_ExploreScreenState` within `app/lib/features/explore/explore_screen.dart`
- A new state variable `isWellnessFilter` will track when the Wellness chip is active
- The existing `filtered` getter will be updated to handle this multi-category filter
- The Wellness chip will be inserted after the "All" chip and before individual category chips

## Consequences

### Positive
- Users can quickly find all wellness-related venues without switching between Spa and Fitness filters
- The implementation reuses existing UI patterns and requires no new dependencies
- The grouped filter concept can be extended to other logical groupings in the future (e.g., "Dining", "Entertainment")

### Negative
- Adds slight complexity to the filtering logic
- Users might expect other logical groupings that aren't yet implemented

## Alternatives Considered
1. **Add Wellness as a new venue category**: Would require changing the data model and wouldn't group existing Spa/Fitness venues
2. **Multi-select chips**: Would allow selecting multiple categories at once but adds UI complexity
3. **Dropdown with grouped options**: More complex UI pattern that doesn't match the existing design
