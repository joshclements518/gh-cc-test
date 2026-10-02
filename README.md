# Friday Snack Vote

A simple poll application for voting on Friday snacks. Create polls, share links, and see results in real-time.

## Epic #101

This application was built as part of Epic #101 to demonstrate a minimal viable polling system.

## Features

- ✅ Create polls with custom questions and multiple options
- ✅ Share polls via simple links (no login required)
- ✅ Vote on polls with a single click
- ✅ View real-time results with visual charts
- ✅ Mobile-first responsive design

## Architecture

- **Database**: SQLite (file-based, zero configuration)
- **API**: REST endpoints (POST /polls, GET /polls/:id, POST /polls/:id/votes)
- **Frontend**: Mobile-first web UI
- **Auth**: None (intentionally kept simple for MVP)

## Documentation

- **Requirements**: [docs/requirements/epic-101-prd.md](docs/requirements/epic-101-prd.md)
- **Architecture**: [docs/architecture/epic-101-architecture.md](docs/architecture/epic-101-architecture.md)
- **UI Specification**: [docs/ui/epic-101-ui-spec.md](docs/ui/epic-101-ui-spec.md)
- **Architecture Decisions**: [docs/adr/001-sqlite-no-auth.md](docs/adr/001-sqlite-no-auth.md)
- **Stories**: [docs/stories/epic-101-stories.md](docs/stories/epic-101-stories.md)

## Quick Start

1. Create a poll at the home page
2. Share the generated link with voters
3. Voters click the link, select an option, and submit
4. Results display immediately after voting

## Design Decisions

### Why SQLite?
Simple, file-based database with zero configuration. Perfect for small-scale internal tools.

### Why No Authentication?
Keeps the MVP simple and reduces friction for voters. Acceptable for low-stakes internal polls.

### Why Mobile-First?
Most users will access polls on their phones, so we optimize for that experience first.

## Future Enhancements

Potential features for future iterations:
- User authentication to prevent duplicate votes
- Poll expiration dates
- Edit or delete polls
- Advanced analytics and charts
- Export results to CSV
- Multiple choice voting (select multiple options)

## Stories

This epic was implemented through the following stories:

1. **Story #102**: Epic 101 Stories — Friday Snack Vote (planning)
2. **Story #103**: Create poll (implementation)
3. **Story #104**: Cast vote (implementation)

See [docs/stories/epic-101-stories.md](docs/stories/epic-101-stories.md) for detailed acceptance criteria.
