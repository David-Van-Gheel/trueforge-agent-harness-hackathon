# TrueForge Agent Harness Hackathon

This repository captures the TrueForge Agent Harness Hackathon project: a Git-friendly export of local agent data, manifests, exports, and documentation designed to showcase how agent workflows can be explored, reviewed, and shared.

## Project overview
TrueForge helps teams work with structured agent data, session metadata, and reusable tooling in a way that is easy to inspect in source control. This project packages those artifacts in a lightweight repository layout so they can be reviewed, regenerated, and extended during the hackathon.

## Sponsors
- Bright Data
- Qodo

## Repository layout
- `agents/` - per-agent manifests and summaries
- `exports/` - JSON exports of database tables and session metadata
- `docs/` - notes about export structure and repository usage
- `scripts/` - regeneration helpers for exporting TrueForge data
- `db/` - local database snapshot

## Notes
- Sensitive values were redacted in the readable exports.
- Session exports are intentionally sanitized and omit raw prompt content, tool payloads, and environment-specific execution traces.
- The SQLite database snapshot is stored locally as the source of truth for regeneration and is not included in the repo.
- This repository is intentionally organized for easy collaboration and review during the hackathon.

## Getting started
1. Review the agent manifests in `agents/`.
2. Inspect exported metadata in `exports/`.
3. Use `scripts/export_trueforge_db.py` to regenerate data snapshots if needed.
