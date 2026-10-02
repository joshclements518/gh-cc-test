# ADR 002: No Voter Authentication Required

## Status
Accepted

## Context
The Friday Snack Vote application allows team members to vote on snack options. We need to decide whether to require voter authentication and identity verification.

## Decision
We will **not require authentication** for voters. Anyone with a poll link can vote without logging in or providing credentials.

## Rationale

### Advantages
1. **Simplicity**: No user management, password handling, or session management
2. **Friction-Free Experience**: Voters can participate immediately without signup/login
3. **Faster Development**: Eliminates entire authentication subsystem
4. **Lower Maintenance**: No password resets, account recovery, or user support
5. **Privacy-Friendly**: No personal data collection or storage required

### Trade-offs
1. **Vote Manipulation Risk**: Same person could vote multiple times
   - **Mitigation**: Optional IP-based rate limiting, honor system for internal team use
2. **No Voter Attribution**: Cannot track who voted for what
   - **Mitigation**: Not required for use case—only aggregate results matter
3. **No Vote Editing**: Cannot allow users to change their vote (no identity to verify)
   - **Mitigation**: Acceptable for simple snack polls

## Alternatives Considered

### Email-Based Authentication
- **Pros**: Simple identity verification, prevents duplicate votes
- **Cons**: Requires email collection, verification flow, adds friction
- **Verdict**: Too much overhead for casual team polls

### OAuth (Google/GitHub)
- **Pros**: No password management, leverages existing accounts
- **Cons**: Requires OAuth setup, external dependencies, overkill for use case
- **Verdict**: Unnecessary complexity for internal tool

### Magic Links (Passwordless)
- **Pros**: No passwords, relatively simple
- **Cons**: Still requires email collection and verification flow
- **Verdict**: Adds friction without significant benefit

### IP-Based Tracking Only
- **Pros**: Passive, no user action required
- **Cons**: Not reliable (shared IPs, VPNs), false positives
- **Verdict**: Could be added as optional mitigation, but not primary solution

## Consequences

### Positive
- Extremely low barrier to participation
- No GDPR/privacy concerns from storing user data
- Minimal application complexity
- Fast development and deployment
- No authentication-related bugs or security vulnerabilities

### Negative
- Vulnerable to vote manipulation (acceptable risk for internal team use)
- Cannot implement "one vote per person" guarantee
- Cannot provide personalized experiences or vote history
- Cannot allow vote changes (no way to verify voter identity)

### Neutral
- Trust-based system relies on team culture and good faith
- Suitable for low-stakes decisions (snack choices)
- Not suitable for high-stakes or formal voting scenarios

## Implementation Notes
- Document the trust-based model in user-facing documentation
- Consider optional IP-based rate limiting to discourage abuse
- Log votes with timestamps for audit purposes (without PII)
- Could add authentication later if abuse becomes problematic

## Review Criteria
This decision should be revisited if:
- Vote manipulation becomes a problem
- Polls are used for higher-stakes decisions
- Users request ability to change their votes
- Compliance requirements change
