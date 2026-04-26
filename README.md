```markdown
# Backend

Dart Frog backend with PostgreSQL and Flyway migrations.

## Requirements

- Docker
- Make

## Setup

Clone the repo and run:

```bash
make start
```

This will start PostgreSQL and apply all migrations automatically.

## Commands

| Command | Description |
|---|---|
| `make start` | Start all containers |
| `make stop` | Stop all containers |
| `make logs-migration` | View Flyway migration logs |
| `make logs-db` | View PostgreSQL logs |

## Database

Migrations are located in `/migrations`. To add a new migration create a file following the naming convention:

```
V2__description.sql
V3__description.sql
```

Flyway will apply them automatically on next `make start`.
```
