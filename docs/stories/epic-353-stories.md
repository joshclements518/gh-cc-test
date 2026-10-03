## 1. Add Wellness Filter Chip
Implement a Wellness filter chip in the Harborline Explore application that allows users to filter venues categorized as Spa or Fitness.

### Acceptance criteria
- Users can see the Wellness chip alongside existing category chips.
- Selecting the Wellness chip filters the displayed venues to only show Spa and Fitness options.

### Architecture / UI bindings
- Refer to [ADR-1-WellnessChipRepresentation](docs/adr/ADR-1-WellnessChipRepresentation.md) for UI representation details.
- The filtering logic will be implemented in the existing Flutter layers, specifically within the `features/explore`, `MockCatalog`, and `services` directories.