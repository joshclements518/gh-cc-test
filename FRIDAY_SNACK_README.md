# Friday Snack Vote

A simple poll application for teams to vote on Friday snacks.

## Features

- Admin can create polls with multiple snack options
- Team members vote via shareable link (no login required)
- One poll, one winner
- Polls automatically close at specified time

## Architecture

- **Backend**: Node.js + Express
- **Database**: SQLite
- **Frontend**: Vanilla HTML/CSS/JavaScript

## Installation

```bash
npm install
```

## Usage

### Start the server

```bash
npm start
```

The application will be available at `http://localhost:3000`

### Create a poll

1. Visit the home page at `http://localhost:3000`
2. Enter poll title, snack options, and closing time
3. Click "Create Poll" to generate a shareable link
4. Share the link with your team

### Vote on a poll

1. Click the shared link (e.g., `http://localhost:3000/vote/abc123`)
2. Select your preferred snack option
3. Click "Submit Vote"

## API Endpoints

### POST /api/polls
Create a new poll

**Request body:**
```json
{
  "title": "What snack for Friday?",
  "options": ["Pizza", "Tacos", "Sushi"],
  "closesAt": "2026-10-09T17:00:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "pollId": 1,
  "shareToken": "abc123-def456",
  "shareUrl": "http://localhost:3000/vote/abc123-def456"
}
```

### GET /api/polls/:shareToken
Get poll details

**Response:**
```json
{
  "id": 1,
  "title": "What snack for Friday?",
  "shareToken": "abc123-def456",
  "closesAt": "2026-10-09T17:00:00Z",
  "options": [
    { "id": 1, "pollId": 1, "text": "Pizza" },
    { "id": 2, "pollId": 1, "text": "Tacos" }
  ]
}
```

### POST /api/polls/:shareToken/vote
Submit a vote

**Request body:**
```json
{
  "optionId": 1
}
```

**Response:**
```json
{
  "success": true,
  "voteId": 1
}
```

### GET /api/polls/:shareToken/results
Get poll results

**Response:**
```json
{
  "poll": { ... },
  "results": [
    { "id": 1, "text": "Pizza", "voteCount": 5 },
    { "id": 2, "text": "Tacos", "voteCount": 3 }
  ]
}
```

## Testing

```bash
npm test
```

## Linting

```bash
npm run lint
```
