# ADR-1-WellnessChipRepresentation

## Status
Accepted

## Context
The decision was made to add a Wellness filter chip to the existing Harborline Explore application, which allows users to filter venues by Spa or Fitness categories. The implementation must adhere to the existing Flutter layers, specifically within the `features/explore`, `MockCatalog`, and `services` directories.

## Decision
The Wellness chip will be visually represented as a selectable filter within the existing category chips in the Explore feature. It will maintain the fictional Harborline branding and will not introduce any new backend services.

## Consequences
- The filtering logic will ensure that only venues categorized as Spa or Fitness are displayed when the Wellness chip is selected.
- This approach maintains consistency with the existing UI and user experience.
