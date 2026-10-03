```mermaid
sequenceDiagram
    participant User
    participant UI
    participant FilteringLogic
    participant MockCatalog

    User->>UI: Selects Wellness Chip
    UI->>FilteringLogic: Trigger Filter
    FilteringLogic->>MockCatalog: Request Spa and Fitness Venues
    MockCatalog-->>FilteringLogic: Return Venues
    FilteringLogic-->>UI: Display Filtered Results
    UI-->>User: Show Filtered Venues
```
