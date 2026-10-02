# Epic 101 Stories — Friday Snack Vote

## 1. Create poll
Build the complete poll creation flow: SQLite setup, POST /polls endpoint, and UI form that displays a shareable link.

### Acceptance criteria
- SQLite database with polls, poll_options, and votes tables
- POST /polls endpoint accepts question and options array, returns poll ID
- Mobile-first UI form to create poll with question and options (min 2)
- After creation, displays shareable link to the poll
- GET /polls/:id endpoint returns poll data and vote counts for results display

### Architecture / UI bindings
- Architecture: SQLite, POST /polls, GET /polls/:id per ARCHITECTURE-DECISIONS
- UI-SPEC: Simple form, mobile-first per UI-SPEC

## 2. Cast vote
Build the complete voting flow: vote submission endpoint, voting UI, and results display.

### Acceptance criteria
- POST /polls/:id/votes endpoint accepts option_id and records vote
- Mobile-first voting UI loads poll via shareable link, displays options, submits vote
- Mobile-first results page shows poll question, options, and vote counts
- Vote submission shows confirmation and transitions to results view

### Architecture / UI bindings
- Architecture: POST /polls/:id/votes per ARCHITECTURE-DECISIONS
- UI-SPEC: Simple form + results page, mobile-first per UI-SPEC
