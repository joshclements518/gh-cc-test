# Context - Friday Snack Vote

## Project Overview

**Friday Snack Vote** is a lightweight polling application designed for team snack preference collection. The system enables quick consensus gathering through shareable poll links without requiring user authentication.

## Epic 190: Pipeline Test DOC H01

This project was developed as part of Epic 190, implementing a complete polling system with three core user stories:

1. **Create Poll**: Organizers can create polls with multiple snack options
2. **Vote via Link**: Team members vote through shareable links (no login)
3. **See Results**: Real-time view of vote counts and totals

## Architecture Summary

### Technology Stack
- **Database**: SQLite (embedded, single-file)
- **API**: RESTful HTTP endpoints
- **Authentication**: None (link-based access control)

### Core Endpoints
```
POST   /polls           - Create new poll
POST   /polls/:id/votes - Submit vote
GET    /polls/:id       - Retrieve results
```

### Data Model
```
polls (id, title, created_at)
  ├── options (id, poll_id, text, position)
  └── votes (id, poll_id, option_id, created_at)
```

## Key Design Decisions

### 1. SQLite Database (ADR 001)
**Rationale**: Zero-configuration, single-file storage, sufficient for team-scale usage

**Trade-offs**: Limited write concurrency, single-server deployment

### 2. No Authentication (ADR 002)
**Rationale**: Frictionless voting experience, faster implementation, appropriate for informal team polls

**Trade-offs**: No vote attribution, trust-based system, potential for duplicate votes

### 3. REST API (ADR 003)
**Rationale**: Standard HTTP conventions, stateless, works with any client

**Trade-offs**: No real-time push updates (client must poll for changes)

## User Flows

### Poll Creation Flow
1. Organizer enters poll title and options
2. System generates unique poll ID
3. Shareable link provided
4. Link distributed to team

### Voting Flow
1. Team member receives poll link
2. Opens link (no login required)
3. Selects preferred option
4. Submits vote
5. Sees confirmation and current results

### Results Flow
1. Anyone with link can view results
2. Poll displays all options with vote counts
3. Total votes shown
4. Results update on page refresh

## Security Model

- **Access Control**: Obscure poll IDs prevent enumeration
- **No Authentication**: Link possession grants access
- **No Authorization**: All poll link holders have equal access
- **Input Validation**: Prevents SQL injection and malformed requests

## Performance Characteristics

- **Poll Creation**: < 500ms
- **Vote Submission**: < 300ms
- **Results Retrieval**: < 200ms
- **Concurrency**: Supports 100+ concurrent voters
- **Scale**: Handles 10,000+ votes per poll

## Use Cases

### Primary Use Case
Weekly team snack ordering where:
- One person creates the poll
- Team votes on preferences
- Organizer orders based on results

### Additional Use Cases
- Lunch venue selection
- Meeting time preferences
- Quick team consensus gathering
- Informal opinion polling

## Out of Scope

The following features are explicitly NOT included:
- User authentication or login
- Vote editing or deletion
- Poll expiration/closing
- Results visualization (charts)
- Email notifications
- Real-time WebSocket updates
- Duplicate vote prevention (beyond basic measures)

## Documentation Structure

```
docs/
├── requirements/
│   └── functional-requirements.md    # User stories, acceptance criteria
├── architecture/
│   └── overview.md                   # System design, data flow
├── adr/
│   ├── 001-sqlite-database.md        # Database choice
│   ├── 002-no-authentication.md      # Auth decision
│   └── 003-rest-api-design.md        # API design
├── api/
│   └── endpoints.md                  # API reference, examples
├── database/
│   └── schema.md                     # Schema, queries, migrations
└── ui/
    └── user-flows.md                 # User journeys, interaction patterns
```

## Development Status

**Status**: Stories merged and shipped (Epic 190 complete)

All three core stories have been implemented and merged:
- ✅ Poll creation with SQLite persistence
- ✅ Vote submission via POST endpoint
- ✅ Results retrieval with vote counts

## Future Enhancements

Potential features for future iterations:
- Poll expiration dates
- Results export (CSV, PDF)
- Visual charts and graphs
- IP-based duplicate vote detection
- Admin dashboard
- Poll templates
- Vote editing within time window

## Maintenance Notes

### Backup Strategy
- SQLite database is a single file
- Regular automated backups recommended
- Simple file copy when database is idle

### Monitoring
- Track API response times
- Monitor database file size
- Log error rates and types

### Scaling Considerations
- Current architecture suitable for small-to-medium teams
- For larger scale, consider:
  - Migration to PostgreSQL/MySQL
  - Read replicas for results queries
  - Caching layer for frequently accessed polls

## References

- Epic Issue: #190
- Repository: joshclements518/gh-cc-test
- Documentation: `/docs/**`
