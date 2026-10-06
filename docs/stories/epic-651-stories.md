## 1. Add Wellness filter chip to Explore screen

One-sentence value: Guests can tap a Wellness chip on the Explore screen to see both Spa and Fitness venues in a single filtered list.

### Acceptance criteria

- The Explore screen displays a "Wellness" chip in the horizontal chip row between "All" and the category chips
- Tapping the Wellness chip sets it to selected state and filters the venue list to show exactly 2 venues: Chart Room Spa and Fitness Studio
- Tapping any other category chip (e.g., "Spa", "Dining") deselects the Wellness chip and applies that category's filter
- Tapping the "All" chip deselects the Wellness chip and shows all 9 venues
- The Wellness chip uses the same FilterChip widget and visual styling as existing category chips
- The filter logic in the `filtered` getter correctly handles the sentinel value `"Wellness"` by matching venues where `category == "Spa" OR category == "Fitness"`
- When Wellness is active, both Spa and Fitness venues appear in a single mixed list (no section headers)
- The existing individual Spa and Fitness chips remain visible and functional

### Architecture / UI bindings

- **Touches:** `app/lib/features/explore/explore_screen.dart` — Add Wellness FilterChip to chip row and extend filter logic to support OR condition
- **Depends on:** none
- **Architecture decisions:** Implements ADR-001 (sentinel value `"Wellness"` with conditional expansion in filter getter) and ADR-002 (chip selection logic `selected: category == "Wellness"`)
- **UI placement:** Wellness chip appears in the horizontal chip row after the "All" chip, before dynamically generated category chips
- **Visual treatment:** Uses existing FilterChip widget with same styling as other category chips
