# Friday Snack Vote 🍕🌮🍣🍔

A simple polling application for teams to vote on Friday snacks. Create polls, share links, and see real-time results—no authentication required.

## Features

- **Create Polls**: Set up a poll with a question and 2-10 snack options
- **Vote via Link**: Share a simple link; anyone can vote instantly
- **See Results**: View live vote counts and see which snack is winning
- **No Login Required**: Friction-free voting experience
- **Lightweight**: SQLite backend, simple REST API

## Quick Start

### Create a Poll
```bash
curl -X POST http://localhost:3000/polls \
  -H "Content-Type: application/json" \
  -d '{
    "title": "What snack should we get this Friday?",
    "options": ["Pizza", "Tacos", "Sushi", "Burgers"]
  }'
```

Response:
```json
{
  "id": "abc123",
  "title": "What snack should we get this Friday?",
  "options": [
    {"id": "opt1", "text": "Pizza", "votes": 0},
    {"id": "opt2", "text": "Tacos", "votes": 0},
    {"id": "opt3", "text": "Sushi", "votes": 0},
    {"id": "opt4", "text": "Burgers", "votes": 0}
  ],
  "link": "/polls/abc123"
}
```

### Vote
```bash
curl -X POST http://localhost:3000/polls/abc123/votes \
  -H "Content-Type: application/json" \
  -d '{"optionId": "opt2"}'
```

### View Results
```bash
curl http://localhost:3000/polls/abc123
```

Response:
```json
{
  "id": "abc123",
  "title": "What snack should we get this Friday?",
  "options": [
    {"id": "opt1", "text": "Pizza", "votes": 5},
    {"id": "opt2", "text": "Tacos", "votes": 12},
    {"id": "opt3", "text": "Sushi", "votes": 3},
    {"id": "opt4", "text": "Burgers", "votes": 8}
  ],
  "totalVotes": 28
}
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/polls` | Create a new poll |
| `POST` | `/polls/:id/votes` | Submit a vote |
| `GET` | `/polls/:id` | Get poll with current results |

See [API Documentation](docs/architecture/friday-snack-vote-system.md) for detailed specifications.

## Architecture

- **Backend**: REST API (Node.js/Python/Go)
- **Database**: SQLite
- **Authentication**: None (by design)

### Key Design Decisions
- [ADR 001: SQLite for Data Persistence](docs/adr/001-sqlite-for-data-persistence.md)
- [ADR 002: No Voter Authentication](docs/adr/002-no-voter-authentication.md)
- [ADR 003: REST API Design](docs/adr/003-rest-api-design.md)

## Documentation

- **Requirements**: [docs/requirements/friday-snack-vote.md](docs/requirements/friday-snack-vote.md)
- **Architecture**: [docs/architecture/friday-snack-vote-system.md](docs/architecture/friday-snack-vote-system.md)
- **User Flows**: [docs/ui/user-flows.md](docs/ui/user-flows.md)
- **Stories**:
  - [Story 1: Create Poll](docs/stories/story-1-create-poll.md)
  - [Story 2: Vote via Link](docs/stories/story-2-vote-via-link.md)
  - [Story 3: See Results](docs/stories/story-3-see-results.md)

## Database Schema

```sql
CREATE TABLE polls (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE poll_options (
    id TEXT PRIMARY KEY,
    poll_id TEXT NOT NULL,
    text TEXT NOT NULL,
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

CREATE TABLE votes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    poll_id TEXT NOT NULL,
    option_id TEXT NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (poll_id) REFERENCES polls(id),
    FOREIGN KEY (option_id) REFERENCES poll_options(id)
);
```

## Use Cases

- **Team Snack Decisions**: Vote on Friday snacks, lunch orders, or coffee runs
- **Quick Polls**: Gather team preferences without formal surveys
- **Meeting Times**: Find the best time for team meetings
- **Event Planning**: Choose activities, venues, or themes

## Security & Privacy

- **No Authentication**: Anyone with the link can vote (trust-based system)
- **No Personal Data**: No user accounts, emails, or tracking
- **Vote Manipulation**: Possible but acceptable for internal team use
- **Rate Limiting**: Optional IP-based throttling available

## Limitations

- **No Vote Editing**: Votes are immutable once cast
- **No Voter Identity**: Cannot track who voted for what
- **Single Server**: SQLite limits horizontal scaling
- **No Real-Time Updates**: Clients must poll for result updates

## Contributing

This project follows a story-driven development workflow:
1. Requirements defined in `docs/requirements/`
2. Architecture decisions documented in `docs/adr/`
3. Stories implemented and tracked in `docs/stories/`

## License

[Add your license here]

## Support

For questions or issues, please [open an issue](https://github.com/joshclements518/gh-cc-test/issues).
