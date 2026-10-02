# Context — Friday Snack Vote

## Project Overview

**Friday Snack Vote** is a minimal viable polling application built to enable quick team polls for Friday snack selection. The project demonstrates a complete end-to-end implementation of a simple web application with database persistence, REST API, and mobile-first UI.

## Epic #101

This project was implemented as Epic #101: "Title convention snack poll" — a proof-of-concept for rapid development of internal tools.

### Scope
- Create polls with questions and multiple options
- Share polls via simple links
- Vote without authentication
- View real-time results

### Out of Scope (MVP)
- User authentication
- Vote editing or deletion
- Poll management features
- Advanced analytics

## Key Architectural Decisions

1. **SQLite Database** ([ADR-001](docs/adr/001-sqlite-no-auth.md))
   - File-based, zero configuration
   - Sufficient for small team usage
   - Simple backup and deployment

2. **No Authentication** ([ADR-001](docs/adr/001-sqlite-no-auth.md))
   - Reduces complexity significantly
   - Acceptable for low-stakes internal polls
   - Can be added in future iterations if needed

3. **Mobile-First Design**
   - Primary use case is voting on mobile devices
   - Responsive design scales up to desktop
   - Touch-friendly interface

## Technology Stack

- **Backend**: REST API with three endpoints
  - POST /polls — Create new poll
  - GET /polls/:id — Retrieve poll and results
  - POST /polls/:id/votes — Submit vote

- **Database**: SQLite with three tables
  - polls — Poll questions
  - poll_options — Available choices
  - votes — Submitted votes

- **Frontend**: Mobile-first web UI
  - Create poll page
  - Vote page
  - Results page

## Documentation Structure

```
docs/
├── requirements/
│   └── epic-101-prd.md          # Product requirements
├── architecture/
│   └── epic-101-architecture.md  # System architecture & API
├── ui/
│   └── epic-101-ui-spec.md      # UI design specification
├── adr/
│   └── 001-sqlite-no-auth.md    # Architecture decision record
└── stories/
    └── epic-101-stories.md       # Implementation stories
```

## Implementation Stories

1. **Story #103: Create poll**
   - Database schema setup
   - POST /polls endpoint
   - Poll creation UI
   - Shareable link generation

2. **Story #104: Cast vote**
   - POST /polls/:id/votes endpoint
   - Voting UI
   - Results display
   - Vote confirmation flow

## Success Metrics

- Poll creation takes < 30 seconds
- Mobile-responsive on common devices
- Results display immediately after voting
- Zero configuration deployment

## Future Considerations

If the tool gains traction, consider:
- Adding authentication to prevent duplicate votes
- Implementing poll expiration
- Adding poll editing/deletion
- Exporting results to CSV
- Real-time result updates (WebSocket)
