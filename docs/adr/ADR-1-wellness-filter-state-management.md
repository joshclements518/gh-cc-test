# ADR 1: Wellness Filter State Management

## Status
Accepted

## Context
The decision revolves around how the state for the Wellness filter chip will be managed in the Harborline Navigator app. The existing architecture includes Flutter layers such as features/explore, MockCatalog, and services.

## Decision
The state for the Wellness filter will be managed within the existing Flutter layers (features/explore, MockCatalog, and services). No new backends will be introduced, and the implementation will remain mock-only.

## Consequences
- The Wellness filter will integrate seamlessly with the existing architecture, leveraging current state management practices.
- This approach avoids the complexity of adding new backend services.

## Alternatives Considered
- Managing state globally across the app was considered but rejected in favor of maintaining existing layers.

## Supersedes
N/A
