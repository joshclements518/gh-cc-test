## 1. Add Explore Wellness chip (Spa OR Fitness) filtering MockCatalog.venues

Guests can tap a Wellness chip on the Explore screen to see both spa and fitness venues together in one filtered view, without switching between individual category chips.

### Acceptance criteria
- Wellness FilterChip appears in the horizontal chip row on Explore screen (positioned after All chip, before dynamic category chips)
- Tapping Wellness chip sets selected state visually (matching other FilterChip selected styling)
- When Wellness is selected, venue list displays exactly two venues: Chart Room Spa and Fitness Studio
- Tapping any other category chip (Spa, Fitness, Dining, etc.) deselects Wellness and applies that category filter
- Tapping All chip deselects Wellness and shows all nine venues
- Tapping Wellness when another chip is selected deselects the other chip and applies Wellness filter
- Filter logic in `filtered` getter detects `category == "Wellness"` and matches venues where `v.category == "Spa" || v.category == "Fitness"`
- No changes to MockCatalog venue data or Venue model
- Implementation changes only files under `app/lib/**`

### Architecture / UI bindings
- Touches: `app/lib/features/explore/explore_screen.dart` (filter chip row UI and filtered getter logic)
- Depends on: none
- Implements ADR-001: Wellness Filter as UI-Only Shortcut
- Follows existing single-select FilterChip pattern (selected property + onSelected callback)
- Aligns with PRD user stories 1-4 and "How we'll know it works" acceptance steps 1-7
