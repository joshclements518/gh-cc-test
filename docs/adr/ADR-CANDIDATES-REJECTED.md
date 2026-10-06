# ADR Candidates — Rejected as Non-Architectural

This document lists decision points from the PRD/ADR-CANDIDATES that were evaluated and rejected as non-architectural. These are deferred to implementation.

---

## Chip Row Placement Order

**Original candidate**: "Where does the Wellness chip appear in the chip row order? Should it be positioned after All, at the end of the list, or in a specific position relative to Spa and Fitness?"

**Rejection rationale**: Visual ordering of UI elements is a presentation concern, not an architectural constraint. The chip row is rendered as a horizontal scrollable list; placement does not affect:
- Data model or state representation
- API surface or module boundaries
- Filter logic or performance characteristics
- Future feature extensibility

**Deferred to**: Implementation. Recommend placing Wellness after All and before the dynamically generated category chips for discoverability, but this is a UX refinement, not a structural decision.

---

## Future Considerations

If chip ordering were to affect **lazy loading**, **virtualization**, or **accessibility focus order** in a way that constrains future features, it would become architectural. For this epic (9 total chips, no virtualization), it remains a local implementation detail.
