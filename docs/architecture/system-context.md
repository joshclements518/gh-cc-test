```mermaid
flowchart TD
    A["User"] -->|"Interacts with"| B[UI]
    B -->|"Selects Wellness Chip"| C[Filtering Logic]
    C -->|"Filters Venues"| D[MockCatalog]
    D -->|"Returns Spa and Fitness Venues"| E[UI]
    E -->|"Displays Filtered Results"| A
    classDef added fill:#d4f8e8;
    class A,B,C,D,E added;
```
