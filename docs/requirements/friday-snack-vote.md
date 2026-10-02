# Requirements: Friday Snack Vote

## Overview
A simple polling application to vote on Friday snacks. Users can create polls, vote via shareable links, and view results in real-time.

## User Stories

### Story 1: Create Poll
**As a** poll creator  
**I want to** create a new snack poll with multiple options  
**So that** team members can vote on their preferred Friday snack

**Acceptance Criteria:**
- Poll has a title/question
- Poll supports multiple snack options
- System generates a unique poll ID
- System returns a shareable link for voting

### Story 2: Vote via Link
**As a** voter  
**I want to** click a poll link and cast my vote  
**So that** I can participate in choosing the Friday snack

**Acceptance Criteria:**
- Voters can access poll via unique link
- Voters can select one snack option
- No authentication required
- Vote is recorded immediately

### Story 3: See Results
**As a** poll viewer  
**I want to** see current vote counts  
**So that** I know which snack is winning

**Acceptance Criteria:**
- Results show all options with vote counts
- Results update to reflect latest votes
- Results are accessible via the same poll link

## Non-Functional Requirements

### Performance
- Poll creation responds within 500ms
- Vote submission responds within 300ms
- Results retrieval responds within 200ms

### Scalability
- Support up to 100 concurrent voters per poll
- Support up to 1000 total polls

### Security
- No authentication required (intentional for simplicity)
- Basic input validation on poll creation
- Rate limiting to prevent vote spam

### Data Persistence
- Polls persist indefinitely
- Votes are immutable once cast
