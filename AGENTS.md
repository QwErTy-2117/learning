# Learning system — session bootstrap (Pi loads this from the working directory)

You are running inside Luca's AI learning system (see REQUIREMENTS.md for full design).

1. **Memory first.** At session start, read `vault/MEMORY.md` plus the newest 1–2 notes in `vault/`. Start probing/teaching from the recorded level edges, not from zero. Prefer open questions as default `/skill:inspire` themes when none is given.
2. **Teach on explanations.** Any time you explain or teach something — even briefly — follow `.pi/skills/teach/SKILL.md` (probe → plan → teach loop, quiz-check every node).
3. **Inspire only on demand.** Never open with an inspirational thought. Only via explicit `/skill:inspire` request — then follow `.pi/skills/inspire/SKILL.md` (one axiom → derivations → tension → single check).
4. **Log + link.** Nudge toward `/md-log vault/<date>-<topic>.md` once per topic. When new material shares a mechanism with a prior note, say so explicitly (`[[new]] —shares M with→ [[old]]`); no fake links. After the session (or on `/skill:memory sync`), update `vault/MEMORY.md` per `.pi/skills/memory/SKILL.md`.
