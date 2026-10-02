# ADR 001: Use SQLite Database

## Status
Accepted

## Context
The Friday Snack Vote application needs a data persistence layer to store polls and votes. The application requirements are:
- Simple polling functionality
- No authentication required
- Expected low to medium traffic (internal team use)
- Quick setup and deployment
- Minimal operational overhead

## Decision
We will use SQLite as the database for the Friday Snack Vote application.

## Rationale

### Advantages
1. **Zero Configuration**: SQLite requires no separate database server or configuration
2. **Lightweight**: Single file database, easy to backup and migrate
3. **Sufficient Performance**: Adequate for expected read/write patterns
4. **Built-in Support**: Available in most programming language standard libraries
5. **ACID Compliant**: Provides transaction safety
6. **Low Operational Cost**: No database server to maintain or monitor

### Trade-offs
1. **Concurrency Limitations**: Write operations are serialized; acceptable for our use case
2. **Scalability Ceiling**: Not suitable for high-traffic scenarios; sufficient for internal team polls
3. **No Network Access**: Database must be on same host as application; acceptable for single-server deployment

## Alternatives Considered

### PostgreSQL
- **Pros**: Better concurrency, more features, better for high traffic
- **Cons**: Requires separate server, more complex setup, overkill for simple polling
- **Verdict**: Too complex for current requirements

### MySQL/MariaDB
- **Pros**: Good performance, widely used
- **Cons**: Requires separate server, additional operational overhead
- **Verdict**: Unnecessary complexity

### In-Memory Store (Redis)
- **Pros**: Very fast, simple key-value operations
- **Cons**: Data persistence requires configuration, less suitable for relational data
- **Verdict**: Not ideal for structured poll data with relationships

### File-based JSON
- **Pros**: Extremely simple, no dependencies
- **Cons**: No ACID guarantees, poor concurrency, manual query logic
- **Verdict**: Too primitive, lacks transaction safety

## Consequences

### Positive
- Rapid development and deployment
- No database administration required
- Easy testing with in-memory SQLite databases
- Simple backup strategy (copy single file)

### Negative
- Will need migration if traffic grows significantly
- Limited to single-server deployment
- Write contention possible under heavy concurrent load (unlikely for our use case)

### Mitigation
- Monitor application usage and performance
- If traffic exceeds SQLite capabilities, migration path to PostgreSQL is straightforward
- Database schema designed to be portable to other SQL databases

## Notes
This decision is appropriate for the current scope (internal team polling). If the application is later opened to larger audiences or requires high availability, a client-server database should be considered.
