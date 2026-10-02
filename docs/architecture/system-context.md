# System Context — Friday Snack Vote

## Overview
The Friday Snack Vote system is a minimal internal polling application designed for quick, anonymous team voting on snack preferences.

## System Context Diagram

```mermaid
graph TB
    Admin[Admin User]
    Voter[Team Member]
    App[Snack Vote App<br/>Node.js API]
    DB[(SQLite Database)]
    
    Admin -->|Create poll via magic link| App
    Voter -->|Vote via shared link| App
    App -->|Read/Write| DB
    
    style App fill:#e1f5ff
    style DB fill:#fff4e1
```

## Components

### Node.js API Server
- Handles poll creation, voting, and results
- Serves static frontend assets
- Manages magic link authentication for admins

### SQLite Database
- Stores polls, options, and votes
- Runs on Azure Container Apps (ACA) instance
- Single-file persistence

### Frontend (Desktop Web)
- Poll creation interface (admin)
- Voting interface (public)
- Results display

## Key Characteristics
- **Deployment:** Azure Container Apps
- **Storage:** SQLite (local to container)
- **Authentication:** Magic links for admins only
- **Access:** Shared links for voters (no auth)
