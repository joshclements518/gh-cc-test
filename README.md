# Friday Snack Vote

A simple polling application for voting on Friday snack choices. Create polls, share links, and see results in real-time.

## Features

- **Create Polls**: Set up a poll with a title and multiple options
- **Vote via Link**: Share a unique link for others to vote
- **View Results**: See live vote counts for each option
- **No Authentication**: Quick, anonymous voting without login

## Quick Start

### API Endpoints

```bash
# Create a new poll
POST /polls
{
  "title": "Friday Snack Choice",
  "options": ["Pizza", "Tacos", "Sushi", "Burgers"]
}

# Vote on a poll
POST /polls/:id/votes
{
  "option": "Pizza"
}

# Get poll results
GET /polls/:id
```

## Architecture

- **Database**: SQLite (lightweight, file-based)
- **API**: RESTful HTTP endpoints
- **Authentication**: None (anonymous voting)

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- **Requirements**: [docs/requirements/prd.md](docs/requirements/prd.md)
- **Architecture**: [docs/architecture/](docs/architecture/)
  - [System Overview](docs/architecture/system-overview.md)
  - [API Specification](docs/architecture/api-specification.md)
  - [Database Schema](docs/architecture/database-schema.md)
- **Architecture Decision Records**: [docs/adr/](docs/adr/)
  - [ADR 001: Use SQLite Database](docs/adr/001-use-sqlite-database.md)
  - [ADR 002: No Voter Authentication](docs/adr/002-no-voter-authentication.md)
  - [ADR 003: REST API Design](docs/adr/003-rest-api-design.md)
- **UI/UX**: [docs/ui/user-flows.md](docs/ui/user-flows.md)

## Use Cases

Perfect for:
- Team snack voting
- Meeting time polls
- Quick preference surveys
- Informal team decisions

## Design Decisions

### Why SQLite?
Lightweight, zero-configuration database suitable for low to medium traffic. No separate database server required.

### Why No Authentication?
Simplifies user experience for low-stakes internal polls. Users can vote immediately without creating accounts.

### Why REST API?
Standard, well-understood interface that's easy to integrate with any client (web, mobile, CLI).

## Limitations

- No duplicate vote prevention (same user can vote multiple times)
- No vote modification after submission
- No poll expiration or closing
- Single-server deployment (SQLite limitation)

## Future Enhancements

Potential features for future iterations:
- Real-time result updates (WebSocket/SSE)
- Poll expiration dates
- Client-side duplicate vote detection
- Poll management (edit, delete)
- Poll listing and search
- Export results to CSV

## Contributing

See documentation in `docs/` for architecture details and design decisions.

## License

[Add license information]
