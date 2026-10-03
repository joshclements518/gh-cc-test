```mermaid
sequenceDiagram
    participant U as User
    participant EP as Explore Page
    participant MC as MockCatalog
    participant DR as Display Results

    U->>EP: Selects Wellness Chip
    EP->>MC: Filter venues by Spa or Fitness
    MC-->>EP: Returns filtered venues
    EP->>DR: Display filtered results
    Note over DR: If no results, show "No results found"
```