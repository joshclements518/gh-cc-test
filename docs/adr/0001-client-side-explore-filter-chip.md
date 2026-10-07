# ADR 0001: Client-side Explore Filter Chip

**Status:** Accepted

**Date:** 2025-01-27

## Context

The application needs to support filtering in the Explore feature using a seed-based filter chip. This filter allows users to transition from "Probe" to "Dining" views within the existing app.

## Decision

Implement a client-side Explore filter chip for the harness seed. This will be a purely client-side implementation with no new API endpoints required.

## Consequences

### Positive
- No backend changes required, simplifying implementation
- Faster user experience with client-side filtering
- Reduced server load

### Negative
- All filtering logic must be handled in the client
- May require loading more data upfront for filtering to work effectively
