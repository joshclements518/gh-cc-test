# ADR 001: SQLite Database with No Authentication

**Status**: Accepted  
**Epic**: #101 — Friday Snack Vote  
**Date**: 2024

## Context

We need to build a simple poll application for Friday snack voting. The application needs to:
- Store poll questions and options
- Record votes
- Display results
- Be quick to implement and deploy
- Work for a small team

## Decision

We will use **SQLite as the database** and implement **no authentication system**.

### Database Choice: SQLite

**Rationale:**
- File-based database requires zero configuration
- No separate database server to manage
- Sufficient performance for expected load (small team, occasional polls)
- Built-in to most programming environments
- Easy to backup (single file)
- Supports SQL with ACID guarantees

**Trade-offs:**
- Limited concurrent write performance (acceptable for our use case)
- Single-server deployment (no distributed database)
- File-based means no network database access

### Authentication: None

**Rationale:**
- Reduces implementation complexity significantly
- No user management, password storage, or session handling needed
- Lower friction for voters (no login required)
- Acceptable for low-stakes internal polls
- Faster time-to-market

**Trade-offs:**
- No vote attribution to specific users
- No prevention of duplicate votes from same person
- No access control on poll creation
- Cannot implement features like "edit my vote" or "my polls"

## Consequences

### Positive
- Rapid development and deployment
- Simple architecture with fewer moving parts
- Easy for users to participate (just click link and vote)
- Minimal operational overhead

### Negative
- Cannot prevent vote manipulation (same person voting multiple times)
- No audit trail of who voted
- Cannot implement user-specific features later without migration

### Mitigation
- For MVP, accept the limitations as reasonable for internal team polls
- If abuse becomes an issue, can add basic authentication in future iteration
- Document the limitation in user-facing materials

## Alternatives Considered

### PostgreSQL + OAuth
- **Pros**: Scalable, proper user management, prevents duplicate votes
- **Cons**: Much more complex, slower to implement, requires infrastructure
- **Rejected**: Overkill for MVP scope

### In-memory storage (no persistence)
- **Pros**: Even simpler than SQLite
- **Cons**: Lose all data on restart, not acceptable for real use
- **Rejected**: Need persistence for polls to be useful

### Cookie-based vote tracking
- **Pros**: Prevents accidental duplicate votes without full auth
- **Cons**: Easily bypassed, adds complexity
- **Deferred**: Could add later if needed, but not for MVP
