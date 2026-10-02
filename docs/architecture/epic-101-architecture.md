# Architecture — Friday Snack Vote

**Epic**: #101  
**Status**: Implemented

## Technology Stack

- **Database**: SQLite (file-based, no auth required)
- **Backend**: REST API
- **Frontend**: Mobile-first web UI

## Database Schema

### Tables

#### `polls`
- `id` (INTEGER PRIMARY KEY)
- `question` (TEXT NOT NULL)
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

#### `poll_options`
- `id` (INTEGER PRIMARY KEY)
- `poll_id` (INTEGER FOREIGN KEY → polls.id)
- `option_text` (TEXT NOT NULL)
- `display_order` (INTEGER)

#### `votes`
- `id` (INTEGER PRIMARY KEY)
- `poll_id` (INTEGER FOREIGN KEY → polls.id)
- `option_id` (INTEGER FOREIGN KEY → poll_options.id)
- `voted_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

## API Endpoints

### POST /polls
Create a new poll.

**Request Body:**
```json
{
  "question": "What snack should we get for Friday?",
  "options": ["Pizza", "Tacos", "Sushi", "Burgers"]
}
```

**Response:**
```json
{
  "id": 1,
  "question": "What snack should we get for Friday?",
  "share_url": "/polls/1"
}
```

### GET /polls/:id
Retrieve poll data and current vote counts.

**Response:**
```json
{
  "id": 1,
  "question": "What snack should we get for Friday?",
  "options": [
    {
      "id": 1,
      "text": "Pizza",
      "votes": 5
    },
    {
      "id": 2,
      "text": "Tacos",
      "votes": 3
    },
    {
      "id": 3,
      "text": "Sushi",
      "votes": 7
    },
    {
      "id": 4,
      "text": "Burgers",
      "votes": 2
    }
  ],
  "total_votes": 17
}
```

### POST /polls/:id/votes
Submit a vote for a poll option.

**Request Body:**
```json
{
  "option_id": 3
}
```

**Response:**
```json
{
  "success": true,
  "poll_id": 1,
  "option_id": 3
}
```

## Design Decisions

### Why SQLite?
- No authentication required means no user management complexity
- File-based database is simple to deploy and maintain
- Sufficient for expected load (small team, Friday polls)
- Zero configuration required

### Why No Authentication?
- Keeps scope minimal for MVP
- Reduces friction for voters (no login required)
- Acceptable for low-stakes internal polls
- Can be added later if needed

### API Design
- RESTful endpoints for simplicity
- JSON request/response for easy frontend integration
- Minimal validation (question + 2+ options)
- Vote counts calculated on-demand via SQL aggregation
