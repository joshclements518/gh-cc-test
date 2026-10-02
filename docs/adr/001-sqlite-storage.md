# ADR-001: SQLite for Data Storage

## Status
Accepted

## Context
The Friday Snack Vote application needs persistent storage for polls, options, and votes. The system requirements are:
- Internal tool with low traffic (single team)
- Simple data model (3 tables)
- Deployed on Azure Container Apps
- No complex queries or high concurrency needs

## Decision
Use SQLite as the database, stored on the ACA container filesystem.

## Rationale

### Advantages
- **Simplicity:** Zero-configuration, single-file database
- **Performance:** Excellent for read-heavy workloads with low write concurrency
- **Cost:** No separate database service required
- **Deployment:** Embedded in the application, no network latency
- **Sufficient Scale:** Handles hundreds of votes easily

### Trade-offs
- **Persistence Risk:** Data lost if container restarts without volume mount
- **Concurrency:** Limited write concurrency (not an issue for this use case)
- **Scaling:** Cannot scale horizontally (acceptable for internal tool)

## Mitigation
- Mount persistent volume at `/data` on ACA for SQLite file
- Implement periodic backups if needed
- Document recovery procedure

## Alternatives Considered

### PostgreSQL on Azure
- **Rejected:** Overkill for simple internal tool
- **Cost:** Additional service charges
- **Complexity:** Requires connection management, secrets

### Cosmos DB
- **Rejected:** Expensive for small dataset
- **Complexity:** Over-engineered for this use case

## Consequences
- Fast local queries with no network overhead
- Simple deployment and development workflow
- Must ensure volume persistence in ACA configuration
- Future migration path available if scale requirements change
