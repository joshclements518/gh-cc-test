# ADR 0001: Client-side Explore Filter Chip for Harness Seed

**Status:** Accepted

**Date:** 2024

## Context

The harness seed feature requires an Explore filter chip to allow users to filter from "Probe" to "Dining" within the existing app. This filtering capability needs to be implemented as part of the Explore UI functionality.

## Decision

Implement a client-side Explore filter chip for the harness seed feature. No new API endpoints are required for this functionality.

## Consequences

### Positive
- Simpler implementation without backend changes
- Faster user experience with client-side filtering
- Reduced server load and API complexity

### Negative
- All data must be loaded client-side before filtering
- May not scale well if the dataset grows significantly

## Implementation Notes

- The filter chip will be integrated into the existing Explore UI under `app/lib/features/explore/`
- Filtering logic will be handled entirely on the client side
