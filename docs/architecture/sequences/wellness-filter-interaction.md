```mermaid
sequenceDiagram
    participant User as User (Guest)
    participant App as Harborline Navigator App
    participant Filter as Wellness Filter Chip
    participant Venue as Venues

    User->>App: Clicks on Wellness Filter Chip
    App->>Filter: Activates filter
    Filter->>Venue: Fetches venues (Spa or Fitness)
    Venue-->>App: Returns filtered venues
    App-->>User: Displays filtered venues
    Note over User, App: User sees only Spa and Fitness options
```