# API Specification — Friday Snack Vote

## Base URL
```
/api
```

## Endpoints

### 1. Create Poll
**Endpoint:** `POST /polls`

**Description:** Creates a new poll with options.

**Request Body:**
```json
{
  "title": "Friday Snack Choice",
  "options": ["Pizza", "Tacos", "Sushi", "Burgers"]
}
```

**Response:** `201 Created`
```json
{
  "id": "abc123",
  "title": "Friday Snack Choice",
  "options": ["Pizza", "Tacos", "Sushi", "Burgers"],
  "created_at": "2024-01-15T10:30:00Z",
  "link": "/polls/abc123"
}
```

**Error Responses:**
- `400 Bad Request` - Invalid poll data (missing title or options)
- `500 Internal Server Error` - Database error

---

### 2. Submit Vote
**Endpoint:** `POST /polls/:id/votes`

**Description:** Submits a vote for a specific poll option.

**URL Parameters:**
- `id` (string) - The poll identifier

**Request Body:**
```json
{
  "option": "Pizza"
}
```

**Response:** `201 Created`
```json
{
  "poll_id": "abc123",
  "option": "Pizza",
  "voted_at": "2024-01-15T10:35:00Z"
}
```

**Error Responses:**
- `400 Bad Request` - Invalid option or missing data
- `404 Not Found` - Poll does not exist
- `500 Internal Server Error` - Database error

---

### 3. Get Poll Results
**Endpoint:** `GET /polls/:id`

**Description:** Retrieves poll details and current vote counts.

**URL Parameters:**
- `id` (string) - The poll identifier

**Response:** `200 OK`
```json
{
  "id": "abc123",
  "title": "Friday Snack Choice",
  "created_at": "2024-01-15T10:30:00Z",
  "results": [
    {
      "option": "Pizza",
      "votes": 5
    },
    {
      "option": "Tacos",
      "votes": 3
    },
    {
      "option": "Sushi",
      "votes": 7
    },
    {
      "option": "Burgers",
      "votes": 2
    }
  ],
  "total_votes": 17
}
```

**Error Responses:**
- `404 Not Found` - Poll does not exist
- `500 Internal Server Error` - Database error

---

## Data Models

### Poll
```json
{
  "id": "string (unique identifier)",
  "title": "string",
  "options": ["string"],
  "created_at": "ISO 8601 timestamp"
}
```

### Vote
```json
{
  "id": "integer (auto-increment)",
  "poll_id": "string (foreign key)",
  "option": "string",
  "voted_at": "ISO 8601 timestamp"
}
```

## Notes
- No authentication required for any endpoint
- Poll IDs are generated server-side
- Votes are anonymous and cannot be modified after submission
- No rate limiting implemented
- No duplicate vote prevention (same user can vote multiple times)
