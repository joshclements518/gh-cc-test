# ADR-002: No Authentication for Voters

## Status
Accepted

## Context
The Friday Snack Vote application needs to balance ease of participation with basic integrity. The target users are internal team members voting on snack preferences.

## Decision
Implement no authentication for voters. Use IP-based duplicate prevention and admin-only magic links.

## Rationale

### Voter Experience
- **Friction-Free:** Click link → vote → done (< 10 seconds)
- **No Barriers:** No signup, login, or password management
- **Mobile-Friendly:** Works on any device without app installation

### Security Posture
- **Low Stakes:** Snack poll results have minimal security impact
- **Internal Use:** Shared within trusted team environment
- **Basic Prevention:** IP tracking prevents casual duplicate voting

### Admin Control
- **Magic Links:** Secure, time-limited admin access
- **Single-Use Tokens:** Prevent token reuse
- **Email Delivery:** Admin link sent to verified email

## Implementation Details

### Duplicate Prevention
```
- Track voter IP address per poll
- Allow 1 vote per IP per poll
- Store IP as hashed value for privacy
```

### Admin Authentication
```
- Generate secure random token on poll creation
- Token valid for 24 hours
- Token grants access to poll management UI
```

## Alternatives Considered

### OAuth/SSO
- **Rejected:** Too much friction for quick internal poll
- **Complexity:** Requires provider setup and user consent flow

### Email Verification
- **Rejected:** Adds delay and friction to voting process
- **User Experience:** Requires email access during voting

### Browser Fingerprinting
- **Rejected:** Privacy concerns and unreliable across devices
- **Complexity:** Requires client-side tracking library

## Consequences
- Extremely low friction for voters
- Possible duplicate votes from different IPs (acceptable risk)
- Cannot track individual voter identity (feature, not bug)
- Simple implementation and maintenance
- May need to add captcha if abuse occurs (future consideration)

## Review Date
Review after first 3 months of usage to assess abuse patterns.
