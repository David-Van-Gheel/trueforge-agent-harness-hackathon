CREATE UNIQUE INDEX mcp_server_tenant_name_idx
        ON mcp_server (tenant_id, name);

CREATE INDEX session_agent_id_idx
          ON session (tenant_id, agent_id)
          WHERE agent_id IS NOT NULL;

CREATE INDEX session_list_idx
          ON session (tenant_id, created_at, session_id);

CREATE INDEX session_list_updated_at_idx
        ON session (tenant_id, updated_at, session_id);

CREATE INDEX thread_context_log_lookup_idx
        ON thread_context_log (session_id, thread_id, append_id);

CREATE INDEX turn_list_idx
        ON turn (session_id, created_at, turn_id);

CREATE INDEX turn_thread_context_append_idx
        ON turn_thread_context (session_id, thread_id, append_id);

CREATE TABLE agent (
          id TEXT NOT NULL,
          tenant_id TEXT NOT NULL,
          name TEXT NOT NULL,
          manifest BLOB NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          PRIMARY KEY (id),
          UNIQUE (tenant_id, name)
        ) STRICT;

CREATE TABLE "kysely_migration" ("name" varchar(255) not null primary key, "timestamp" varchar(255) not null);

CREATE TABLE "kysely_migration_lock" ("id" varchar(255) not null primary key, "is_locked" integer default 0 not null);

CREATE TABLE mcp_server (
        id TEXT NOT NULL,
        tenant_id TEXT NOT NULL,
        name TEXT NOT NULL,
        manifest BLOB NOT NULL,
        oauth_server BLOB,
        oauth_client BLOB,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (id)
      ) STRICT;

CREATE TABLE model_provider (
        tenant_id TEXT NOT NULL,
        name TEXT NOT NULL,
        manifest BLOB NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (tenant_id, name)
      ) STRICT;

CREATE TABLE oauth_pending_authorization (
        id TEXT NOT NULL,
        oauth_server_id TEXT NOT NULL REFERENCES mcp_server (id) ON DELETE CASCADE,
        user_id TEXT NOT NULL,
        auth_data BLOB NOT NULL,
        created_at TEXT NOT NULL,
        CONSTRAINT oauth_pending_authorization_pkey PRIMARY KEY (id)
      ) STRICT;

CREATE TABLE oauth_token (
        oauth_server_id TEXT NOT NULL REFERENCES mcp_server (id) ON DELETE CASCADE,
        user_id TEXT NOT NULL,
        token BLOB NOT NULL,
        updated_at TEXT NOT NULL,
        CONSTRAINT oauth_token_pkey PRIMARY KEY (oauth_server_id, user_id)
      ) STRICT;

CREATE TABLE sandbox_provider (
        tenant_id TEXT NOT NULL,
        manifest BLOB NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending', status_reason TEXT, build_metadata BLOB,
        PRIMARY KEY (tenant_id)
      ) STRICT;

CREATE TABLE "session" (
          tenant_id TEXT NOT NULL,
          session_id TEXT NOT NULL,
          agent_id TEXT,
          agent_spec BLOB,
          title TEXT,
          last_turn_id TEXT,
          custom BLOB,
          last_activity_timestamp_ms INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL, created_by TEXT NOT NULL DEFAULT '', agent_name TEXT,
          PRIMARY KEY (session_id),
          CHECK (
            (agent_id IS NOT NULL AND agent_spec IS NULL)
            OR (agent_id IS NULL AND agent_spec IS NOT NULL)
          )
        ) STRICT;

CREATE TABLE session_event (
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        turn_id TEXT NOT NULL,
        event_id TEXT NOT NULL,
        event BLOB NOT NULL,
        created_at TEXT NOT NULL,
        PRIMARY KEY (session_id, turn_id, event_id)
      ) STRICT;

CREATE TABLE skill (
        tenant_id TEXT NOT NULL,
        name TEXT NOT NULL,
        manifest BLOB NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (tenant_id, name)
      ) STRICT;

CREATE TABLE sqlite_sequence(name,seq);

CREATE TABLE thread_capability_state (
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        turn_id TEXT NOT NULL,
        thread_id TEXT NOT NULL,
        key TEXT NOT NULL,
        state BLOB,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (session_id, turn_id, thread_id, key)
      ) STRICT;

CREATE TABLE thread_context_log (
        append_id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        thread_id TEXT NOT NULL,
        turn_id TEXT NOT NULL,
        body BLOB NOT NULL,
        created_at TEXT NOT NULL
      ) STRICT;

CREATE TABLE turn (
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        turn_id TEXT NOT NULL,
        first_turn_id TEXT NOT NULL,
        previous_turn_id TEXT,
        ancestor_ids BLOB NOT NULL,
        input BLOB NOT NULL,
        state BLOB NOT NULL,
        checkpoint BLOB NOT NULL,
        custom BLOB,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (session_id, turn_id)
      ) STRICT;

CREATE TABLE turn_thread (
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        turn_id TEXT NOT NULL,
        thread_id TEXT NOT NULL,
        checkpoint BLOB NOT NULL,
        agent_info BLOB,
        current_context_usage BLOB NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (session_id, turn_id, thread_id)
      ) STRICT;

CREATE TABLE turn_thread_context (
        session_id TEXT NOT NULL REFERENCES session(session_id) ON DELETE CASCADE,
        turn_id TEXT NOT NULL,
        thread_id TEXT NOT NULL,
        pos INTEGER NOT NULL,
        append_id INTEGER NOT NULL,
        PRIMARY KEY (session_id, turn_id, thread_id, pos)
      ) STRICT;
