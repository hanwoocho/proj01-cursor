-- Run on the DB PC (PostgreSQL) before first Docker deploy.
-- chat-cursor (primary) should already exist from local development.
-- Requires superuser (postgres) or CREATEDB privilege.

CREATE DATABASE "chat-cursor_cache";
CREATE DATABASE "chat-cursor_queue";
CREATE DATABASE "chat-cursor_cable";
