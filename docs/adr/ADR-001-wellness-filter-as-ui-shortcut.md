# ADR-001: Wellness Filter as UI-Only Shortcut

**Status:** Accepted

**Context:**

The Explore screen currently generates filter chips dynamically from venue categories in `MockCatalog.venues`. Guests want a combined Wellness filter that shows both Spa and Fitness venues without having to switch between individual category chips.

The PRD specifies that Wellness is a UI convenience filter, not a new venue category. Chart Room Spa remains `category: "Spa"` and Fitness Studio remains `category: "Fitness"` in the data model.

We must decide how to integrate the Wellness chip into the existing single-select filter chip architecture without altering the venue data model or creating backend dependencies.

**Decision:**

Implement Wellness as a **hardcoded UI-only filter chip** in the `ExploreScreen` widget, positioned in the chip row alongside the "All" chip and before the dynamically-generated category chips.

When selected, the Wellness chip sets `category = "Wellness"` in `ExploreScreenState`. The `filtered` getter will detect this special value and apply an OR condition: match venues where `v.category == "Spa" || v.category == "Fitness"`.

**Implementation approach:**
- Add Wellness FilterChip explicitly in the chip row build logic (after All, before dynamic category chips)
- Enhance the `filtered` getter to recognize `category == "Wellness"` and apply the OR filter
- No changes to `MockCatalog`, `Venue` model, or venue category values
- Single-select behavior preserved via existing FilterChip `selected` and `onSelected` properties

**Consequences:**

**Positive:**
- Clean separation: Wellness is a UI concern, not a data model concern
- No migration or data changes required
- Easy to extend with additional multi-category shortcuts in the future (e.g., "Dining & Entertainment")
- Filter logic remains in the presentation layer where it belongs
- Existing category chips and All chip continue to work unchanged

**Negative:**
- Wellness chip is hardcoded rather than data-driven, creating a special case in the UI
- If we add more multi-category shortcuts, each must be explicitly coded
- Filter logic in `filtered` getter gains conditional branching for special filter values

**Alternatives Considered:**

1. **Add "Wellness" to venue categories in MockCatalog:** Rejected because it would require duplicating Chart Room Spa and Fitness Studio with a new category value, breaking the single-category-per-venue model and inflating the catalog.

2. **Introduce a multi-select filter system:** Rejected as out of scope per PRD; would require significant architectural changes to support multiple active filters simultaneously.

3. **Create a separate "shortcuts" data structure:** Rejected as over-engineering for a single shortcut; adds complexity without clear benefit for this thin epic.

**Supersedes:** None (initial ADR for this epic)
