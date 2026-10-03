# PRD — Harborline Explore Wellness Filter Chip

## Problem Statement
Users of the Harborline Navigator want a quick way to find Spa or Fitness venues while maintaining the existing category chips.

## Solution
Add a Wellness filter chip on the Explore page that filters MockCatalog.venues where the category is Spa OR Fitness. This will enhance the user experience by providing a combined shortcut for Wellness venues.

## User Stories
1. As a user, I want to select the Wellness chip so that I can quickly find Spa or Fitness venues.

## Decisions made during the interview
- The implementation will only include a single story for the Wellness chip.
- The existing category chips will remain functional.
- The changes will be made in the app/lib/** directory.
- The implementation will be mock-only, without real APIs, while keeping the fictional Harborline branding.

## How we'll know it works
- Selecting the Wellness chip filters the displayed venues to only those categorized as Spa or Fitness.
- The existing category chips continue to function as expected.
- If no venues match the criteria, a message indicating no results should be displayed.

## Out of Scope
- Any changes to real APIs.
- Additional features beyond the Wellness chip.

## Further Notes
…

## Draft ADR Candidates
…

## Proposed CONTEXT.md Additions
…