# API Specification — Friday Snack Vote

## Base URL
```
https://<app-name>.azurecontainerapps.io
```

## Endpoints

### Create Poll
Creates a new snack poll with options.

**Endpoint:** `POST /polls`

**Request Body:**
```json
{
  "title": "Friday Snack Vote - Jan 12",
  "options": [
    "Chips & Salsa",
    "Fruit Platter",
    "Cookies",
    "Veggie Tray"
  ]
}
```

**Response:** `201 Created`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Friday Snack Vote - Jan 12",
  "created_at": "2025-01-12T10:00:00Z",
  "share_url": "https://<app>/polls/550e8400-e29b-41d4-a716-446655440000",
  "admin_url": "https://<app>/admin?token=abc123xyz"
}
```

---

### Get Poll Details
Retrieves poll information, options, and current vote counts.

**Endpoint:** `GET /polls/:id`

**Parameters:**
- `id` (path) - Poll UUID

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Friday Snack Vote - Jan 12",
  "created_at": "2025-01-12T10:00:00Z",
  "options": [
    {
      "id": "opt-001",
      "name": "Chips & Salsa",
      "votes": 5
    },
    {
      "id": "opt-002",
      "name": "Fruit Platter",
      "votes": 3
    },
    {
      "id": "opt-003",
      "name": "Cookies",
      "votes": 8
    },
    {
      "id": "opt-004",
      "name": "Veggie Tray",
      "votes": 2
    }
  ],
  "total_votes": 18
}
```

**Error Responses:**
- `404 Not Found` - Poll does not exist

---

### Cast Vote
Submits a vote for a specific option.

**Endpoint:** `POST /polls/:id/votes`

**Parameters:**
- `id` (path) - Poll UUID

**Request Body:**
```json
{
  "option_id": "opt-003"
}
```

**Response:** `201 Created`
```json
{
  "vote_id": "vote-789",
  "option_id": "opt-003",
  "voted_at": "2025-01-12T11:30:00Z"
}
```

**Error Responses:**
- `404 Not Found` - Poll or option does not exist
- `400 Bad Request` - Invalid option_id or duplicate vote detected

---

## Authentication

### Admin Access
- Admin endpoints (poll creation) use magic link tokens
- Token passed as query parameter: `?token=<admin_token>`
- Tokens are single-use and expire after 24 hours

### Voter Access
- No authentication required
- Basic duplicate prevention via IP address tracking
- Rate limiting: 1 vote per IP per poll

## Error Format
All errors return consistent JSON structure:

```json
{
  "error": "Error message description",
  "code": "ERROR_CODE"
}
```
