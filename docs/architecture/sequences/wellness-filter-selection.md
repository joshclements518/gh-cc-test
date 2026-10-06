# Sequence — Wellness Filter Selection

This diagram shows the interaction flow when a guest selects the Wellness filter chip.

```mermaid
sequenceDiagram
    actor Guest
    participant ChipRow as Filter Chip Row
    participant WellnessChip as Wellness FilterChip
    participant State as ExploreScreenState
    participant FilterLogic as filtered getter
    participant Catalog as MockCatalog.venues
    participant UI as Venue List UI
    
    Guest->>ChipRow: Scrolls horizontally
    Guest->>WellnessChip: Taps Wellness chip
    
    rect rgb(227,244,236)
        Note over WellnessChip,State: New flow — added
        WellnessChip->>State: onSelected callback
        State->>State: setState(() => category = "Wellness")
        State->>State: Triggers rebuild
    end
    
    State->>FilterLogic: Calls filtered getter
    
    rect rgb(227,244,236)
        Note over FilterLogic: Enhanced logic — added
        FilterLogic->>FilterLogic: Check if category == "Wellness"
        FilterLogic->>Catalog: Query venues where<br/>category == "Spa" OR category == "Fitness"
    end
    
    Catalog-->>FilterLogic: Returns [Chart Room Spa, Fitness Studio]
    FilterLogic-->>State: Filtered venue list
    State->>UI: Rebuilds venue list
    UI-->>Guest: Displays 2 wellness venues
    
    Guest->>ChipRow: Taps Spa chip (existing flow)
    ChipRow->>State: setState(() => category = "Spa")
    State->>FilterLogic: Calls filtered getter
    FilterLogic->>Catalog: Query venues where category == "Spa"
    Catalog-->>FilterLogic: Returns [Chart Room Spa]
    FilterLogic-->>State: Filtered venue list
    State->>UI: Rebuilds venue list
    UI-->>Guest: Displays 1 spa venue
```

**Key interaction points:**
1. Guest taps Wellness chip → `category` state set to `"Wellness"`
2. Filter logic detects `"Wellness"` and applies OR condition (`Spa || Fitness`)
3. Two venues match: Chart Room Spa and Fitness Studio
4. Selecting any other chip (Spa, All, etc.) deselects Wellness via single-select behavior
5. Existing category chips continue to work unchanged (direct category match)

**Single-select enforcement:**
- Flutter's FilterChip widget handles visual selection state
- Each chip's `selected` property checks `category == chipValue`
- Wellness chip: `selected: category == "Wellness"`
- Spa chip: `selected: category == "Spa"`
- Only one chip can be selected at a time
