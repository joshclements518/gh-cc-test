# ADR 003: REST API Design

## Status
Accepted

## Context
The Friday Snack Vote application needs an API interface for clients to interact with the polling system. We need to define the API architecture and endpoint structure.

## Decision
We will implement a RESTful HTTP API with three core endpoints:
- `POST /polls` - Create a new poll
- `POST /polls/:id/votes` - Submit a vote
- `GET /polls/:id` - Retrieve poll results

## Rationale

### Advantages
1. **Standard Pattern**: REST is widely understood and adopted
2. **HTTP Semantics**: Uses appropriate HTTP methods (GET, POST) for operations
3. **Stateless**: Each request is independent, simplifying server design
4. **Simple Integration**: Easy to consume from web browsers, mobile apps, or CLI tools
5. **Resource-Oriented**: Clear mapping between URLs and resources (polls, votes)

### Design Principles Applied
- **Resource-based URLs**: `/polls/:id` represents a poll resource
- **HTTP verbs**: POST for creation, GET for retrieval
- **JSON payloads**: Standard, human-readable data format
- **Nested resources**: Votes are nested under polls (`/polls/:id/votes`)

## Alternatives Considered

### GraphQL
- **Pros**: Flexible querying, single endpoint, type system
- **Cons**: More complex setup, overkill for simple CRUD operations, steeper learning curve
- **Verdict**: Too complex for three simple operations

### RPC-style API
- **Pros**: Simple to implement, direct function calls
- **Cons**: Less standardized, doesn't leverage HTTP semantics
- **Verdict**: REST provides better structure and conventions

### WebSocket/Real-time API
- **Pros**: Live updates, bidirectional communication
- **Cons**: More complex, requires persistent connections, unnecessary for current needs
- **Verdict**: Polling results can be refreshed with simple GET requests

### Server-Sent Events (SSE)
- **Pros**: Server push for live results
- **Cons**: Adds complexity, not required for MVP
- **Verdict**: Can be added later if real-time updates are needed

## API Design Details

### Endpoint Structure
```
POST   /polls              # Create poll
POST   /polls/:id/votes    # Submit vote
GET    /polls/:id          # Get results
```

### Why These Endpoints?

**POST /polls**
- Creates a new resource (poll)
- Returns poll ID for sharing
- Idempotent: multiple identical requests create separate polls (intentional)

**POST /polls/:id/votes**
- Creates a new vote resource
- Nested under poll to show relationship
- Not idempotent: each request creates a new vote (by design, no auth)

**GET /polls/:id**
- Retrieves poll state and aggregated results
- Safe and idempotent
- Combines poll metadata and vote counts in single response

### Endpoints NOT Included
- `PUT/PATCH /polls/:id` - No poll editing after creation
- `DELETE /polls/:id` - No poll deletion (can be added later)
- `DELETE /votes/:id` - No vote deletion (anonymous votes)
- `GET /polls` - No poll listing (polls accessed via direct link only)

## Consequences

### Positive
- Clear, predictable API structure
- Easy to document and test
- Standard HTTP status codes convey meaning
- Can be consumed by any HTTP client
- Cacheable GET responses (if needed)

### Negative
- No built-in real-time updates (requires polling)
- No batch operations (create multiple polls at once)
- Limited query capabilities (no filtering, sorting, pagination)

### Future Considerations
- Add `GET /polls` with pagination if poll listing is needed
- Add `DELETE /polls/:id` if poll management is required
- Consider WebSocket or SSE for real-time result updates
- Add query parameters to `GET /polls/:id` for filtering (e.g., `?include=votes`)

## Notes
This REST design prioritizes simplicity and covers the three core user stories:
1. Create poll → `POST /polls`
2. Vote via link → `POST /polls/:id/votes`
3. See results → `GET /polls/:id`

The API is intentionally minimal but can be extended as requirements evolve.
