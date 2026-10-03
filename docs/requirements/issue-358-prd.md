# PRD — Harborline Explore Wellness Filter Chip

## Problem Statement
Users need a quick way to filter wellness-related venues in the Harborline Navigator app.

## Solution
Add a Wellness filter chip that matches venues categorized as Spa or Fitness, while retaining existing category chips.

## User Stories
1. As a user, I want to filter venues by a Wellness chip so that I can easily find Spa and Fitness options.

## Decisions made during the interview
- The implementation will change files under `app/lib/**`.
- The feature will be mock-only, with no real APIs involved.
- The fictional Harborline branding will be maintained.

## How we'll know it works
- Users can successfully apply the Wellness filter chip and see only venues categorized as Spa or Fitness.
- Existing category chips remain functional and unaffected.

## Out of Scope
- No changes to real APIs; the implementation will be mock-only.

## Further Notes
- Maintain the fictional Harborline branding.

## Draft ADR Candidates
- How is the Wellness filter chip represented in the app?
- Where does the state for the Wellness filter live?

## Proposed CONTEXT.md Additions
- Definition of the Wellness filter chip and its behavior in the app.

## Codebase Orientation
- The relevant code for this feature will be found in `app/lib/**`.