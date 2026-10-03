# ADR-1: Wellness Filter Chip Architecture Decision

## Status
Accepted

## Context
The Harborline Navigator app requires a new Wellness filter chip that allows users to filter venues categorized as Spa or Fitness while preserving existing functionality.

## Decision
We will implement a Wellness filter chip in the Explore page of the Harborline Navigator app. The implementation will respect the existing Flutter architecture, including the features/explore layer, MockCatalog, and services. No new backend services will be introduced.

## Consequences
- Users will have an enhanced experience with the ability to quickly filter for Wellness venues.
- The existing category chips will remain functional.
- The implementation will be mock-only, without real APIs, maintaining the fictional Harborline branding.