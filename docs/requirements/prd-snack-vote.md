# PRD — Friday Snack Vote

## Overview
A lightweight internal tool for running Friday snack polls. Teams can create a poll with snack options, share a link, collect votes, and see results—all without requiring voter authentication.

## User Stories

### US-1: Admin Poll Creation
**As an admin**, I want to create a poll with snack options so that my team can vote on Friday snacks.

**Acceptance Criteria:**
- Admin can create a poll with a title
- Admin can add multiple snack options
- System generates a shareable link
- Admin receives a magic link for poll management

### US-2: Team Member Voting
**As a teammate**, I want to vote via a shared link without login so that I can quickly participate in the snack poll.

**Acceptance Criteria:**
- No authentication required to vote
- Can access poll via shared link
- Can select one snack option
- Can see current results after voting

## Scope
- **In Scope:**
  - Single poll creation
  - Anonymous voting
  - Real-time results display
  - Desktop web interface
  
- **Out of Scope:**
  - Multiple simultaneous polls
  - User accounts/profiles
  - Mobile app
  - Vote editing/deletion
  - Poll scheduling

## Success Metrics
- Poll creation time < 1 minute
- Vote submission time < 5 seconds
- Zero authentication friction for voters
