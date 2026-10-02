# Story 3: See Results

## Status
✅ **SHIPPED**

## User Story
**As a** poll viewer  
**I want to** see current vote counts  
**So that** I know which snack is winning

## Acceptance Criteria
- [x] Results show all options with vote counts
- [x] Results update to reflect latest votes
- [x] Results are accessible via the same poll link
- [x] API endpoint: `GET /polls/:id`

## Technical Implementation

### API Endpoint
**GET /polls/:id**

**Response** (200 OK):
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
  "totalVotes": 28,
  "createdAt": "2024-01-15T10:00:00Z"
}
```

### Database Operations
1. Retrieve poll from `polls` table
2. Retrieve all options from `poll_options` table
3. Count votes for each option from `votes` table
4. Aggregate and return complete poll with vote counts

### SQL Query Pattern
```sql
SELECT 
    p.id,
    p.title,
    p.created_at,
    po.id as option_id,
    po.text as option_text,
    COUNT(v.id) as vote_count
FROM polls p
JOIN poll_options po ON p.id = po.poll_id
LEFT JOIN votes v ON po.id = v.option_id
WHERE p.id = ?
GROUP BY po.id
ORDER BY po.id;
```

### Validation Rules
- Poll ID: Must exist in database
- No authentication required to view results

### Error Responses

**404 Not Found** - Poll doesn't exist:
```json
{
  "error": "Poll not found",
  "code": "POLL_NOT_FOUND"
}
```

## Testing

### Unit Tests
- ✅ Retrieve poll with correct vote counts
- ✅ Return 404 for non-existent poll
- ✅ Handle poll with zero votes
- ✅ Calculate total votes correctly
- ✅ Include all options even with 0 votes

### Integration Tests
- ✅ GET /polls/:id returns 200 with valid poll ID
- ✅ GET /polls/:id returns 404 for invalid poll ID
- ✅ Vote counts update after POST /polls/:id/votes
- ✅ Results reflect real-time vote data
- ✅ Multiple concurrent GET requests handled correctly

### Manual Testing
- ✅ View results via API client
- ✅ Verify vote counts match database
- ✅ Refresh to see updated results
- ✅ Test with polls at various vote counts

## UI Components (if applicable)
- Poll title display
- Results list showing:
  - Each option name
  - Vote count per option
  - Visual indicator (bar chart, percentage)
- Total vote count
- Refresh button or auto-refresh indicator

## User Flow

### Initial View
1. User visits poll link (e.g., `/polls/abc123`)
2. System loads poll via `GET /polls/:id`
3. User sees poll question and current results
4. User can vote if they haven't yet

### Viewing Updates
1. User refreshes page manually
2. System fetches latest results via `GET /polls/:id`
3. Updated vote counts displayed
4. User sees which option is currently winning

### Real-Time Updates (Optional Enhancement)
- Client polls `GET /polls/:id` every 5-10 seconds
- Results update automatically without page refresh
- Visual animation when counts change

## Display Formats

### Simple List
```
Pizza: 5 votes
Tacos: 12 votes ⭐ (winning)
Sushi: 3 votes
Burgers: 8 votes

Total: 28 votes
```

### Percentage View
```
Pizza:    5 votes (18%)  ████░░░░░░
Tacos:   12 votes (43%)  ██████████ ⭐
Sushi:    3 votes (11%)  ██░░░░░░░░
Burgers:  8 votes (29%)  ██████░░░░

Total: 28 votes
```

### Visual Chart
- Horizontal bar chart
- Bars proportional to vote counts
- Highlight winning option
- Show percentages and absolute counts

## Performance Considerations
- Results query should complete in <200ms
- Efficient SQL with proper indexes
- Consider caching for high-traffic polls
- SQLite handles concurrent reads well

## Accessibility
- Results announced to screen readers
- Vote counts clearly labeled
- Visual indicators supplemented with text
- Keyboard navigation for interactive elements

## Notes
- Same endpoint used for both voting view and results view
- Results always show current state (no historical data)
- No pagination needed (polls have max 10 options)
- Consider adding sort options (by votes, alphabetical)
