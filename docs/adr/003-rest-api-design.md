# ADR 003: REST API Design with Three Core Endpoints

## Status
Accepted

## Context
The Friday Snack Vote application requires an API to support poll creation, voting, and result viewing. We need to define the API style and endpoint structure.

## Decision
We will implement a **REST API** with three core endpoints:
1. `POST /polls` - Create a new poll
2. `POST /polls/:id/votes` - Submit a vote
3. `GET /polls/:id` - Retrieve poll with current results

## Rationale

### REST Principles
- **Resource-Oriented**: Polls and votes are clear resources
- **Standard HTTP Methods**: POST for creation, GET for retrieval
- **Stateless**: Each request contains all necessary information
- **Simple and Predictable**: Easy to understand and consume

### Endpoint Design Decisions

#### 1. POST /polls (Create Poll)
- **Method**: POST (creates new resource)
- **Path**: `/polls` (collection endpoint)
- **Returns**: Complete poll object with generated ID and shareable link
- **Idempotency**: Not idempotent (each call creates new poll)

#### 2. POST /polls/:id/votes (Submit Vote)
- **Method**: POST (creates new vote record)
- **Path**: `/polls/:id/votes` (nested resource under specific poll)
- **Body**: Contains option ID to vote for
- **Returns**: Success confirmation
- **Idempotency**: Not strictly idempotent (allows multiple votes from same source)

#### 3. GET /polls/:id (Get Results)
- **Method**: GET (retrieves resource)
- **Path**: `/polls/:id` (specific poll resource)
- **Returns**: Poll with current vote counts
- **Idempotency**: Idempotent (safe to call multiple times)

### Design Choices

#### Combined Results Endpoint
We use a single `GET /polls/:id` endpoint for both viewing the poll and seeing results, rather than separate endpoints like `/polls/:id/vote` and `/polls/:id/results`.

**Rationale**:
- Simpler API surface (3 endpoints instead of 4+)
- Results are always current—no separate "results view"
- Client can use same endpoint for initial poll load and result updates

#### Nested Vote Endpoint
We use `/polls/:id/votes` rather than a top-level `/votes` endpoint.

**Rationale**:
- Clearly associates votes with specific polls
- RESTful resource hierarchy
- Prevents ambiguity about which poll is being voted on

## Alternatives Considered

### GraphQL
- **Pros**: Flexible queries, single endpoint, strong typing
- **Cons**: More complex setup, overkill for simple CRUD operations
- **Verdict**: Unnecessary complexity for three simple operations

### RPC-Style API
- **Pros**: Action-oriented, explicit operations
- **Cons**: Less standardized, doesn't leverage HTTP semantics
- **Verdict**: REST is more conventional and easier to consume

### WebSocket/Real-Time API
- **Pros**: Live result updates without polling
- **Cons**: More complex, requires persistent connections, overkill for use case
- **Verdict**: Polling GET requests sufficient for result updates

### Separate Vote and Results Endpoints
```
GET /polls/:id/vote  (view poll for voting)
GET /polls/:id/results  (view results)
```
- **Pros**: Clearer separation of concerns
- **Cons**: More endpoints, results are always current anyway
- **Verdict**: Single endpoint simpler and sufficient

## Consequences

### Positive
- Simple, predictable API that follows REST conventions
- Easy to document and understand
- Standard HTTP methods and status codes
- Can be consumed by any HTTP client
- Minimal learning curve for developers

### Negative
- No built-in real-time updates (requires client polling for live results)
- No batch operations (create multiple polls at once)
- Limited flexibility compared to GraphQL

### Neutral
- Clients must poll `GET /polls/:id` for result updates
- No versioning strategy defined yet (can add `/v1/` prefix if needed)

## Implementation Notes

### HTTP Status Codes
- `200 OK`: Successful GET or POST (vote submission)
- `201 Created`: Successful poll creation
- `400 Bad Request`: Invalid input (malformed request, invalid option)
- `404 Not Found`: Poll or option doesn't exist
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server-side errors

### Content Type
- Request: `application/json`
- Response: `application/json`

### Error Response Format
```json
{
  "error": "Human-readable error message",
  "code": "MACHINE_READABLE_CODE"
}
```

### CORS
- Enable CORS for browser-based clients
- Allow all origins for simplicity (internal tool)

## Future Considerations
- Add `DELETE /polls/:id` if poll deletion is needed
- Add `GET /polls` to list all polls if needed
- Consider `PATCH /polls/:id` for editing poll details
- Add API versioning (`/v1/polls`) if breaking changes anticipated
