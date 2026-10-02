# PRD — Friday Snack Vote

## Overview
A simple polling application for Friday snack voting that allows users to create polls, vote via shareable links, and view results in real-time.

## User Stories (Shipped)

### Story 1: Create Poll
**As a** poll creator  
**I want to** create a new snack poll  
**So that** team members can vote on Friday snack options

**Acceptance Criteria:**
- User can submit poll with title and multiple options
- System generates unique poll ID
- System returns shareable poll link

### Story 2: Vote via Link
**As a** voter  
**I want to** vote on a poll via a shared link  
**So that** I can express my snack preference

**Acceptance Criteria:**
- User can access poll via unique link
- User can select one option from available choices
- Vote is recorded without authentication
- User receives confirmation of vote

### Story 3: See Results
**As a** poll viewer  
**I want to** see current poll results  
**So that** I can see which snack is winning

**Acceptance Criteria:**
- Display all poll options with vote counts
- Results update to reflect latest votes
- Results accessible via poll link

## Technical Requirements
- No voter authentication required
- SQLite database for persistence
- RESTful API endpoints
- Simple, lightweight implementation

## Out of Scope
- User authentication
- Vote modification/deletion
- Poll expiration
- Multiple votes per user prevention
- Real-time WebSocket updates
