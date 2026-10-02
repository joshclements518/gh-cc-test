# User Flows - Friday Snack Vote

## Overview
This document describes the user interaction flows for the Friday Snack Vote application.

## Flow 1: Create a Poll

```mermaid
flowchart TD
    Start([Organizer wants to create poll])
    Input[Enter poll title and options]
    Submit[Submit poll creation request]
    Validate{Valid input?}
    Error[Show error message]
    Create[System creates poll]
    Generate[Generate unique poll ID]
    Display[Display shareable link]
    Share[Share link with team]
    End([Poll ready for voting])
    
    Start --> Input
    Input --> Submit
    Submit --> Validate
    Validate -->|No| Error
    Error --> Input
    Validate -->|Yes| Create
    Create --> Generate
    Generate --> Display
    Display --> Share
    Share --> End
```

### Steps
1. **Organizer accesses poll creation interface**
   - Opens application or API client
   - Navigates to poll creation

2. **Enter poll details**
   - Input: Poll title (e.g., "Friday Snack Choice")
   - Input: Multiple options (e.g., "Pizza", "Tacos", "Sushi")
   - Minimum 2 options required

3. **Submit poll**
   - Click submit/send POST request
   - System validates input

4. **Receive poll link**
   - System returns unique poll ID
   - Shareable URL displayed (e.g., `/polls/abc123xyz`)
   - Copy link to clipboard

5. **Share with team**
   - Send link via Slack, email, or other channels
   - Team members can now vote

---

## Flow 2: Vote on a Poll

```mermaid
flowchart TD
    Start([Receive poll link])
    Click[Click/open link]
    Load[System loads poll]
    Display[Display poll title and options]
    Review[Review options]
    Select[Select preferred option]
    Submit[Submit vote]
    Record[System records vote]
    Confirm[Show confirmation message]
    ViewResults[View current results]
    End([Vote complete])
    
    Start --> Click
    Click --> Load
    Load --> Display
    Display --> Review
    Review --> Select
    Select --> Submit
    Submit --> Record
    Record --> Confirm
    Confirm --> ViewResults
    ViewResults --> End
```

### Steps
1. **Receive poll link**
   - Team member receives link via communication channel
   - Example: `https://app.example.com/polls/abc123xyz`

2. **Access poll**
   - Click link or paste into browser
   - No login required

3. **View poll details**
   - Poll title displayed
   - All available options shown
   - Current vote counts visible (optional)

4. **Select option**
   - Choose one option from the list
   - Review choice before submitting

5. **Submit vote**
   - Click vote button or send POST request
   - System validates poll ID and option ID

6. **Receive confirmation**
   - Success message displayed
   - Vote count updates immediately

7. **View results** (optional)
   - See updated vote tallies
   - Compare option popularity

---

## Flow 3: View Poll Results

```mermaid
flowchart TD
    Start([Want to see results])
    Access[Access poll link]
    Load[System loads poll data]
    Fetch[Fetch current vote counts]
    Display[Display results]
    Review[Review vote distribution]
    Refresh{Want updated results?}
    Wait[Wait/refresh page]
    End([Results viewed])
    
    Start --> Access
    Access --> Load
    Load --> Fetch
    Fetch --> Display
    Display --> Review
    Review --> Refresh
    Refresh -->|Yes| Wait
    Wait --> Fetch
    Refresh -->|No| End
```

### Steps
1. **Access poll**
   - Open poll link (same link used for voting)
   - Can be accessed before or after voting

2. **View results**
   - Poll title displayed
   - Each option shows:
     - Option text
     - Current vote count
     - Percentage (if calculated by client)
   - Total vote count displayed

3. **Refresh for updates** (optional)
   - Reload page or re-fetch data
   - See latest vote counts
   - No automatic real-time updates

---

## User Journey Map

```mermaid
journey
    title Friday Snack Vote - Complete Journey
    section Poll Creation
      Open app: 5: Organizer
      Enter poll details: 4: Organizer
      Submit poll: 5: Organizer
      Copy share link: 5: Organizer
    section Sharing
      Send link to team: 5: Organizer
      Receive link: 5: Team Member
    section Voting
      Click link: 5: Team Member
      View options: 5: Team Member
      Select choice: 5: Team Member
      Submit vote: 5: Team Member
      See confirmation: 5: Team Member
    section Results
      View results: 5: Everyone
      Check winner: 5: Everyone
      Order snacks: 5: Organizer
```

---

## Error Handling Flows

### Invalid Poll ID
```mermaid
flowchart TD
    Access[User accesses poll link]
    Validate{Poll exists?}
    NotFound[Display 404 error]
    Message[Show helpful message]
    End([User notified])
    
    Access --> Validate
    Validate -->|No| NotFound
    NotFound --> Message
    Message --> End
```

**Error Message Example:**
```
Poll not found
The poll you're looking for doesn't exist or may have been deleted.
Please check the link and try again.
```

### Invalid Vote Submission
```mermaid
flowchart TD
    Submit[User submits vote]
    ValidatePoll{Poll exists?}
    ValidateOption{Option valid?}
    Error400[Show error message]
    Success[Record vote]
    End([Process complete])
    
    Submit --> ValidatePoll
    ValidatePoll -->|No| Error400
    ValidatePoll -->|Yes| ValidateOption
    ValidateOption -->|No| Error400
    ValidateOption -->|Yes| Success
    Error400 --> End
    Success --> End
```

**Error Message Examples:**
```
Invalid option selected
Please select a valid option from the list.

Poll not found
The poll you're trying to vote on doesn't exist.
```

---

## Interaction Patterns

### No Authentication Flow
- **Benefit**: Immediate access, no friction
- **Pattern**: Link-based access control
- **Security**: Obscure poll IDs prevent guessing

### Stateless Voting
- **Pattern**: Each vote is independent
- **No session**: No cookies or login state
- **Simplicity**: Single API call per action

### Results Polling
- **Pattern**: Client-initiated refresh
- **No push**: Server doesn't push updates
- **Trade-off**: Not real-time, but simpler implementation

---

## Accessibility Considerations

### Keyboard Navigation
- All interactive elements should be keyboard accessible
- Tab order should be logical (title → options → submit)

### Screen Readers
- Poll title should be announced
- Options should be clearly labeled
- Vote confirmation should be announced

### Mobile Responsiveness
- Links should work on mobile devices
- Touch targets should be appropriately sized
- Layout should adapt to small screens

---

## Performance Expectations

### Page Load Times
- Poll creation: < 500ms
- Poll loading: < 300ms
- Vote submission: < 300ms
- Results refresh: < 200ms

### User Feedback
- Immediate visual feedback on interactions
- Loading indicators for async operations
- Clear success/error messages
