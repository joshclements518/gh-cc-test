```mermaid
erDiagram
    VENUE ||--o{ CATEGORY : has
    VENUE {
        string id
        string name
        string description
        string location
        string category
    }
    CATEGORY {
        string id
        string name
    }

    VENUE ||--o{ CATEGORY : has
    VENUE {
        string id
        string name
        string description
        string location
        string category
    }%% added
    CATEGORY {
        string id
        string name
    }%% added
```