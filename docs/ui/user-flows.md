# User Flows — Friday Snack Vote

## Admin Flow: Create Poll

```mermaid
sequenceDiagram
    actor Admin
    participant UI as Admin UI
    participant API as Node API
    participant DB as SQLite
    
    Admin->>UI: Navigate to create page
    Admin->>UI: Enter poll title
    Admin->>UI: Add snack options
    Admin->>UI: Click "Create Poll"
    UI->>API: POST /polls
    API->>DB: Insert poll + options
    DB-->>API: Poll created
    API-->>UI: Poll ID + URLs
    UI->>Admin: Display share link + admin link
    Admin->>Admin: Copy share link
    Admin->>Admin: Share with team
```

## Voter Flow: Cast Vote

```mermaid
sequenceDiagram
    actor Voter
    participant UI as Vote UI
    participant API as Node API
    participant DB as SQLite
    
    Voter->>UI: Click shared link
    UI->>API: GET /polls/:id
    API->>DB: Fetch poll + options + counts
    DB-->>API: Poll data
    API-->>UI: Poll details
    UI->>Voter: Display options + current results
    Voter->>UI: Select snack option
    Voter->>UI: Click "Vote"
    UI->>API: POST /polls/:id/votes
    API->>DB: Check IP duplicate
    alt First vote from IP
        API->>DB: Insert vote
        DB-->>API: Vote recorded
        API-->>UI: Success
        UI->>Voter: Show updated results
    else Duplicate IP
        API-->>UI: 400 Error
        UI->>Voter: "Already voted" message
    end
```

## Results View Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as Results UI
    participant API as Node API
    participant DB as SQLite
    
    User->>UI: View poll page
    UI->>API: GET /polls/:id
    API->>DB: Fetch poll + vote counts
    DB-->>API: Aggregated results
    API-->>UI: Results data
    UI->>User: Display bar chart
    
    Note over UI,User: Auto-refresh every 5s
    
    loop Every 5 seconds
        UI->>API: GET /polls/:id
        API->>DB: Fetch updated counts
        DB-->>API: Current results
        API-->>UI: Updated data
        UI->>User: Refresh chart
    end
```

## UI Screens

### 1. Poll Creation (Admin)
**URL:** `/admin?token=<magic_token>`

**Elements:**
- Poll title input field
- Dynamic option list (add/remove)
- "Create Poll" button
- Generated share link (after creation)
- Copy-to-clipboard button

### 2. Voting Interface (Public)
**URL:** `/polls/:id`

**Elements:**
- Poll title
- Radio button list of options
- Current vote count per option (bar chart)
- "Submit Vote" button
- Total votes counter

### 3. Results Display
**URL:** `/polls/:id` (after voting or direct access)

**Elements:**
- Poll title
- Horizontal bar chart showing:
  - Option name
  - Vote count
  - Percentage bar
- Winner highlight (most votes)
- Total votes
- Auto-refresh indicator

## Interaction Patterns

### Vote Submission
1. User selects option (radio button)
2. "Submit Vote" button enables
3. Click triggers API call
4. Loading spinner during submission
5. Success: Chart updates with animation
6. Error: Toast notification with message

### Real-time Updates
- Results refresh every 5 seconds via polling
- Smooth bar chart transitions
- New votes appear without page reload

### Mobile Considerations
- Touch-friendly radio buttons (min 44px)
- Responsive bar chart
- Single-column layout on mobile
- Large, tappable vote button
