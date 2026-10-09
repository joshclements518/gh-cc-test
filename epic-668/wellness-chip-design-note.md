# Wellness Chip UI Design

## Design Decision

This epic reuses the existing UI patterns from the Explore screen:

- **Chip style**: Follow the existing FilterChip design used for "All" and category chips
- **Chip label**: "Wellness"
- **Chip position**: Immediately after the "All" chip in the horizontal chip row
- **Venue cards**: Use existing venue card layout with individual category labels ("Fitness" or "Spa")
- **Filter behavior**: Match existing chip selection behavior (single selection, visual state change)

No new UI components or visual designs are required. The implementation should follow the existing patterns in `explore_screen.dart`.
