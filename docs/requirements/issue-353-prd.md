# PRD — Harborline Explore Wellness filter chip

## Problem Statement
Users need a quick way to find wellness-related venues, such as spas and fitness centers, without navigating through multiple categories.

## Solution
Add a Wellness filter chip that filters `MockCatalog.venues` where the category is Spa OR Fitness, while retaining existing single-select category chips.

## User Stories
1. As a user, I want to use a Wellness chip to easily find wellness venues, so that I can quickly access Spa and Fitness options.

## Decisions made during the interview
- The implementation will change files in `app/lib/**` and will not involve tests-only changes.
- The feature will maintain the fictional Harborline branding.

## How we'll know it works
- Users can successfully filter venues by selecting the Wellness chip and see only Spa and Fitness options.

## Out of Scope
- No real APIs will be used; only mock data will be implemented.
- No changes to existing functionality beyond adding the Wellness chip.

## Further Notes
- Maintain fictional Harborline branding.

## Draft ADR Candidates
- How is the Wellness chip represented in the UI?
- What guarantees that the filtering works correctly?

## Proposed CONTEXT.md Additions
- Define the categories for venues in `MockCatalog`.

## Codebase Orientation
- Key files are located under `app/lib/`.