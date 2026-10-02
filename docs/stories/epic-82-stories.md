# Epic 82 Stories — Friday Snack Vote

Ordered implementation stories for the internal Friday snack polling application.

## Architecture Context

From epic #82:
- **ADR-001**: Poll + Vote data stored in app database
- ShareToken used in public voting links
- Small REST API under `/api/polls`

## Implementation Order

### 1. Database Foundation (Story #84)
**Database schema and models for Poll and Vote**

Create the data layer with:
- `Poll` table: id, title, options (JSON array), shareToken (unique), closesAt, createdAt
- `Vote` table: id, pollId (FK), selectedOption, votedAt
- Database models/ORM entities
- Basic validations and constraints

**Why first**: All other stories depend on the data layer.

---

### 2. Create Poll API (Story #85)
**REST API endpoint to create a poll**

Implement `POST /api/polls`:
- Accept: title, options array, closesAt
- Generate unique shareToken
- Return: poll object with shareToken
- Include share URL in response

**Dependencies**: Story #84

---

### 3. Fetch Poll API (Story #86)
**REST API endpoint to fetch poll by shareToken**

Implement `GET /api/polls/:shareToken`:
- Lookup poll by shareToken
- Return poll details with options
- Handle not-found and expired cases

**Dependencies**: Story #84

---

### 4. Vote Submission API (Story #87)
**REST API endpoint to submit a vote**

Implement `POST /api/polls/:shareToken/vote`:
- Accept: selectedOption
- Validate poll is open (not past closesAt)
- Create vote record
- Return success/error states

**Dependencies**: Story #84, #86

---

### 5. Admin Create UI (Story #88)
**Admin UI to create a poll**

Build admin form:
- Input: title field
- Dynamic options list (add/remove)
- DateTime picker for closesAt
- Submit → show share URL on success
- Error handling

**Dependencies**: Story #85

---

### 6. Voter UI (Story #89)
**Voter UI to view and vote on a poll**

Build voting interface:
- Load poll via shareToken from URL
- Display title and options
- Single-choice selection
- Submit vote button
- States: loading, error, poll expired, vote submitted

**Dependencies**: Story #86, #87

---

### 7. Build Order Notes (Story #90)
**Build Order Notes**

Final integration notes and any deployment considerations.

**Dependencies**: All previous stories

---

## Testing Strategy

Each story should include:
- Unit tests for models/utilities
- API integration tests for endpoints
- Component tests for UI stories
- Manual smoke test before PR

## Technical Notes

- Use existing repo conventions for database ORM, API routing, and UI framework
- ShareToken generation: crypto-random string (e.g., 12-character alphanumeric)
- Validation: poll must have 2+ options, closesAt must be future date
- No authentication required for voting (public link access)
- Admin creation may use existing auth or be open (clarify based on codebase)
