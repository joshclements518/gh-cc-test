# Context — Friday Snack Vote

## Project Overview
Friday Snack Vote is a lightweight polling application designed for quick, informal team voting on snack choices and other low-stakes decisions.

## Epic 160: Pipeline Test DOC H01
This project was developed as part of Epic 160, implementing a complete polling system with three core user stories:
1. Create poll
2. Vote via link
3. See results

## Current State
All stories have been merged and shipped. The application provides:
- RESTful API with three endpoints
- SQLite database backend
- Anonymous voting (no authentication)
- Simple poll creation and result viewing

## Key Design Principles

### Simplicity First
The application prioritizes ease of use over advanced features. No user accounts, no complex configuration, no authentication barriers.

### Appropriate Technology
- **SQLite**: Sufficient for expected load, zero configuration
- **REST API**: Standard interface, easy integration
- **Anonymous voting**: Matches the low-stakes use case

### Intentional Limitations
The following are deliberate design choices, not oversights:
- No authentication (appropriate for internal polls)
- No duplicate vote prevention (acceptable trade-off for simplicity)
- No poll editing (keeps implementation simple)
- No real-time updates (can refresh manually)

## Architecture Summary

```
Client → REST API → SQLite Database
```

### Three Endpoints
1. `POST /polls` - Create new poll
2. `POST /polls/:id/votes` - Submit vote
3. `GET /polls/:id` - Get results

### Two Main Tables
1. `polls` - Poll metadata
2. `votes` - Individual vote records
3. `poll_options` - Available options per poll

## Use Case
Designed for internal team use where:
- Trust level is high
- Stakes are low (snack choices, meeting times)
- Speed and convenience matter more than vote integrity
- Informal, non-binding decisions

## Documentation Structure

```
docs/
├── requirements/
│   └── prd.md                          # Product requirements
├── architecture/
│   ├── system-overview.md              # High-level architecture
│   ├── api-specification.md            # API endpoints and contracts
│   └── database-schema.md              # SQLite schema
├── adr/
│   ├── 001-use-sqlite-database.md      # Database choice
│   ├── 002-no-voter-authentication.md  # Authentication decision
│   └── 003-rest-api-design.md          # API design rationale
└── ui/
    └── user-flows.md                   # User interaction flows
```

## Key Decisions (ADRs)

### ADR 001: SQLite Database
Chose SQLite for simplicity and zero configuration. Appropriate for expected load.

### ADR 002: No Voter Authentication
Intentionally omitted authentication to reduce friction for low-stakes polls.

### ADR 003: REST API Design
Standard REST endpoints using HTTP semantics for poll operations.

## Future Considerations

If the application scope expands:
- **Higher traffic**: Migrate to PostgreSQL or MySQL
- **Important decisions**: Add authentication and duplicate prevention
- **Real-time needs**: Implement WebSocket or SSE for live updates
- **Poll management**: Add edit/delete capabilities

## Getting Started

1. Review the [PRD](docs/requirements/prd.md) for user stories
2. Check [System Overview](docs/architecture/system-overview.md) for architecture
3. See [API Specification](docs/architecture/api-specification.md) for endpoint details
4. Read [ADRs](docs/adr/) for design rationale

## Related Resources
- Epic Issue: #160
- Repository: joshclements518/gh-cc-test
