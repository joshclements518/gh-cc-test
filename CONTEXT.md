# Context & Glossary — Harborline Navigator

This file defines domain terms, architectural concepts, and product vocabulary used across the Harborline Navigator codebase and documentation.

## Domain Terms

- **Wellness**: A combined filter on Explore that matches venues in either the Spa or Fitness category. Introduced as a guest convenience shortcut.
- **Category (venue)**: A single-value classification field on Venue (e.g., "Spa", "Fitness", "Dining"). Used for single-select filtering on Explore.
- **MockCatalog**: Static sample data class providing venues, reservations, itinerary, and other demo content for the Harborline Navigator app.

## Product Context

**Harborline Navigator** is a fictional cruise companion app for the MV Aether Dawn (Harborline brand). It provides guests with:
- Explore screen for discovering venues and experiences
- Plans/itinerary management
- Messages and notifications
- Account and profile management

## Architecture Context

The app is built with Flutter and uses a feature-based structure under `app/lib/features/`. Mock data is provided by `MockCatalog` for demo purposes. The app does not connect to real backend services in this demo configuration.

## Related Documentation

- System architecture: `docs/architecture/system-context.md`
- Data models: `docs/architecture/data-model.md`
- Architecture decisions: `docs/adr/`
