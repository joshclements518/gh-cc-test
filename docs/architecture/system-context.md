# System Context — Wellness Filter Chip

```mermaid
flowchart TB
    Guest[Guest User]
    ExploreScreen["ExploreScreen<br/>(app/lib/features/explore/explore_screen.dart)"]
    MockCatalog["MockCatalog<br/>(app/lib/data/mock_catalog.dart)"]
    Venue["Venue model<br/>(app/lib/data/models.dart)"]
    
    Guest -->|"Taps filter chip"| ExploreScreen
    ExploreScreen -->|"Reads venues list"| MockCatalog
    MockCatalog -->|"Provides 9 venues"| Venue
    ExploreScreen -->|"Filters by category field"| Venue
    
    WellnessChip["Wellness chip (added)"]
    WellnessFilter["OR filter logic (added)"]
    
    Guest -->|"Taps Wellness"| WellnessChip
    WellnessChip -->|"Triggers"| WellnessFilter
    WellnessFilter -->|"Matches Spa OR Fitness"| Venue
    
    class WellnessChip added
    class WellnessFilter added
    
    classDef added fill:#e3f4ec,stroke:#2da160,stroke-width:2px
```

## Context

The Harborline Navigator app's Explore screen currently filters venues by a single category using exact string matching. The Wellness filter chip extends this to support a logical OR condition matching two categories (Spa OR Fitness) while preserving the existing single-select chip behavior.

**Key constraint**: The existing `String? category` state variable and `v.category == category` filter logic must be extended to support the Wellness multi-category match without breaking existing single-category chips.
