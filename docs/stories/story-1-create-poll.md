# Story 1: Create Poll

## Status
✅ **SHIPPED**

## User Story
**As a** poll creator  
**I want to** create a new snack poll with multiple options  
**So that** team members can vote on their preferred Friday snack

## Acceptance Criteria
- [x] Poll has a title/question
- [x] Poll supports multiple snack options (2-10)
- [x] System generates a unique poll ID
- [x] System returns a shareable link for voting
- [x] API endpoint: `POST /polls`

## Technical Implementation

### API Endpoint
**POST /polls**

**Request**:
```json
{
  "title": "What snack should we get this Friday?",
  "options": ["Pizza", "Tacos", "Sushi", "Burgers"]
}
```

**Response** (201 Created):
```json
{
  "id": "abc123",
  "title": "What snack should we get this Friday?",
  "options": [
    {"id": "opt1", "text": "Pizza", "votes": 0},
    {"id": "opt2", "text": "Tacos", "votes": 0},
    {"id": "opt3", "text": "Sushi", "votes": 0},
    {"id": "opt4", "text": "Burgers", "votes": 0}
  ],
  "createdAt": "2024-01-15T10:00:00Z",
  "link": "/polls/abc123"
}
```

### Database Operations
1. Generate unique poll ID
2. Insert poll record into `polls` table
3. Insert each option into `poll_options` table
4. Return complete poll object

### Validation Rules
- Title: Required, 1-200 characters
- Options: Required, 2-10 options
- Option text: Required, 1-100 characters each
- No duplicate option text within same poll

### Error Responses

**400 Bad Request** - Invalid input:
```json
{
  "error": "Title is required",
  "code": "MISSING_TITLE"
}
```

**400 Bad Request** - Too few options:
```json
{
  "error": "Poll must have at least 2 options",
  "code": "INSUFFICIENT_OPTIONS"
}
```

**400 Bad Request** - Too many options:
```json
{
  "error": "Poll cannot have more than 10 options",
  "code": "TOO_MANY_OPTIONS"
}
```

## Testing

### Unit Tests
- ✅ Validate poll creation with valid input
- ✅ Reject poll with missing title
- ✅ Reject poll with < 2 options
- ✅ Reject poll with > 10 options
- ✅ Generate unique IDs for each poll
- ✅ Initialize all options with 0 votes

### Integration Tests
- ✅ POST /polls returns 201 with valid data
- ✅ POST /polls returns 400 with invalid data
- ✅ Created poll is retrievable via GET /polls/:id
- ✅ Poll options are stored correctly in database

### Manual Testing
- ✅ Create poll via API client (Postman/curl)
- ✅ Verify shareable link format
- ✅ Verify poll appears in database

## UI Components (if applicable)
- Poll creation form
- Title input field
- Dynamic option input fields
- Add/remove option buttons
- Create poll button
- Shareable link display with copy button

## Notes
- Poll IDs use short alphanumeric format for clean URLs
- Option IDs generated server-side for consistency
- Timestamps stored in UTC
- No authentication required for poll creation
