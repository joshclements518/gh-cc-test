# ADR 001: Use SQLite for Data Persistence

## Status
Accepted

## Context
The Friday Snack Vote application requires persistent storage for:
- Poll definitions (title, options)
- Vote records
- Result aggregation

We need to choose a database solution that balances simplicity, reliability, and sufficient performance for a team-scale polling application.

## Decision
We will use **SQLite** as the database for the Friday Snack Vote application.

## Rationale

### Advantages
1. **Zero Configuration**: No separate database server to install, configure, or maintain
2. **Portability**: Single file database can be easily backed up, moved, or version-controlled
3. **Sufficient Performance**: Handles hundreds of concurrent readers and adequate write throughput for our use case
4. **Reliability**: ACID-compliant, battle-tested, widely used
5. **Low Operational Overhead**: No database administration required
6. **Development Simplicity**: Easy to set up in development and test environments

### Trade-offs
1. **Concurrency Limitations**: Write operations are serialized; not suitable for high-write workloads
   - **Mitigation**: Our use case has low write volume (occasional poll creation, intermittent voting)
2. **No Network Access**: Database is file-based, limiting multi-server deployments
   - **Mitigation**: Single-instance deployment is sufficient for team use
3. **Limited Scalability**: Not suitable for thousands of concurrent writers
   - **Mitigation**: Expected load is <100 concurrent voters, well within SQLite capabilities

## Alternatives Considered

### PostgreSQL
- **Pros**: Better concurrency, network access, more features
- **Cons**: Requires separate server, more complex setup, overkill for our needs
- **Verdict**: Unnecessary complexity for a simple polling app

### MySQL/MariaDB
- **Pros**: Good performance, widely known
- **Cons**: Requires separate server, more operational overhead
- **Verdict**: Similar to PostgreSQL—too heavy for our use case

### In-Memory Store (Redis)
- **Pros**: Very fast, simple key-value operations
- **Cons**: Requires persistence configuration, less suitable for relational queries
- **Verdict**: Overkill and less natural fit for our relational data model

### JSON File Storage
- **Pros**: Extremely simple, no dependencies
- **Cons**: No ACID guarantees, poor concurrency, manual query logic
- **Verdict**: Too fragile for production use

## Consequences

### Positive
- Rapid development and deployment
- Minimal infrastructure requirements
- Easy backup and restore (copy single file)
- Suitable for containerized deployment
- Low memory footprint

### Negative
- Cannot easily scale horizontally across multiple servers
- Write-heavy workloads could become bottleneck (not expected in our case)
- Limited built-in replication options

### Neutral
- Team must understand SQLite's concurrency model
- Database file location must be properly configured in deployment

## Implementation Notes
- Database file location: `./data/polls.db`
- Use WAL (Write-Ahead Logging) mode for better concurrent read performance
- Implement connection pooling in application layer
- Set appropriate busy timeout for write contention handling
