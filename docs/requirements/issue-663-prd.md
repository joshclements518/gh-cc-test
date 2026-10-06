# PRD — Wellness Filter Chip on Explore

## Problem Statement
Guests browsing the Explore screen want a quick way to find wellness-related venues without having to filter by Spa or Fitness separately. Currently, they must select one category at a time, which means they can't see both wellness options together in a single view.

## Solution
Add a "Wellness" filter chip to the Explore screen that shows venues whose category is either Spa OR Fitness. The chip appears alongside existing category chips (All, Dining, Entertainment, Fitness, Lounge, Recreation, Services, Spa, Youth) and follows the same single-select behavior—when selected, it filters the venue list to show only Chart Room Spa and Fitness Studio from the mock catalog.

## User Stories
1. As a guest browsing Explore, I want to tap a Wellness chip, so that I see all spa and fitness venues together without switching filters.
2. As a guest who selected Wellness, I want to see both Chart Room Spa and Fitness Studio in the filtered venue list, so that I can compare wellness options side-by-side.
3. As a guest, I want the Wellness chip to behave like other category chips (single-select, visual selection state), so that the filtering experience is consistent.
4. As a guest, I want to still be able to select individual Spa or Fitness chips if I want to narrow to just one category, so that I retain fine-grained control.

## Decisions made during the interview
- Wellness chip is added to the existing horizontal chip row; existing category chips (including Spa and Fitness) remain unchanged.
- Single-select behavior: selecting Wellness deselects any other category chip; selecting another category deselects Wellness.
- Wellness matches venues where `category == 'Spa' || category == 'Fitness'`.
- No changes to mock catalog data—Chart Room Spa (category: Spa) and Fitness Studio (category: Fitness) are the two venues that will appear when Wellness is selected.
- Implementation changes only `app/lib/**`; no test-only changes, no new greenfield app.

## How we'll know it works
1. Open the app and navigate to the Explore tab.
2. Scroll horizontally through the filter chips—Wellness appears in the row alongside All, Dining, Entertainment, Fitness, Lounge, Recreation, Services, Spa, Youth.
3. Tap the Wellness chip—it shows a selected state (visual highlight matching other selected chips).
4. The venue list below filters to show exactly two venues: Chart Room Spa and Fitness Studio.
5. Tap the Spa chip—Wellness deselects, Spa selects, and only Chart Room Spa appears in the venue list.
6. Tap Wellness again—Spa deselects, Wellness selects, and both Chart Room Spa and Fitness Studio reappear.
7. Tap All—Wellness deselects, and all nine venues from the mock catalog appear.

## Out of Scope
- Modifying the mock catalog to add new wellness venues or change existing venue categories.
- Multi-select filtering (e.g., selecting both Wellness and Dining at the same time).
- Changing the visual design or layout of the chip row beyond adding one more chip.
- Adding Wellness as a real venue category in the data model—it remains a UI-only filter shortcut.
- Real API integration or backend changes.
- Creating a new greenfield app, test-only changes, or non-Flutter deliverables.

## Further Notes
This is a single-story epic focused on a small UI enhancement to the existing Explore feature. The Wellness chip is a convenience filter that combines two existing categories without altering the underlying data model or the behavior of other chips.

---

## Draft ADR Candidates
None. This is a straightforward UI filter addition with no architectural decisions requiring ADR documentation. The filtering logic is a simple OR condition on an existing field.

---

## Proposed CONTEXT.md Additions
**Wellness (Explore filter):** A UI-only filter chip on the Explore screen that matches venues whose category is Spa OR Fitness. Not a venue category itself—Chart Room Spa remains category Spa, Fitness Studio remains category Fitness.

---

## Codebase Orientation
- `app/lib/features/explore/explore_screen.dart` — Explore tab UI; contains the filter chip row and venue filtering logic
- `app/lib/data/mock_catalog.dart` — Sample venue data; includes Chart Room Spa (category: Spa) and Fitness Studio (category: Fitness)
- `app/lib/data/models.dart` — Venue model definition with category field
