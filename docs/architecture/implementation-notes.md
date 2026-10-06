# Implementation Notes — Wellness Filter Chip

## Architecture Summary

The Wellness filter chip is a UI-only shortcut that combines Spa and Fitness categories without modifying the underlying venue data model. It integrates into the existing single-select filter chip row on the Explore screen.

## Key Architectural Constraints

1. **No data model changes:** Venue category field remains unchanged; Chart Room Spa stays `category: "Spa"`, Fitness Studio stays `category: "Fitness"`

2. **UI-layer implementation only:** Changes confined to `app/lib/features/explore/explore_screen.dart`

3. **Single-select behavior preserved:** Selecting Wellness deselects other chips; selecting any other chip deselects Wellness

4. **No new services or backends:** Uses existing MockCatalog and Venue model

## Implementation Scope

### Modified Files
- `app/lib/features/explore/explore_screen.dart`
  - Add Wellness FilterChip to chip row (after All, before dynamic category chips)
  - Enhance `filtered` getter to recognize `category == "Wellness"` and apply OR condition

### Unchanged Files
- `app/lib/data/models.dart` — Venue model unchanged
- `app/lib/data/mock_catalog.dart` — Venue data unchanged
- All other feature modules unchanged

## Filter Logic Enhancement

**Current logic (line 18-23 in explore_screen.dart):**
```dart
List<Venue> get filtered {
  return MockCatalog.venues.where((v) {
    final q = query.trim().toLowerCase();
    final matchesQ = q.isEmpty || v.name.toLowerCase().contains(q) || v.tags.any((t) => t.contains(q));
    final matchesC = category == null || v.category == category;
    return matchesQ && matchesC;
  }).toList();
}
```

**Enhanced logic (pseudo-code):**
```dart
final matchesC = category == null 
    || (category == 'Wellness' && (v.category == 'Spa' || v.category == 'Fitness'))
    || v.category == category;
```

## Chip Row Structure

**Current structure:**
```
[All] [Dining] [Entertainment] [Fitness] [Lounge] [Recreation] [Services] [Spa] [Youth]
```

**New structure:**
```
[All] [Wellness] [Dining] [Entertainment] [Fitness] [Lounge] [Recreation] [Services] [Spa] [Youth]
```

## Expected Behavior

| User Action | category State | Filtered Venues |
|-------------|---------------|-----------------|
| App opens | `null` | All 9 venues |
| Tap Wellness | `"Wellness"` | Chart Room Spa, Fitness Studio (2 venues) |
| Tap Spa | `"Spa"` | Chart Room Spa (1 venue) |
| Tap Fitness | `"Fitness"` | Fitness Studio (1 venue) |
| Tap All | `null` | All 9 venues |
| Tap Dining | `"Dining"` | Coral Room, Harbor Grill (2 venues) |

## Testing Verification Points

1. Wellness chip appears in the horizontal chip row
2. Tapping Wellness shows selected state (visual highlight)
3. Venue list filters to exactly 2 venues: Chart Room Spa and Fitness Studio
4. Tapping any other category chip deselects Wellness
5. Tapping Wellness deselects any previously selected category chip
6. Search query continues to work in combination with Wellness filter
7. All existing category chips continue to function unchanged

## Future Extension Pattern

If additional multi-category shortcuts are needed (e.g., "Nightlife" = Lounge + Entertainment), follow the same pattern:
1. Add hardcoded FilterChip to chip row
2. Extend `filtered` getter with new conditional branch
3. No data model changes required

This pattern scales to a small number of shortcuts. If many shortcuts are needed, consider refactoring to a data-driven shortcut configuration structure.
