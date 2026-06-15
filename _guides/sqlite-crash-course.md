---
layout: page
title: "SQLite Crash Course"
order: 4
date: 2026-06-15
---

A comprehensive reference for developers — covering the SQL dialect, data types, constraints, WAL configuration, and cross-platform libraries.

{% assign words = page.content | number_of_words %}
**Prahlad Yeri** · June 15, 2026 · {% if words < 360 %}1 min{% else %}{{ words | divided_by: 180 }} min{% endif %} read

> **Note:** This article was written with AI assistance.

---

## Table of Contents

1. [What is SQLite?](#1-what-is-sqlite)
2. [Data Types and Type Affinity](#2-data-types-and-type-affinity)
3. [DDL — Creating and Modifying Structure](#3-ddl--creating-and-modifying-structure)
4. [Primary Keys and Auto-Increment](#4-primary-keys-and-auto-increment)
5. [Constraints — UNIQUE, CHECK, NOT NULL, DEFAULT](#5-constraints--unique-check-not-null-default)
6. [Indexes](#6-indexes)
7. [DML — INSERT, UPDATE, DELETE](#7-dml--insert-update-delete)
8. [DQL — SELECT and Querying](#8-dql--select-and-querying)
9. [Joins and Relationships](#9-joins-and-relationships)
10. [Date and Time Handling](#10-date-and-time-handling)
11. [Transactions](#11-transactions)
12. [WAL Mode and Concurrency Configuration](#12-wal-mode-and-concurrency-configuration)
13. [JSON Support](#13-json-support)
14. [Full-Text Search (FTS5)](#14-full-text-search-fts5)
15. [Platform Libraries and Implementation Guides](#15-platform-libraries-and-implementation-guides)

---

## 1. What is SQLite?

SQLite is a self-contained, serverless, zero-configuration, transactional SQL database engine. The entire database lives in a single file on disk. There is no separate server process — the library is linked directly into your application.

**Key characteristics:**

- Single file per database (`.db` or `.sqlite` extension by convention)
- ACID-compliant with full transaction support
- Cross-platform file format — a database written on Windows reads fine on Linux or macOS
- Supports databases up to 281 TB in theory (practically limited by filesystem)
- Read by multiple processes simultaneously; writes are serialized
- Used in browsers, mobile OSes (iOS, Android), embedded systems, and desktop apps

**When SQLite is a good fit:**

- Local application storage (desktop apps, mobile apps)
- Embedded/IoT devices
- Development and testing databases (swap out for Postgres in production)
- Single-user web apps and moderate-traffic sites (with WAL mode)
- File-format use cases (replace CSV/JSON with a queryable file)

**When it is not a good fit:**

- High-concurrency write-heavy applications (use PostgreSQL or MySQL)
- Applications requiring user-level access control within the DB
- Networked multi-host access to the same database file

---

## 2. Data Types and Type Affinity

SQLite uses a **dynamic type system** called *type affinity*. The declared column type is a hint, not a strict enforcement. Any column can store any type of value.

### Storage Classes

SQLite stores values in one of five storage classes:

| Storage Class | Description |
|---|---|
| `NULL` | A null value |
| `INTEGER` | Signed integer (1, 2, 3, 4, 6, or 8 bytes depending on magnitude) |
| `REAL` | 8-byte IEEE 754 floating point |
| `TEXT` | UTF-8 or UTF-16 string |
| `BLOB` | Raw binary data, stored exactly as provided |

### Type Affinity Rules

When you declare a column type, SQLite maps it to one of five affinities:

| Affinity | Declared type examples | Behavior |
|---|---|---|
| `INTEGER` | `INT`, `INTEGER`, `BIGINT`, `TINYINT`, `BOOLEAN` | Stores integers; BOOLEAN is stored as 0/1 |
| `REAL` | `REAL`, `FLOAT`, `DOUBLE` | Stores as floating point |
| `TEXT` | `TEXT`, `CHAR`, `VARCHAR`, `CLOB` | Stores as text string |
| `BLOB` | `BLOB` (or no type) | No coercion; stores as-is |
| `NUMERIC` | `NUMERIC`, `DECIMAL`, `DATE`, `DATETIME` | Attempts integer, then real, then text |

### Practical Implications

```sql
-- SQLite accepts this without error
CREATE TABLE demo (flag BOOLEAN, amount DECIMAL(10,2));
INSERT INTO demo VALUES ('yes', 'not a number'); -- no error!

-- Best practice: validate in application code
-- or use CHECK constraints (covered in Section 5)
```

### BOOLEAN

SQLite has no native boolean type. Use `INTEGER` with `CHECK(col IN (0,1))`:

```sql
CREATE TABLE users (
    id    INTEGER PRIMARY KEY,
    active INTEGER NOT NULL DEFAULT 1 CHECK(active IN (0,1))
);
```

### DECIMAL / Fixed-Point Numbers

SQLite stores `DECIMAL` as `NUMERIC` affinity. For true fixed-point arithmetic (e.g. currency), store values as integers (cents) or use `TEXT`:

```sql
-- Store $19.99 as 1999 (cents) — safest for money
CREATE TABLE products (
    price_cents INTEGER NOT NULL  -- never REAL for money
);
```

---

## 3. DDL — Creating and Modifying Structure

### CREATE TABLE

```sql
CREATE TABLE IF NOT EXISTS posts (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       TEXT    NOT NULL,
    body        TEXT,
    author_id   INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status      TEXT    NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','published','archived')),
    view_count  INTEGER NOT NULL DEFAULT 0,
    created_at  TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at  TEXT
);
```

### ALTER TABLE

SQLite's `ALTER TABLE` is limited compared to other databases. Only these operations are supported natively:

```sql
-- Rename the table
ALTER TABLE posts RENAME TO articles;

-- Rename a column (SQLite 3.25.0+)
ALTER TABLE articles RENAME COLUMN body TO content;

-- Add a new column (must allow NULL or have a DEFAULT)
ALTER TABLE articles ADD COLUMN excerpt TEXT;

-- Drop a column (SQLite 3.35.0+)
ALTER TABLE articles DROP COLUMN excerpt;
```

**Unsupported:** changing column types, dropping/modifying constraints, reordering columns. The standard workaround:

```sql
-- 1. Create new table with the desired schema
CREATE TABLE articles_new (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT
    -- new schema here
);

-- 2. Copy data
INSERT INTO articles_new SELECT id, title, content FROM articles;

-- 3. Drop old table and rename
DROP TABLE articles;
ALTER TABLE articles_new RENAME TO articles;
```

### DROP TABLE

```sql
DROP TABLE IF EXISTS articles;
```

### CREATE VIEW

```sql
CREATE VIEW published_posts AS
SELECT id, title, created_at
FROM posts
WHERE status = 'published';
```

---

## 4. Primary Keys and Auto-Increment

### INTEGER PRIMARY KEY — The Recommended Approach

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE
);
```

When a column is declared `INTEGER PRIMARY KEY`, it becomes an **alias for the internal `rowid`**. SQLite auto-assigns the next available integer when you insert a row without specifying `id`:

```sql
INSERT INTO users (email) VALUES ('alice@example.com');
-- id = 1

INSERT INTO users (email) VALUES ('bob@example.com');
-- id = 2

-- Get the last inserted id:
SELECT last_insert_rowid();
```

Behavior: SQLite picks `max(id) + 1`. If rows are deleted, the gap can be reused on a future insert. This is fine for most applications.

### AUTOINCREMENT — Strict Monotonic IDs

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE
);
```

`AUTOINCREMENT` adds a guarantee: an ID is **never reused**, even after deletion. It stores the largest-ever-used ID in a system table called `sqlite_sequence`.

**Trade-off:** Slightly slower due to the extra `sqlite_sequence` lookup. Use it only when you need the no-reuse guarantee (e.g., audit logs, external references that must remain stable).

### Summary: `INTEGER PRIMARY KEY` vs `AUTOINCREMENT`

| Feature | `INTEGER PRIMARY KEY` | `INTEGER PRIMARY KEY AUTOINCREMENT` |
|---|---|---|
| Auto-assigns on insert | Yes | Yes |
| Reuses deleted IDs | Yes (if max was deleted) | Never |
| Speed | Faster | Slightly slower |
| Use case | General purpose | Audit trails, external references |

### Composite Primary Keys

```sql
CREATE TABLE post_tags (
    post_id INTEGER NOT NULL REFERENCES posts(id),
    tag_id  INTEGER NOT NULL REFERENCES tags(id),
    PRIMARY KEY (post_id, tag_id)
);
```

Composite PKs cannot use `AUTOINCREMENT`.

---

## 5. Constraints — UNIQUE, CHECK, NOT NULL, DEFAULT

### NOT NULL

```sql
CREATE TABLE users (
    id    INTEGER PRIMARY KEY,
    email TEXT NOT NULL,     -- rejected if NULL
    name  TEXT               -- NULL allowed
);
```

### DEFAULT

```sql
CREATE TABLE orders (
    id         INTEGER PRIMARY KEY,
    status     TEXT    NOT NULL DEFAULT 'pending',
    created_at TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    quantity   INTEGER NOT NULL DEFAULT 1
);
```

Default values can be literals or parenthesized expressions.

### UNIQUE

```sql
-- Column-level
CREATE TABLE users (
    id    INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE
);

-- Table-level (composite unique)
CREATE TABLE memberships (
    user_id INTEGER NOT NULL,
    team_id INTEGER NOT NULL,
    UNIQUE(user_id, team_id)
);
```

A `UNIQUE` constraint implicitly creates an index. `NULL` values are not considered equal for uniqueness purposes — multiple rows can have `NULL` in a `UNIQUE` column.

### CHECK

```sql
CREATE TABLE products (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    price_cents INTEGER NOT NULL CHECK(price_cents >= 0),
    status      TEXT    NOT NULL CHECK(status IN ('active', 'inactive', 'discontinued')),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK(stock >= 0),
    rating      REAL    CHECK(rating IS NULL OR (rating >= 0.0 AND rating <= 5.0))
);
```

CHECK constraints can reference any columns in the same row. They are evaluated on `INSERT` and `UPDATE`.

### FOREIGN KEY

Foreign key enforcement is **disabled by default** in SQLite. You must enable it per connection:

```sql
PRAGMA foreign_keys = ON;  -- must be run after every connection open
```

```sql
CREATE TABLE posts (
    id        INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    title     TEXT NOT NULL
);

-- Equivalent explicit syntax:
CREATE TABLE posts (
    id        INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    title     TEXT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
```

**ON DELETE / ON UPDATE actions:**

| Action | Behavior |
|---|---|
| `RESTRICT` | Prevents the operation if related rows exist |
| `NO ACTION` | Like RESTRICT but deferred; default |
| `CASCADE` | Propagates delete/update to child rows |
| `SET NULL` | Sets FK column to NULL in child rows |
| `SET DEFAULT` | Sets FK column to its DEFAULT in child rows |

---

## 6. Indexes

```sql
-- Single-column index
CREATE INDEX idx_posts_author ON posts(author_id);

-- Composite index
CREATE INDEX idx_posts_status_created ON posts(status, created_at DESC);

-- Unique index (alternative to UNIQUE constraint)
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Partial index — only indexes rows matching the WHERE clause
CREATE INDEX idx_published_posts ON posts(created_at)
WHERE status = 'published';

-- Drop an index
DROP INDEX IF EXISTS idx_posts_author;
```

SQLite automatically creates an index for `PRIMARY KEY` and `UNIQUE` constraints. Use `EXPLAIN QUERY PLAN` to verify index usage:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM posts WHERE author_id = 42 AND status = 'published';
```

---

## 7. DML — INSERT, UPDATE, DELETE

### INSERT

```sql
-- Single row
INSERT INTO users (email, name) VALUES ('alice@example.com', 'Alice');

-- Multiple rows
INSERT INTO users (email, name) VALUES
    ('bob@example.com',   'Bob'),
    ('carol@example.com', 'Carol');

-- Insert or ignore on conflict
INSERT OR IGNORE INTO users (email, name) VALUES ('alice@example.com', 'Alice Again');

-- Insert or replace (deletes conflicting row, then inserts)
INSERT OR REPLACE INTO users (email, name) VALUES ('alice@example.com', 'Alice Updated');

-- Upsert (INSERT ... ON CONFLICT) — SQLite 3.24.0+
INSERT INTO users (email, name)
VALUES ('alice@example.com', 'Alice New Name')
ON CONFLICT(email) DO UPDATE SET
    name = excluded.name,
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now');

-- Insert from SELECT
INSERT INTO archive_posts SELECT * FROM posts WHERE status = 'archived';
```

### UPDATE

```sql
-- Update specific rows
UPDATE posts SET status = 'published', updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
WHERE id = 42;

-- Update with subquery
UPDATE posts SET view_count = view_count + 1
WHERE id IN (SELECT id FROM posts WHERE author_id = 5);

-- UPDATE with RETURNING (SQLite 3.35.0+)
UPDATE posts SET view_count = view_count + 1
WHERE id = 42
RETURNING id, view_count;
```

### DELETE

```sql
-- Delete specific rows
DELETE FROM posts WHERE status = 'archived' AND created_at < '2023-01-01';

-- Delete all rows (faster than DELETE without WHERE for clearing a table)
DELETE FROM posts;  -- logs each row deletion

-- Even faster for clearing all rows:
-- DROP TABLE + CREATE TABLE, or use:
-- (no SQLite equivalent of TRUNCATE; DELETE is the standard way)

-- DELETE with RETURNING
DELETE FROM posts WHERE id = 42 RETURNING id, title;
```

---

## 8. DQL — SELECT and Querying

### Basic SELECT

```sql
SELECT id, title, status FROM posts WHERE author_id = 1 ORDER BY created_at DESC LIMIT 10;

-- Pagination
SELECT * FROM posts ORDER BY created_at DESC LIMIT 20 OFFSET 40;  -- page 3 of 20-per-page

-- Aliases
SELECT p.id, p.title, u.name AS author_name
FROM posts p
JOIN users u ON u.id = p.author_id;
```

### Aggregate Functions

```sql
SELECT
    author_id,
    COUNT(*)                     AS total_posts,
    COUNT(CASE WHEN status = 'published' THEN 1 END) AS published_count,
    AVG(view_count)              AS avg_views,
    MAX(created_at)              AS latest_post
FROM posts
GROUP BY author_id
HAVING COUNT(*) > 5
ORDER BY total_posts DESC;
```

### Common Table Expressions (CTEs)

```sql
WITH active_authors AS (
    SELECT DISTINCT author_id FROM posts WHERE status = 'published'
),
author_stats AS (
    SELECT author_id, COUNT(*) AS post_count
    FROM posts
    GROUP BY author_id
)
SELECT u.name, s.post_count
FROM users u
JOIN active_authors aa ON aa.author_id = u.id
JOIN author_stats s ON s.author_id = u.id
ORDER BY s.post_count DESC;
```

### Recursive CTEs

```sql
-- Generate a series of numbers 1–10
WITH RECURSIVE counter(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM counter WHERE n < 10
)
SELECT n FROM counter;

-- Walk a self-referential hierarchy (categories with parent_id)
WITH RECURSIVE category_tree(id, name, depth) AS (
    SELECT id, name, 0 FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.name, ct.depth + 1
    FROM categories c
    JOIN category_tree ct ON ct.id = c.parent_id
)
SELECT depth, name FROM category_tree ORDER BY depth, name;
```

### Window Functions (SQLite 3.25.0+)

```sql
SELECT
    id,
    title,
    view_count,
    ROW_NUMBER()   OVER (PARTITION BY author_id ORDER BY view_count DESC) AS rank_by_author,
    SUM(view_count) OVER (PARTITION BY author_id) AS author_total_views,
    LAG(view_count) OVER (ORDER BY created_at)  AS prev_post_views
FROM posts;
```

---

## 9. Joins and Relationships

### INNER JOIN

Returns only rows with matching values in both tables.

```sql
SELECT p.title, u.name AS author
FROM posts p
INNER JOIN users u ON u.id = p.author_id;
```

### LEFT JOIN (LEFT OUTER JOIN)

Returns all rows from the left table; NULLs for unmatched right-table columns.

```sql
-- All users, even those with no posts
SELECT u.name, COUNT(p.id) AS post_count
FROM users u
LEFT JOIN posts p ON p.author_id = u.id
GROUP BY u.id;
```

### Cross JOIN

Cartesian product — every combination of rows.

```sql
SELECT a.name, b.name FROM users a CROSS JOIN users b WHERE a.id <> b.id;
```

### Self JOIN

```sql
-- Employees and their managers (same table)
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON m.id = e.manager_id;
```

### Many-to-Many Relationships

```sql
CREATE TABLE tags  (id INTEGER PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE posts (id INTEGER PRIMARY KEY, title TEXT NOT NULL);
CREATE TABLE post_tags (
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Posts with their tags (comma-aggregated)
SELECT p.title, GROUP_CONCAT(t.name, ', ') AS tags
FROM posts p
LEFT JOIN post_tags pt ON pt.post_id = p.id
LEFT JOIN tags t ON t.id = pt.tag_id
GROUP BY p.id;
```

### One-to-One Relationships

```sql
CREATE TABLE users         (id INTEGER PRIMARY KEY, email TEXT NOT NULL UNIQUE);
CREATE TABLE user_profiles (
    user_id     INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    bio         TEXT,
    avatar_url  TEXT
);
-- user_id is both the PK and the FK, enforcing 1-to-1
```

---

## 10. Date and Time Handling

SQLite has **no native date/time storage class**. Dates are stored as `TEXT` (ISO 8601), `REAL` (Julian day numbers), or `INTEGER` (Unix timestamps). The `TEXT` / ISO 8601 approach is most readable and recommended.

### Built-in Date/Time Functions

```sql
-- Current date and time
SELECT date('now');                  -- '2025-06-11'
SELECT time('now');                  -- '14:32:00'
SELECT datetime('now');              -- '2025-06-11 14:32:00'
SELECT strftime('%Y-%m-%dT%H:%M:%fZ', 'now');  -- ISO 8601 with milliseconds

-- All 'now' functions return UTC. For local time:
SELECT datetime('now', 'localtime');

-- Modifiers
SELECT date('now', '+7 days');          -- one week from today
SELECT date('now', '-1 month');         -- one month ago
SELECT date('2025-01-15', 'start of month');   -- '2025-01-01'
SELECT date('2025-01-15', 'start of year');    -- '2025-01-01'

-- Unix timestamp (seconds since epoch)
SELECT strftime('%s', 'now');          -- '1718113920'
SELECT datetime(1718113920, 'unixepoch');  -- convert back to datetime

-- Formatting
SELECT strftime('%d/%m/%Y', '2025-06-11');   -- '11/06/2025'
SELECT strftime('%B %d, %Y', date('now'));   -- strftime has no %B — use substr instead
```

### strftime Format Codes

| Code | Meaning |
|---|---|
| `%Y` | 4-digit year |
| `%m` | Month (01–12) |
| `%d` | Day (01–31) |
| `%H` | Hour (00–23) |
| `%M` | Minute (00–59) |
| `%S` | Second (00–59) |
| `%f` | Fractional seconds (SS.SSS) |
| `%s` | Unix timestamp |
| `%w` | Day of week (0=Sunday) |
| `%j` | Day of year (001–366) |

### Recommended Storage Convention

```sql
CREATE TABLE events (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    -- Store as ISO 8601 UTC text: '2025-06-11T14:32:00.000Z'
    starts_at  TEXT NOT NULL,
    ends_at    TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

-- Querying date ranges works correctly with TEXT comparison (ISO 8601 sorts lexicographically)
SELECT * FROM events
WHERE starts_at >= '2025-06-01T00:00:00Z'
  AND starts_at <  '2025-07-01T00:00:00Z';

-- Date arithmetic
SELECT name, julianday(ends_at) - julianday(starts_at) AS duration_days FROM events;
```

---

## 11. Transactions

SQLite wraps every statement in an implicit transaction. For multiple statements, use explicit transactions for both correctness and performance.

```sql
-- Basic transaction
BEGIN;
    INSERT INTO orders (user_id, total_cents) VALUES (1, 4999);
    INSERT INTO order_items (order_id, product_id, qty) VALUES (last_insert_rowid(), 7, 2);
COMMIT;

-- Rollback on error (application-side, e.g. in a try/catch)
BEGIN;
    UPDATE accounts SET balance = balance - 5000 WHERE id = 1;
    UPDATE accounts SET balance = balance + 5000 WHERE id = 2;
    -- If anything goes wrong, call ROLLBACK instead of COMMIT
COMMIT;

-- Savepoints (nested transactions)
BEGIN;
    INSERT INTO users (email) VALUES ('a@example.com');
    SAVEPOINT sp1;
        INSERT INTO users (email) VALUES ('b@example.com');
    ROLLBACK TO sp1;  -- Undoes only the second insert
COMMIT;  -- Only the first insert is committed
```

### Transaction Types

```sql
BEGIN;             -- Deferred (default) — acquires lock on first read/write
BEGIN IMMEDIATE;   -- Acquires write-lock immediately; other writers blocked, readers allowed
BEGIN EXCLUSIVE;   -- Acquires exclusive lock; no other readers or writers
```

For WAL mode (see Section 12), `BEGIN IMMEDIATE` is generally the safest choice for write transactions to avoid `SQLITE_BUSY` errors.

---

## 12. WAL Mode and Concurrency Configuration

### Default Journal Mode (DELETE)

By default, SQLite uses a **rollback journal** (`DELETE` mode). Before writing, it copies the original page to a journal file. On commit, the journal is deleted. This means:

- Writers block all readers
- Only one writer at a time
- Suitable for single-process, low-concurrency use

### WAL Mode (Write-Ahead Logging)

WAL mode appends changes to a separate `-wal` file instead of modifying the database in place. Readers read from the original database; writers append to the WAL. A background checkpoint periodically merges WAL changes back.

**Advantages:**
- Readers never block writers, writers never block readers
- Dramatically better read performance under concurrent load
- Faster commit times for typical workloads

**Limitations:**
- All processes must be on the same machine (WAL files use shared memory via `-shm` file)
- Slightly larger disk footprint (three files: `.db`, `.db-wal`, `.db-shm`)
- Cannot be used across network filesystems

### Enabling WAL Mode

```sql
PRAGMA journal_mode = WAL;
-- Returns 'wal' on success. Run once; mode persists in the database file.

-- Recommended companion settings:
PRAGMA synchronous = NORMAL;    -- Safe with WAL; faster than FULL
PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;     -- Wait up to 5s on SQLITE_BUSY instead of failing immediately
```

### WAL Configuration by Use Case

#### Single-User Desktop / Embedded App

No concurrency concerns. WAL is still beneficial for crash safety and performance.

```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA cache_size = -64000;     -- 64MB page cache (negative = KB)
PRAGMA temp_store = MEMORY;
PRAGMA mmap_size = 268435456;   -- 256MB memory-mapped I/O
```

#### Web App — Single Process, Multiple Threads

A typical Node.js, Python, or PHP app where one process serves many requests.

```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 5000;
PRAGMA cache_size = -32000;   -- 32MB
PRAGMA foreign_keys = ON;
```

Use a **connection pool with a single writer connection** or serialize writes at the application layer. SQLite allows multiple concurrent reader connections in WAL mode.

#### Multiple Processes Reading and Writing

Multiple independent processes (e.g., a web server + background worker + CLI tool) all opening the same database file.

```sql
-- Each connection on open:
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 10000;   -- Wait up to 10s for locks
PRAGMA foreign_keys = ON;

-- Use BEGIN IMMEDIATE for write transactions to avoid writer starvation:
BEGIN IMMEDIATE;
    -- write operations
COMMIT;
```

- Keep write transactions **short** — long transactions hold the WAL lock and block other writers
- Avoid doing slow work (HTTP calls, file I/O) inside a transaction
- Consider `PRAGMA wal_autocheckpoint = 1000` (default) — checkpoint after every 1000 WAL pages

#### High-Read Web Application (SQLite as primary DB)

For apps like [Litestream](https://litestream.io/) + [Fly.io](https://fly.io/) setups:

```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 5000;
PRAGMA cache_size = -131072;      -- 128MB cache
PRAGMA mmap_size = 1073741824;    -- 1GB mmap
PRAGMA page_size = 4096;          -- set BEFORE creating tables; cannot change after
PRAGMA wal_autocheckpoint = 0;    -- Disable auto-checkpoint; checkpoint manually or via Litestream
```

#### Checkpoint Control

```sql
-- Manual checkpoint modes:
PRAGMA wal_checkpoint;            -- PASSIVE: flush pages not blocking anyone
PRAGMA wal_checkpoint(FULL);      -- Wait for all readers to finish, then checkpoint
PRAGMA wal_checkpoint(RESTART);   -- FULL + resets WAL write position to start
PRAGMA wal_checkpoint(TRUNCATE);  -- RESTART + truncates WAL file to zero bytes
```

### Other Journal Modes

```sql
PRAGMA journal_mode = MEMORY;   -- Journal kept in RAM; fast but not crash-safe
PRAGMA journal_mode = OFF;      -- No journal; fastest, no rollback on crash (dangerous)
PRAGMA journal_mode = TRUNCATE; -- Journal file truncated (not deleted) on commit
```

### synchronous Pragma

| Value | Safety | Speed |
|---|---|---|
| `OFF` | Unsafe (data loss on OS crash) | Fastest |
| `NORMAL` | Safe with WAL mode; slight risk with DELETE mode | Fast |
| `FULL` | Safe in all modes; syncs on every commit | Moderate |
| `EXTRA` | Extra syncs for directory entries | Slowest |

With WAL mode, `NORMAL` is safe and recommended. With DELETE mode, use `FULL` for reliability.

---

## 13. JSON Support

SQLite 3.38.0+ (2022) ships JSON functions by default.

```sql
-- Store JSON as TEXT
CREATE TABLE events (
    id      INTEGER PRIMARY KEY,
    payload TEXT NOT NULL  -- JSON string
);

INSERT INTO events (payload) VALUES ('{"type":"click","x":100,"y":200,"tags":["ui","button"]}');

-- Extract fields
SELECT json_extract(payload, '$.type')       AS event_type,
       json_extract(payload, '$.x')          AS x,
       json_extract(payload, '$.tags[0]')    AS first_tag
FROM events;

-- Modify JSON
UPDATE events
SET payload = json_set(payload, '$.processed', true)
WHERE id = 1;

-- Query inside JSON array
SELECT * FROM events
WHERE json_extract(payload, '$.type') = 'click';

-- Expand a JSON array into rows
SELECT value FROM events, json_each(json_extract(payload, '$.tags'));

-- Build JSON from columns
SELECT json_object('id', id, 'type', json_extract(payload, '$.type')) FROM events;

-- Aggregate into JSON array
SELECT json_group_array(json_extract(payload, '$.type')) FROM events;
```

---

## 14. Full-Text Search (FTS5)

SQLite includes an FTS5 extension for full-text search.

```sql
-- Create an FTS5 virtual table
CREATE VIRTUAL TABLE docs_fts USING fts5(
    title,
    body,
    content='docs',      -- content table (optional, for external content FTS)
    content_rowid='id'
);

-- Without content table (self-contained):
CREATE VIRTUAL TABLE notes_fts USING fts5(title, body);

INSERT INTO notes_fts VALUES ('SQLite Guide', 'SQLite is a serverless embedded database');
INSERT INTO notes_fts VALUES ('WAL Mode', 'Write-Ahead Logging improves concurrency');

-- Full-text query
SELECT * FROM notes_fts WHERE notes_fts MATCH 'serverless';

-- Phrase search
SELECT * FROM notes_fts WHERE notes_fts MATCH '"embedded database"';

-- Prefix search
SELECT * FROM notes_fts WHERE notes_fts MATCH 'serv*';

-- Boolean operators
SELECT * FROM notes_fts WHERE notes_fts MATCH 'SQLite AND WAL';
SELECT * FROM notes_fts WHERE notes_fts MATCH 'SQLite OR PostgreSQL';
SELECT * FROM notes_fts WHERE notes_fts MATCH 'database NOT NoSQL';

-- Column-scoped search
SELECT * FROM notes_fts WHERE notes_fts MATCH 'title:SQLite';

-- Ranked results (BM25 scoring)
SELECT title, rank FROM notes_fts
WHERE notes_fts MATCH 'database'
ORDER BY rank;  -- rank is negative; ORDER BY rank = best first

-- Highlighted snippets
SELECT snippet(notes_fts, 1, '<b>', '</b>', '...', 10) AS excerpt
FROM notes_fts
WHERE notes_fts MATCH 'database';
```

---

## 15. Platform Libraries and Implementation Guides

### .NET / C#

#### Microsoft.Data.Sqlite (Official, Recommended)

The official Microsoft ADO.NET provider. Works with .NET 6+, MAUI, WinForms, ASP.NET Core.

```bash
dotnet add package Microsoft.Data.Sqlite
```

```csharp
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=app.db";
using var connection = new SqliteConnection(connectionString);
connection.Open();

// Run PRAGMA on open
var pragma = connection.CreateCommand();
pragma.CommandText = "PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON; PRAGMA busy_timeout=5000;";
pragma.ExecuteNonQuery();

// Create table
var createCmd = connection.CreateCommand();
createCmd.CommandText = @"
    CREATE TABLE IF NOT EXISTS users (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        name  TEXT NOT NULL
    )";
createCmd.ExecuteNonQuery();

// Parameterized insert
var insertCmd = connection.CreateCommand();
insertCmd.CommandText = "INSERT INTO users (email, name) VALUES ($email, $name) RETURNING id";
insertCmd.Parameters.AddWithValue("$email", "alice@example.com");
insertCmd.Parameters.AddWithValue("$name", "Alice");
var newId = (long)insertCmd.ExecuteScalar()!;

// Query
var selectCmd = connection.CreateCommand();
selectCmd.CommandText = "SELECT id, email, name FROM users WHERE id = $id";
selectCmd.Parameters.AddWithValue("$id", newId);
using var reader = selectCmd.ExecuteReader();
while (reader.Read()) {
    Console.WriteLine($"{reader.GetInt64(0)}: {reader.GetString(2)} <{reader.GetString(1)}>");
}
```

#### With Entity Framework Core

```bash
dotnet add package Microsoft.EntityFrameworkCore.Sqlite
```

```csharp
// DbContext
public class AppDbContext : DbContext {
    public DbSet<User> Users => Set<User>();
    protected override void OnConfiguring(DbContextOptionsBuilder opts)
        => opts.UseSqlite("Data Source=app.db");
}

public class User {
    public int Id { get; set; }
    public string Email { get; set; } = "";
    public string Name { get; set; } = "";
}

// Usage
using var db = new AppDbContext();
db.Database.EnsureCreated();
db.Users.Add(new User { Email = "bob@example.com", Name = "Bob" });
db.SaveChanges();
var users = db.Users.Where(u => u.Name.StartsWith("B")).ToList();
```

#### Dapper (Micro-ORM)

```bash
dotnet add package Dapper
dotnet add package Microsoft.Data.Sqlite
```

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

using var conn = new SqliteConnection("Data Source=app.db");
conn.Open();

var users = conn.Query<User>("SELECT * FROM users WHERE name LIKE @Pattern",
    new { Pattern = "A%" });

conn.Execute("INSERT INTO users (email, name) VALUES (@Email, @Name)",
    new { Email = "carol@example.com", Name = "Carol" });
```

---

### Python

#### Built-in `sqlite3` Module

Python ships with SQLite support — no installation needed.

```python
import sqlite3
from contextlib import contextmanager

DB_PATH = "app.db"

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row  # Access columns by name
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")
    conn.execute("PRAGMA busy_timeout=5000")
    return conn

@contextmanager
def transaction(conn):
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise

# Setup
conn = get_connection()
conn.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        name  TEXT NOT NULL
    )
""")
conn.commit()

# Insert
with transaction(conn) as c:
    c.execute("INSERT INTO users (email, name) VALUES (?, ?)", ("alice@example.com", "Alice"))
    new_id = c.lastrowid

# Query — rows are dict-like via Row factory
rows = conn.execute("SELECT * FROM users").fetchall()
for row in rows:
    print(dict(row))

conn.close()
```

#### SQLAlchemy (ORM + Core)

```bash
pip install sqlalchemy
```

```python
from sqlalchemy import create_engine, Column, Integer, String, text
from sqlalchemy.orm import DeclarativeBase, Session

engine = create_engine(
    "sqlite:///app.db",
    connect_args={"check_same_thread": False},  # Needed for multi-threaded use
)

# Enable WAL and foreign keys on every new connection
from sqlalchemy import event

@event.listens_for(engine, "connect")
def on_connect(dbapi_conn, _):
    cursor = dbapi_conn.cursor()
    cursor.execute("PRAGMA journal_mode=WAL")
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.execute("PRAGMA busy_timeout=5000")
    cursor.close()

class Base(DeclarativeBase): pass

class User(Base):
    __tablename__ = "users"
    id    = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String, nullable=False, unique=True)
    name  = Column(String, nullable=False)

Base.metadata.create_all(engine)

with Session(engine) as session:
    session.add(User(email="bob@example.com", name="Bob"))
    session.commit()
    users = session.query(User).filter(User.name.like("B%")).all()
```

---

### PHP

#### PDO (Built-in, Recommended)

```php
<?php

function getDb(): PDO {
    $pdo = new PDO('sqlite:app.db', options: [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    $pdo->exec("PRAGMA journal_mode=WAL");
    $pdo->exec("PRAGMA foreign_keys=ON");
    $pdo->exec("PRAGMA busy_timeout=5000");
    return $pdo;
}

$db = getDb();

// Create table
$db->exec("
    CREATE TABLE IF NOT EXISTS users (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        name  TEXT NOT NULL
    )
");

// Insert with prepared statement
$stmt = $db->prepare("INSERT INTO users (email, name) VALUES (:email, :name)");
$stmt->execute([':email' => 'alice@example.com', ':name' => 'Alice']);
$newId = $db->lastInsertId();

// Query
$stmt = $db->prepare("SELECT * FROM users WHERE id = :id");
$stmt->execute([':id' => $newId]);
$user = $stmt->fetch();
var_dump($user);

// Transaction
$db->beginTransaction();
try {
    $db->prepare("UPDATE accounts SET balance = balance - ? WHERE id = ?")->execute([500, 1]);
    $db->prepare("UPDATE accounts SET balance = balance + ? WHERE id = ?")->execute([500, 2]);
    $db->commit();
} catch (Exception $e) {
    $db->rollBack();
    throw $e;
}
```

#### With Laravel (Eloquent)

In `config/database.php`, SQLite is a first-class connection type:

```php
'default' => env('DB_CONNECTION', 'sqlite'),

'connections' => [
    'sqlite' => [
        'driver'   => 'sqlite',
        'database' => database_path('database.sqlite'),
        'foreign_key_constraints' => true,
        // WAL mode is set via the 'options' key using PDO attributes
    ],
],
```

For WAL mode in Laravel, set it in `AppServiceProvider`:

```php
use Illuminate\Support\Facades\DB;

public function boot(): void {
    if (config('database.default') === 'sqlite') {
        DB::statement('PRAGMA journal_mode=WAL');
        DB::statement('PRAGMA busy_timeout=5000');
    }
}
```

---

### Web / Browser (WebAssembly)

SQLite can run entirely in the browser via WebAssembly, enabling persistent local storage that is queryable with full SQL.

#### sql.js — Classic WASM Port

```bash
npm install sql.js
```

```javascript
import initSqlJs from 'sql.js';

const SQL = await initSqlJs({
    locateFile: file => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.2/${file}`
});

// In-memory database
const db = new SQL.Database();

db.run(`
    CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT NOT NULL, name TEXT NOT NULL);
    INSERT INTO users (email, name) VALUES ('alice@example.com', 'Alice');
`);

const result = db.exec("SELECT * FROM users");
console.log(result[0].columns); // ['id', 'email', 'name']
console.log(result[0].values);  // [[1, 'alice@example.com', 'Alice']]

// Parameterized query
const stmt = db.prepare("SELECT * FROM users WHERE id = ?");
stmt.bind([1]);
while (stmt.step()) {
    console.log(stmt.getAsObject()); // { id: 1, email: '...', name: '...' }
}
stmt.free();

// Persist to IndexedDB (manual)
const data = db.export();  // Uint8Array
localStorage.setItem('db', btoa(String.fromCharCode(...data)));
```

**Limitation:** sql.js keeps the entire database in memory. Not suitable for large databases in the browser.

#### @sqlite.org/sqlite-wasm — Official WASM Build

The SQLite team's official WebAssembly build, using OPFS (Origin Private File System) for true persistent storage.

```bash
npm install @sqlite.org/sqlite-wasm
```

```javascript
// Must run in a Worker with cross-origin isolation headers:
// Cross-Origin-Opener-Policy: same-origin
// Cross-Origin-Embedder-Policy: require-corp

import sqlite3InitModule from '@sqlite.org/sqlite-wasm';

const sqlite3 = await sqlite3InitModule({ print: console.log, printErr: console.error });

// Use OPFS for persistence (survives page refresh)
const db = new sqlite3.oo1.OpfsDb('/app.db');

db.exec({
    sql: `CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, text TEXT NOT NULL)`,
});

db.exec({
    sql: `INSERT INTO notes (text) VALUES (?)`,
    bind: ['Hello from OPFS!']
});

const rows = [];
db.exec({
    sql: `SELECT * FROM notes`,
    rowMode: 'object',
    callback: row => rows.push(row)
});
console.log(rows);

db.close();
```

#### wa-sqlite — Streaming WASM with VFS Backends

wa-sqlite is a more flexible WASM SQLite build that supports pluggable Virtual File System (VFS) backends including IndexedDB and OPFS.

```bash
npm install wa-sqlite
```

```javascript
import SQLiteESMFactory from 'wa-sqlite/dist/wa-sqlite-async.mjs';
import * as SQLite from 'wa-sqlite';
import { IDBBatchAtomicVFS } from 'wa-sqlite/src/examples/IDBBatchAtomicVFS.js';

const module = await SQLiteESMFactory();
const sqlite3 = SQLite.Factory(module);

// Register IndexedDB-backed VFS
const vfs = new IDBBatchAtomicVFS('my-database');
sqlite3.vfs_register(vfs, true);

const db = await sqlite3.open_v2('app.db');

await sqlite3.exec(db, `
    CREATE TABLE IF NOT EXISTS tasks (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done  INTEGER NOT NULL DEFAULT 0
    )
`);

// Parameterized insert
await sqlite3.exec(db, "INSERT INTO tasks (title) VALUES (?)", ["Buy groceries"]);

// Query with callback
const tasks = [];
await sqlite3.exec(db, "SELECT * FROM tasks", (row, cols) => {
    tasks.push(Object.fromEntries(cols.map((c, i) => [c, row[i]])));
});
console.log(tasks);

await sqlite3.close(db);
```

#### Comparing Web SQLite Options

| Library | Persistence | WASM Size | Workers Required | Best For |
|---|---|---|---|---|
| `sql.js` | In-memory only (manual export) | ~1.5MB | No | Quick prototypes, small datasets |
| `@sqlite.org/sqlite-wasm` | OPFS (native) | ~1.2MB | Yes (OPFS requirement) | Production apps with large data |
| `wa-sqlite` | OPFS or IndexedDB | ~0.8MB | Recommended | Apps needing IndexedDB fallback |

---

### Cloudflare D1 (SQLite at the Edge)

Cloudflare D1 is a distributed SQLite service for Cloudflare Workers. The SQL dialect is standard SQLite.

```bash
npx wrangler d1 create my-database
```

`wrangler.toml`:
```toml
[[d1_databases]]
binding = "DB"
database_name = "my-database"
database_id = "xxxx-xxxx-xxxx"
```

```javascript
// Cloudflare Worker
export default {
    async fetch(request, env) {
        // Parameterized query
        const { results } = await env.DB.prepare(
            "SELECT * FROM users WHERE email = ?"
        ).bind("alice@example.com").all();

        // Batch queries (atomic)
        const [r1, r2] = await env.DB.batch([
            env.DB.prepare("INSERT INTO users (email, name) VALUES (?, ?)").bind("bob@example.com", "Bob"),
            env.DB.prepare("SELECT COUNT(*) AS count FROM users"),
        ]);

        return Response.json(results);
    }
};
```

---

## Quick Reference Cheat Sheet

```sql
-- Enable WAL + safety settings (run on every new connection)
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;

-- Canonical table template
CREATE TABLE IF NOT EXISTS things (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT    NOT NULL,
    status     TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','inactive')),
    created_at TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT
);

-- Upsert
INSERT INTO things (id, name) VALUES (1, 'foo')
ON CONFLICT(id) DO UPDATE SET name = excluded.name;

-- Current UTC timestamp
SELECT strftime('%Y-%m-%dT%H:%M:%fZ', 'now');

-- Last inserted rowid
SELECT last_insert_rowid();

-- Table schema inspection
SELECT sql FROM sqlite_master WHERE type='table' AND name='things';
PRAGMA table_info(things);
PRAGMA foreign_key_list(things);
PRAGMA index_list(things);

-- Database info
SELECT * FROM sqlite_master;
PRAGMA database_list;
PRAGMA integrity_check;
PRAGMA quick_check;
```
