---
name: memory
description: Remember everything learned, infer learner fit, and link topics via shared mechanisms. Use at session start (load model), during teaching (surface links), and at session end or via /skill:memory sync (update store). Backed by vault/MEMORY.md + Obsidian notes.
---

# Memory

File-backed learner model + topic graph. No vector DB — grep over small vault is enough.

## Store

- `vault/MEMORY.md` — single source of truth: interests, level edges per strand (floor/ceiling), misconceptions, open questions, topic link index.
- `vault/<date>-<topic>.md` — per-session logs via `/md-log` (YOU/PI callouts, quizzes, `![[viz-*.png|500]]`).
- `vault/viz/` — diagrams published by makers (Obsidian resolves embeds by filename).

## Load (session start)

1. Read `vault/MEMORY.md` fully.
2. List last 3 notes (`ls -t vault/*.md`) + read their first ~30 lines for recency.
3. Carry into teach Phase 1: start probe from recorded edges, not from zero. Carry into inspire: prefer gaps/open questions as theme when user gives none.

If MEMORY.md missing, create from template and tell user memory starts now.

## Surface (during session)

When new node connects to prior note, say so explicitly: `This connects to [[2026-10-10-power-grids]] because both hinge on <shared mechanism M>.` Name mechanism, not keyword. If no genuine shared mechanism, say nothing — no fake links.

Use stored misconceptions to steer quiz distractors (teach skill: distractors as diagnostic probes).

## Sync (session end or `/skill:memory sync`)

Update MEMORY.md:
1. **Edges:** for each strand taught/quizzed, record floor (got right) + ceiling (got wrong/dontKnow).
2. **Links:** append `[[new-note]] —shares M with→ [[old-note]]` only where M is explicit mechanism.
3. **Open questions:** add unresolved tensions, dropped inspire alternatives, "I don't know" gaps.
4. Keep it compact — MEMORY.md is read every session; prune stale detail into per-note files.

Do not rewrite per-note logs; append-only via md-log. Do not exfiltrate vault via /export or /share without asking.
