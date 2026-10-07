# ADR 0001: Client-side Explore Filter Chip

**Status:** Accepted

## Context

The harness seed requires an Explore filter chip (Probe → Dining) on the existing app. This feature allows users to filter explore content based on dining-related criteria.

## Decision

Implement the filter chip entirely on the client side with no new API endpoints. The filtering logic will operate on data already available in the client application.

## Consequences

### Positive
- No backend changes required
- Faster implementation and deployment
- Reduced API surface and maintenance burden
- Better user experience with instant filtering

### Negative
- All filterable data must be loaded to the client
- Filtering logic is duplicated if needed elsewhere
- May not scale if dataset grows significantly
