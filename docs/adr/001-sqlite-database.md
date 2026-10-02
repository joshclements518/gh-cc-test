# ADR 001: Use SQLite for Data Storage

## Status
Accepted

## Context
The Friday Snack Vote application requires persistent storage for:
- Poll definitions (title, options)
- Vote records
- Results aggregation

We need a database solution that is:
- Easy to deploy and maintain
- Sufficient for small-to-medium team usage
- Low operational overhead
- Simple to back up

## Decision
We will use SQLite as the database engine for the Friday Snack Vote application.

## Rationale

### Advantages
1. **Zero Configuration**: No separate database server to install or configure
2. **Single File**: Entire database stored in one file, simplifying backups
3. **Embedded**: Runs in-process with the application
4. **Sufficient Performance**: Handles concurrent reads well; adequate write throughput for polling use case
5. **ACID Compliant**: Ensures data integrity
6. **Widely Supported**: Excellent library support across languages
7. **Low Resource Usage**: Minimal memory and CPU footprint

### Trade-offs
1. **Limited Concurrency**: Write operations are serialized (acceptable for polling workload)
2. **Single Server**: Cannot distribute across multiple servers
3. **No Built-in Replication**: Backup strategy must be external

## Consequences

### Positive
- Rapid development and deployment
- No database administration overhead
- Easy local development (no external dependencies)
- Simple backup/restore (copy single file)

### Negative
- May need migration to client-server database if usage scales significantly
- Write-heavy workloads could experience contention
- No native high-availability features

## Alternatives Considered

### PostgreSQL
- **Pros**: Better concurrency, replication, scalability
- **Cons**: Requires separate server, more complex deployment, overkill for use case

### MySQL/MariaDB
- **Pros**: Mature, scalable, good tooling
- **Cons**: Additional infrastructure, unnecessary complexity for small team polls

### In-Memory (Redis)
- **Pros**: Extremely fast
- **Cons**: Data persistence concerns, requires separate server

## Implementation Notes
- Use connection pooling to manage concurrent access
- Implement proper transaction handling for vote recording
- Regular automated backups of the SQLite file
- Monitor database file size and performance metrics
