```mermaid
erDiagram
    Venue {
        string id
        string name
        string category
    }

    MockCatalog {
        string venues
    }

    Venue ||--o{ MockCatalog : contains
```