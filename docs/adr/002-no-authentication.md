# ADR 002: No Voter Authentication

## Status
Accepted

## Context
The Friday Snack Vote application needs to allow team members to vote on snack preferences. We must decide whether to implement user authentication and identity verification for voters.

## Decision
We will NOT implement voter authentication. Access to polls will be controlled solely through shareable links containing poll IDs.

## Rationale

### Advantages
1. **Frictionless Voting**: No login required; users can vote immediately via link
2. **Simplified Implementation**: No authentication system, user management, or session handling
3. **Privacy**: No tracking of individual voter identities
4. **Quick Adoption**: Lower barrier to participation
5. **Reduced Complexity**: Fewer security concerns, no password management

### Trade-offs
1. **No Vote Attribution**: Cannot track who voted for what
2. **Duplicate Voting**: Same person could vote multiple times (if not prevented by other means)
3. **Poll Discovery**: Anyone with the link can access and vote
4. **No Access Revocation**: Cannot remove specific users from polls

## Consequences

### Positive
- Faster development and deployment
- Better user experience (no login friction)
- No personal data storage or GDPR concerns
- Simpler codebase and maintenance

### Negative
- Trust-based system (relies on team honesty)
- No audit trail of individual votes
- Potential for abuse (link sharing outside team)
- Cannot implement per-user vote limits without additional mechanisms

## Mitigation Strategies

### Poll ID Obscurity
- Use sufficiently long, random poll IDs to prevent guessing
- Makes unauthorized access unlikely without the link

### Optional Future Enhancements
- IP-based rate limiting (if abuse occurs)
- Browser fingerprinting for duplicate vote detection
- Optional "sign your vote" feature for transparency

## Alternatives Considered

### OAuth/SSO Integration
- **Pros**: Verified identities, audit trail, access control
- **Cons**: Complex implementation, requires external provider, login friction

### Simple Password Protection
- **Pros**: Basic access control
- **Cons**: Password sharing issues, still no individual attribution

### Email-Based Verification
- **Pros**: One vote per email address
- **Cons**: Requires email collection, verification flow adds friction

## Use Case Alignment
This decision aligns with the informal, trust-based nature of team snack voting. The goal is quick consensus gathering, not formal elections requiring strict identity verification.

## Review Criteria
This decision should be revisited if:
- Abuse or duplicate voting becomes problematic
- Audit requirements change
- The application expands beyond internal team use
