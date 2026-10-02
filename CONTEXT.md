# Context: Friday Snack Vote

## Project Overview
Friday Snack Vote is a lightweight polling application designed for teams to quickly vote on snack choices (or other simple decisions). The system prioritizes simplicity and ease of use over security and advanced features.

## Epic Status
✅ **SHIPPED** - All stories merged and deployed

## Core Functionality
1. **Create Poll**: Users can create polls with a question and 2-10 options
2. **Vote via Link**: Anyone with the poll link can vote (no authentication)
3. **See Results**: Real-time vote counts visible to all viewers

## Technical Stack
- **API**: REST with 3 endpoints (POST /polls, POST /polls/:id/votes, GET /polls/:id)
- **Database**: SQLite (single-file, zero-config)
- **Authentication**: None (intentional design choice)

## Key Design Decisions

### 1. SQLite for Persistence
- **Why**: Zero configuration, portable, sufficient for team-scale use
- **Trade-off**: Limited horizontal scaling, but acceptable for internal tool
- **Details**: [ADR 001](docs/adr/001-sqlite-for-data-persistence.md)

### 2. No Authentication
- **Why**: Simplicity, friction-free experience, faster development
- **Trade-off**: Vulnerable to vote manipulation, but acceptable for low-stakes decisions
- **Details**: [ADR 002](docs/adr/002-no-voter-authentication.md)

### 3. REST API with 3 Endpoints
- **Why**: Simple, predictable, follows standard conventions
- **Trade-off**: No real-time updates (requires polling), but sufficient for use case
- **Details**: [ADR 003](docs/adr/003-rest-api-design.md)

## Data Model

```
polls (id, title, created_at)
  ↓ 1:N
poll_options (id, poll_id, text)
  ↓ 1:N
votes (id, poll_id, option_id, voted_at)
```

## User Flows
1. **Creator** → Creates poll → Shares link
2. **Voter** → Clicks link → Selects option → Votes
3. **Viewer** → Opens link → Sees results → Refreshes for updates

## Documentation Structure
```
docs/
├── requirements/
│   └── friday-snack-vote.md          # User stories and requirements
├── architecture/
│   └── friday-snack-vote-system.md   # System design and API specs
├── adr/
│   ├── 001-sqlite-for-data-persistence.md
│   ├── 002-no-voter-authentication.md
│   └── 003-rest-api-design.md
├── ui/
│   └── user-flows.md                 # UI flows and wireframes
└── stories/
    ├── story-1-create-poll.md        # ✅ Shipped
    ├── story-2-vote-via-link.md      # ✅ Shipped
    └── story-3-see-results.md        # ✅ Shipped
```

## API Quick Reference

### Create Poll
```bash
POST /polls
Body: {"title": "...", "options": ["...", "..."]}
→ 201 Created
```

### Submit Vote
```bash
POST /polls/:id/votes
Body: {"optionId": "..."}
→ 200 OK
```

### Get Results
```bash
GET /polls/:id
→ 200 OK with vote counts
```

## Assumptions & Constraints
- **Target Audience**: Internal team use (10-100 people)
- **Use Case**: Low-stakes decisions (snacks, meeting times)
- **Trust Model**: Honor system, no vote verification
- **Scale**: <100 concurrent voters per poll, <1000 total polls
- **Deployment**: Single-instance server sufficient

## Future Enhancements (Not in Scope)
- Real-time updates via WebSocket
- Vote editing/deletion
- Poll expiration dates
- Analytics and historical data
- Authentication and voter verification
- Multi-server deployment

## Related Resources
- [README.md](README.md) - Getting started guide
- [Full Requirements](docs/requirements/friday-snack-vote.md)
- [System Architecture](docs/architecture/friday-snack-vote-system.md)
- [User Flows](docs/ui/user-flows.md)
