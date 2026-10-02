# ADR 002: No Voter Authentication

## Status
Accepted

## Context
The Friday Snack Vote application allows users to vote on poll options. We need to decide whether to implement user authentication and identity verification for voters.

## Decision
We will NOT implement voter authentication. Voting will be completely anonymous and open to anyone with the poll link.

## Rationale

### Advantages
1. **Simplified User Experience**: No login, registration, or password management
2. **Faster Development**: Eliminates authentication infrastructure and session management
3. **Lower Friction**: Users can vote immediately without barriers
4. **Appropriate for Use Case**: Low-stakes internal polls don't require identity verification
5. **Privacy-Friendly**: No personal data collection or storage

### Trade-offs
1. **No Duplicate Prevention**: Same person can vote multiple times
2. **No Vote Attribution**: Cannot track who voted for what
3. **Potential for Abuse**: Poll links can be shared externally
4. **No Vote Modification**: Users cannot change their vote (no identity to associate with)

## Alternatives Considered

### Email-Based Authentication
- **Pros**: Simple identity verification, prevents some duplicate voting
- **Cons**: Requires email collection, adds friction, still bypassable with multiple emails
- **Verdict**: Too much complexity for internal snack polls

### OAuth (Google/GitHub)
- **Pros**: No password management, leverages existing accounts
- **Cons**: Requires OAuth setup, adds significant complexity, overkill for use case
- **Verdict**: Inappropriate for simple polling

### IP-Based Tracking
- **Pros**: Passive duplicate detection
- **Cons**: Unreliable (shared IPs, VPNs), privacy concerns, easy to bypass
- **Verdict**: False sense of security without real benefit

### Cookie-Based Tracking
- **Pros**: Simple client-side duplicate prevention
- **Cons**: Easily bypassed (clear cookies, incognito mode), not true authentication
- **Verdict**: Minimal value, adds complexity

## Consequences

### Positive
- Minimal development effort
- Zero authentication infrastructure or dependencies
- Instant voting experience
- No user data to secure or manage
- No GDPR/privacy compliance concerns for user accounts

### Negative
- Poll results may be skewed by duplicate votes
- No audit trail of who voted
- Cannot implement features requiring identity (vote editing, user-specific views)
- Polls can be accessed by anyone with the link

### Mitigation
- Clearly communicate that polls are informal and non-binding
- Use for low-stakes decisions only (snack choices, meeting times)
- If duplicate voting becomes a problem, can add simple client-side tracking as a deterrent
- For important decisions, use a different tool with proper authentication

## Notes
This decision aligns with the "Friday snack poll" use case where:
- Stakes are low (choosing snacks)
- Trust level is high (internal team)
- Convenience is valued over security
- Speed of voting matters more than vote integrity

If the application scope expands to more critical decisions, this decision should be revisited.
