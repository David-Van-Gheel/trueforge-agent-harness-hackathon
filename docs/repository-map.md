# Repository map

```text
trueforge-repo/
  README.md
  .gitignore
  agents/
    job-search-helper/
      manifest.json
      manifest.strings.txt
  db/
    trueforge.sqlite
  docs/
    data-catalog.md
    repository-map.md
  exports/
    schema.sql
    table-summary.json
    mcp_servers/
    model_providers/
    sandbox_provider.json
    sessions/
    skills/
  scripts/
    export_trueforge_db.py
```

## How to use it
- Treat `db/trueforge.sqlite` as the source snapshot.
- Use `exports/` for Git-friendly reviewable files.
- Keep `agents/` as the canonical human-readable agent folder.
