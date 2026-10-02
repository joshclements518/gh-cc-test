# Functional Requirements - Friday Snack Vote

## Overview
The Friday Snack Vote application enables teams to create polls, collect votes via shareable links, and view results in real-time.

## User Stories

### Story 1: Create Poll
**As a** team organizer  
**I want to** create a poll with multiple snack options  
**So that** team members can vote on their preferences

#### Acceptance Criteria
- [ ] User can submit a poll title
- [ ] User can add multiple options (minimum 2)
- [ ] System generates a unique poll ID
- [ ] System returns a shareable link to the poll
- [ ] Poll is persisted in the database

#### API Endpoint
`POST /polls`

---

### Story 2: Vote via Link
**As a** team member  
**I want to** vote by clicking a link  
**So that** I can quickly indicate my snack preference

#### Acceptance Criteria
- [ ] User can access poll via shareable link
- [ ] User can select one option from the available choices
- [ ] Vote is recorded immediately
- [ ] User receives confirmation of vote submission
- [ ] No login or authentication required

#### API Endpoint
`POST /polls/:id/votes`

---

### Story 3: See Results
**As a** team member  
**I want to** see current vote counts  
**So that** I know which snack is most popular

#### Acceptance Criteria
- [ ] User can view poll title and all options
- [ ] Each option displays current vote count
- [ ] Total vote count is displayed
- [ ] Results update to reflect latest votes
- [ ] Results are accessible via the same poll link

#### API Endpoint
`GET /polls/:id`

---

## Functional Requirements

### FR-1: Poll Creation
- **FR-1.1**: System shall accept poll creation requests with title and options
- **FR-1.2**: System shall validate that at least 2 options are provided
- **FR-1.3**: System shall generate a unique, non-guessable poll ID
- **FR-1.4**: System shall store poll data in SQLite database
- **FR-1.5**: System shall return poll ID and shareable URL

### FR-2: Vote Submission
- **FR-2.1**: System shall accept votes for valid poll IDs
- **FR-2.2**: System shall validate that option_id exists for the poll
- **FR-2.3**: System shall record vote timestamp
- **FR-2.4**: System shall increment vote count for selected option
- **FR-2.5**: System shall return success confirmation

### FR-3: Results Retrieval
- **FR-3.1**: System shall return poll details for valid poll IDs
- **FR-3.2**: System shall calculate and return vote counts per option
- **FR-3.3**: System shall return total vote count
- **FR-3.4**: System shall return poll creation timestamp
- **FR-3.5**: System shall return 404 for non-existent poll IDs

### FR-4: Data Persistence
- **FR-4.1**: All polls shall be stored persistently in SQLite
- **FR-4.2**: All votes shall be stored persistently
- **FR-4.3**: Data shall survive application restarts

## Non-Functional Requirements

### NFR-1: Performance
- **NFR-1.1**: Poll creation shall complete within 500ms
- **NFR-1.2**: Vote submission shall complete within 300ms
- **NFR-1.3**: Results retrieval shall complete within 200ms

### NFR-2: Availability
- **NFR-2.1**: System shall be available during business hours
- **NFR-2.2**: Database file shall be backed up regularly

### NFR-3: Usability
- **NFR-3.1**: API responses shall use clear, descriptive JSON
- **NFR-3.2**: Error messages shall be informative
- **NFR-3.3**: No authentication required for voting

### NFR-4: Security
- **NFR-4.1**: Poll IDs shall be sufficiently random to prevent enumeration
- **NFR-4.2**: Input validation shall prevent SQL injection
- **NFR-4.3**: API shall handle malformed requests gracefully

### NFR-5: Scalability
- **NFR-5.1**: System shall support at least 100 concurrent voters
- **NFR-5.2**: System shall handle polls with up to 20 options
- **NFR-5.3**: Database shall support at least 10,000 votes

## Out of Scope

The following features are explicitly out of scope for the initial release:
- User authentication or login
- Vote editing or deletion
- Poll expiration or closing
- Results visualization (charts/graphs)
- Email notifications
- Poll templates
- Multi-language support
- Mobile native apps
- Real-time WebSocket updates
- Vote anonymization guarantees
- Duplicate vote prevention (beyond basic measures)

## Future Enhancements

Potential features for future iterations:
- Poll closing/expiration dates
- Results export (CSV, PDF)
- Visual charts and graphs
- Poll templates for common scenarios
- Admin dashboard
- Vote editing within time window
- IP-based duplicate vote detection
