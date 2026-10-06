# Sequence — Wellness Filter Selection Flow

```mermaid
sequenceDiagram
    actor Guest
    participant WellnessChip as Wellness FilterChip
    participant ExploreScreen as ExploreScreen State
    participant FilterGetter as filtered getter
    participant MockCatalog
    participant VenueList as Venue List UI
    
    Guest->>WellnessChip: Tap Wellness chip
    
    rect rgb(227,244,236)
        Note over WellnessChip,ExploreScreen: New flow — added
        WellnessChip->>ExploreScreen: onSelected callback
        ExploreScreen->>ExploreScreen: setState(category = "Wellness")
        Note over ExploreScreen: Uses sentinel value (ADR-001)
    end
    
    ExploreScreen->>FilterGetter: Rebuild triggers filtered getter
    FilterGetter->>MockCatalog: Read venues list
    
    rect rgb(227,244,236)
        Note over FilterGetter: Modified filter logic
        FilterGetter->>FilterGetter: Check if Wellness active
        FilterGetter->>FilterGetter: Match v.category == "Spa" OR "Fitness"
    end
    
    FilterGetter-->>VenueList: Return 2 venues (Chart Room Spa, Fitness Studio)
    VenueList->>Guest: Display filtered list
    
    Guest->>WellnessChip: Verify chip shows selected state
    WellnessChip-->>Guest: Visual selection indicator
```

## Flow Notes

- **Current behavior**: Tapping any category chip sets `category = <categoryName>` and the filter checks `v.category == category`
- **Wellness behavior**: Tapping Wellness sets `category = "Wellness"` (sentinel value per ADR-001), and the filter getter expands this to match both "Spa" and "Fitness" categories
- **Chip selection visual**: The `selected` prop on FilterChip uses `selected: category == "Wellness"` (per ADR-002)
- **Deselection**: Tapping another chip (e.g., "Dining" or "All") changes `category` to a different value, automatically deselecting Wellness

## Implementation Details

The Wellness chip is added to the horizontal chip row with the following structure:

```dart
FilterChip(
  label: const Text('Wellness'),
  selected: category == "Wellness",
  onSelected: (_) => setState(() => category = "Wellness"),
)
```

The filter getter in `ExploreScreen` is modified to detect the sentinel:

```dart
final matchesC = category == null || 
                 (category == "Wellness" ? (v.category == "Spa" || v.category == "Fitness") : v.category == category);
```

See ADR-001 and ADR-002 for architectural rationale.
