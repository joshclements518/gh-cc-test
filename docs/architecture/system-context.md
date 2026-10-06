# System Context — Wellness Filter Chip

This diagram shows the Explore screen's filter chip architecture and how the Wellness chip integrates with the existing single-select category filtering system.

```mermaid
flowchart TB
    User["Guest User"]
    ExploreScreen["ExploreScreen Widget<br/>(explore_screen.dart)"]
    FilterChipRow["Filter Chip Row<br/>(SingleChildScrollView)"]
    AllChip["All Chip"]
    CategoryChips["Category Chips<br/>(Dining, Entertainment, Fitness,<br/>Lounge, Recreation, Services,<br/>Spa, Youth)"]
    WellnessChip["Wellness Chip"]
    FilterLogic["Filter Logic<br/>(filtered getter)"]
    MockCatalog["MockCatalog.venues<br/>(mock_catalog.dart)"]
    VenueList["Venue List Display"]
    
    User -->|"Taps chip"| FilterChipRow
    FilterChipRow --> AllChip
    FilterChipRow --> CategoryChips
    FilterChipRow --> WellnessChip
    
    AllChip -->|"Sets category = null"| ExploreScreen
    CategoryChips -->|"Sets category = selected"| ExploreScreen
    WellnessChip -->|"Sets category = 'Wellness'"| ExploreScreen
    
    ExploreScreen -->|"Reads category state"| FilterLogic
    FilterLogic -->|"Queries venues"| MockCatalog
    FilterLogic -->|"Filters results"| VenueList
    
    MockCatalog -.->|"Chart Room Spa<br/>(category: Spa)"| FilterLogic
    MockCatalog -.->|"Fitness Studio<br/>(category: Fitness)"| FilterLogic
    
    classDef added fill:#e3f4ec,stroke:#2d6a4f
    class WellnessChip added
```

**Key architectural elements:**
- **ExploreScreen** maintains `category` state (String?) that drives filtering
- **Filter chip row** is a horizontal scrollable list of single-select FilterChip widgets
- **Wellness chip** is added to the existing chip row alongside All and category chips
- **Filter logic** in the `filtered` getter currently matches `v.category == category`
- **MockCatalog** provides static venue data with category field (Spa, Fitness, etc.)

**Change scope:**
- Green node (Wellness Chip) is the new UI element
- Filter logic must be enhanced to handle the Wellness pseudo-category
