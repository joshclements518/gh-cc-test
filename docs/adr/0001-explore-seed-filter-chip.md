# ADR 0001: Explore Seed Filter Chip

**Status:** Accepted

**Date:** 2024

## Context

The application needs to support filtering in the Explore feature using a seed filter chip. This is part of the harness seed functionality to filter from Probe to Dining categories.

## Decision

Implement a client-side Explore filter chip for harness seed with no new API requirements.

## Consequences

### Positive
- No backend changes required
- Faster implementation with client-side filtering
- Reduced server load

### Negative
- All filtering logic must be handled on the client
- May need to load more data upfront for filtering to work effectively

## Implementation Notes

- App lives under `app/`
- Explore UI is under `app/lib/features/explore/`
