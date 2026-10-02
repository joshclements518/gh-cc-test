# Story 2: Vote via Link

## Status
✅ **SHIPPED**

## User Story
**As a** voter  
**I want to** click a poll link and cast my vote  
**So that** I can participate in choosing the Friday snack

## Acceptance Criteria
- [x] Voters can access poll via unique link
- [x] Voters can select one snack option
- [x] No authentication required
- [x] Vote is recorded immediately
- [x] API endpoint: `POST /polls/:id/votes`

## Technical Implementation

### API Endpoint
**POST /polls/:id/votes**

**Request**:
```json
{
  "optionId": "opt2"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "pollId": "abc123",
  "optionId": "opt2"
}
```

### Database Operations
1. Verify poll exists
2. Verify option belongs to poll
3. Insert vote record into `votes` table
4. Return success confirmation

### Validation Rules
- Poll ID: Must exist in database
- Option ID: Must exist and belong to specified poll
- No voter authentication required (by design)
- Multiple votes from same source allowed (no enforcement)

### Error Responses

**404 Not Found** - Poll doesn't exist:
```json
{
  "error": "Poll not found",
  "code": "POLL_NOT_FOUND"
}
```

**400 Bad Request** - Invalid option:
```json
{
  "error": "Invalid option for this poll",
  "code": "INVALID_OPTION"
}
```

**400 Bad Request** - Missing option ID:
```json
{
  "error": "Option ID is required",
  "code": "MISSING_OPTION_ID"
}
```

## Testing

### Unit Tests
- ✅ Record vote with valid poll and option
- ✅ Reject vote for non-existent poll
- ✅ Reject vote for invalid option
- ✅ Reject vote with missing option ID
- ✅ Vote timestamp recorded correctly

### Integration Tests
- ✅ POST /polls/:id/votes returns 200 with valid data
- ✅ POST /polls/:id/votes returns 404 for invalid poll
- ✅ POST /polls/:id/votes returns 400 for invalid option
- ✅ Vote increments count in GET /polls/:id response
- ✅ Multiple votes can be cast on same poll

### Manual Testing
- ✅ Submit vote via API client
- ✅ Verify vote appears in database
- ✅ Verify vote count increases in results
- ✅ Test with various poll/option combinations

## UI Components (if applicable)
- Poll display with title and options
- Radio button group for option selection
- Vote button (primary action)
- Success message after voting
- Results display after vote submission

## User Flow
1. User receives poll link (e.g., `/polls/abc123`)
2. User clicks link to open poll
3. Poll loads via `GET /polls/:id`
4. User sees poll question and options
5. User selects preferred option (radio button)
6. User clicks "Vote" button
7. System submits `POST /polls/:id/votes`
8. System shows success message
9. Results update to reflect new vote

## Security Considerations
- **No authentication**: Intentional design decision (see ADR 002)
- **Vote manipulation**: Possible but acceptable for internal team use
- **Rate limiting**: Optional IP-based throttling to discourage abuse
- **Input validation**: Prevent SQL injection, validate option IDs

## Performance Considerations
- Vote submission should complete in <300ms
- Database write operation is fast (single INSERT)
- Consider connection pooling for concurrent votes
- SQLite handles concurrent writes via locking

## Notes
- Votes are immutable once cast (no edit/delete)
- No voter identity stored (privacy-friendly)
- Vote timestamps recorded for audit purposes
- Same user can vote multiple times (no prevention mechanism)
