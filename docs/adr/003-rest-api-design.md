# ADR 003: RESTful API Design

## Status
Accepted

## Context
The Friday Snack Vote application requires an API for clients to create polls, submit votes, and retrieve results. We need to define the API style and endpoint structure.

## Decision
We will implement a RESTful HTTP API with three core endpoints:
- `POST /polls` - Create a new poll
- `POST /polls/:id/votes` - Submit a vote
- `GET /polls/:id` - Retrieve poll details and results

## Rationale

### REST Principles
1. **Resource-Oriented**: Polls and votes are clear resources
2. **Standard HTTP Methods**: POST for creation, GET for retrieval
3. **Stateless**: Each request contains all necessary information
4. **Cacheable**: GET responses can be cached for performance

### Endpoint Design

#### POST /polls
Creates a new poll with options.

**Request Body:**
```json
{
  "title": "Friday Snack Choice",
  "options": ["Pizza", "Tacos", "Sushi", "Salad"]
}
```

**Response:**
```json
{
  "id": "abc123xyz",
  "title": "Friday Snack Choice",
  "options": [
    {"id": 1, "text": "Pizza"},
    {"id": 2, "text": "Tacos"},
    {"id": 3, "text": "Sushi"},
    {"id": 4, "text": "Salad"}
  ],
  "created_at": "2024-01-15T10:00:00Z",
  "vote_url": "/polls/abc123xyz"
}
```

#### POST /polls/:id/votes
Submits a vote for a poll option.

**Request Body:**
```json
{
  "option_id": 2
}
```

**Response:**
```json
{
  "success": true,
  "poll_id": "abc123xyz",
  "option_id": 2,
  "message": "Vote recorded"
}
```

#### GET /polls/:id
Retrieves poll details and current vote counts.

**Response:**
```json
{
  "id": "abc123xyz",
  "title": "Friday Snack Choice",
  "options": [
    {"id": 1, "text": "Pizza", "votes": 5},
    {"id": 2, "text": "Tacos", "votes": 8},
    {"id": 3, "text": "Sushi", "votes": 3},
    {"id": 4, "text": "Salad", "votes": 2}
  ],
  "total_votes": 18,
  "created_at": "2024-01-15T10:00:00Z"
}
```

## Consequences

### Positive
- **Intuitive**: Standard REST conventions are widely understood
- **Tooling**: Works with standard HTTP clients, browsers, curl
- **Stateless**: Easy to scale horizontally
- **Debuggable**: Simple to test and troubleshoot

### Negative
- **Chattiness**: Multiple requests needed for complete workflows
- **No Real-time Updates**: Clients must poll for result changes

## Alternatives Considered

### GraphQL
- **Pros**: Flexible queries, single endpoint, real-time subscriptions
- **Cons**: More complex implementation, overkill for simple use case

### WebSocket
- **Pros**: Real-time bidirectional communication
- **Cons**: More complex, stateful connections, unnecessary for polling app

### RPC-Style API
- **Pros**: Action-oriented, potentially simpler
- **Cons**: Less standard, harder to cache, doesn't leverage HTTP semantics

## HTTP Status Codes

### Success Codes
- `200 OK` - Successful GET request
- `201 Created` - Successful POST /polls
- `200 OK` - Successful POST /polls/:id/votes

### Error Codes
- `400 Bad Request` - Invalid request body or parameters
- `404 Not Found` - Poll ID does not exist
- `422 Unprocessable Entity` - Valid format but invalid data (e.g., invalid option_id)
- `500 Internal Server Error` - Server-side errors

## Content Type
- All requests and responses use `application/json`
- UTF-8 encoding

## Future Enhancements
- `DELETE /polls/:id` - Delete a poll (admin feature)
- `PATCH /polls/:id` - Update poll details
- Query parameters for GET /polls/:id (e.g., `?include_votes=false`)
- Pagination for future list endpoints
