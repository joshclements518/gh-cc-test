# PRD — Wellness Filter Chip on Explore

## Problem Statement
Guests browsing the Explore screen want a quick way to find wellness-related venues without having to filter by Spa or Fitness separately. Currently, they must select one category at a time, which means they can't see both wellness options together in a single view.

## Solution
Add a "Wellness" filter chip to the Explore screen's horizontal chip row that shows venues where the category is either Spa OR Fitness. The chip appears alongside existing category chips and uses the same single-select behavior — tapping Wellness deselects other chips and filters the venue list to show only Chart Room Spa and Fitness Studio from the mock catalog.

## User Stories
1. As a guest browsing Explore, I want to tap a Wellness chip, so that I can see all spa and fitness venues in one filtered list.
2. As a guest who has selected Wellness, I want to tap another category chip (or All), so that I can switch to a different filter.
3. As a guest viewing the Wellness-filtered list, I want to see the Wellness chip visually selected, so that I know which filter is active.
4. As a guest, I want the Wellness chip to appear in the chip row with the same visual style as other category chips, so that the interface feels consistent.

## Decisions made during the interview
- **Scope**: One story only — add the Wellness chip that filters MockCatalog.venues where category is "Spa" OR "Fitness".
- **Chip placement**: Wellness chip appears in the existing horizontal SingleChildScrollView chip row alongside All, Dining, Entertainment, Recreation, Spa, Fitness, Youth, Lounge, Services.
- **Filter behavior**: Single-select — tapping Wellness deselects other chips and shows only Spa OR Fitness venues. Tapping another chip deselects Wellness.
- **Visual treatment**: Same FilterChip widget and styling as existing category chips.
- **Venues matched**: Chart Room Spa (category: "Spa") and Fitness Studio (category: "Fitness") from MockCatalog.venues.
- **No grouping**: Matched venues appear in a single mixed list, no section headers by category.
- **Keep existing chips**: Spa and Fitness individual chips remain visible — Wellness is an additional shortcut, not a replacement.
- **Implementation constraint**: Changes must be in app/lib/** — specifically the filtering logic in ExploreScreen.

## How we'll know it works
1. Open the Explore screen and see a "Wellness" chip in the horizontal chip row.
2. Tap the Wellness chip — it becomes visually selected and the venue list shows exactly two venues: Chart Room Spa and Fitness Studio.
3. Tap the Spa chip — Wellness deselects, Spa selects, and the list shows only Chart Room Spa.
4. Tap Wellness again — the list shows both Chart Room Spa and Fitness Studio.
5. Tap All — Wellness deselects and all nine venues appear.
6. The Wellness chip has the same visual style (FilterChip widget) as other category chips.

## Out of Scope
- Additional combined filter chips (e.g., "Dining & Entertainment")
- Multi-select filtering (selecting multiple chips at once)
- Custom visual treatment or iconography for the Wellness chip
- Changes to venue data models or MockCatalog structure
- Real API integration — mock data only
- Story breakdown — this is a single-story epic
- Test-only changes — implementation must modify app/lib/**

## Further Notes
This epic is scoped as a single story for pipeline testing. The existing ExploreScreen already implements single-select category filtering by setting a `category` state variable and filtering `MockCatalog.venues.where((v) => v.category == category)`. The Wellness chip requires extending this logic to support an OR condition for two categories.

---

## Draft ADR candidates
1. **How is the Wellness filter represented in state?** The current implementation uses a nullable String `category` that matches a single venue category exactly. Wellness must match two categories. Should state hold a special sentinel value, a list of categories, or a filter predicate?

2. **How does the chip row determine which chip to render as selected?** Current logic checks `category == c` for each category chip and `category == null` for All. Wellness must be selected when a specific state condition is met that represents "Spa OR Fitness."

3. **Where does the Wellness chip appear in the chip row order?** Should it be positioned after All, at the end of the list, or in a specific position relative to Spa and Fitness?

## Proposed CONTEXT.md additions
- **Wellness**: A combined filter on Explore that matches venues in either the Spa or Fitness category. Introduced as a guest convenience shortcut.
- **Category (venue)**: A single-value classification field on Venue (e.g., "Spa", "Fitness", "Dining"). Used for single-select filtering on Explore.
- **MockCatalog**: Static sample data class providing venues, reservations, itinerary, and other demo content for the Harborline Navigator app.

## Codebase Orientation
- `app/lib/features/explore/explore_screen.dart` — Explore screen with search, category filter chips, spotlight carousel, and venue list; contains the single-select category filtering logic that must be extended
- `app/lib/data/mock_catalog.dart` — Static sample data including the venues list with Chart Room Spa (category: "Spa") and Fitness Studio (category: "Fitness")
- `app/lib/data/models.dart` — Venue model with id, name, deck, category, blurb, hours, tags fields
