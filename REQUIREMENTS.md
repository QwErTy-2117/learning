# AI Learning System — Requirements + How It Works & Feels (Approach A)

Source inspiration: https://github.com/amosblomqvist/learn (pi config: `skills/teach`, `skills/visualize`, `extensions/ask-user-question`, `extensions/quiz`, `extensions/md-log`, `extensions/visual-tools`, `agents/researcher,svg-maker,mermaid-maker`).
Pi docs: https://pi.dev/docs/latest — skills, extensions, sessions, packages.
Target folder: `/home/luca/Projects/vari/learning` — run one command, start talking to learn.

## 1. Goal restated as deliverables

1. Folder where `pi` starts a teaching session: probe → plan → teach loop with quizzes.
2. On-demand inspiration skill (`/skill:inspire`): abstract, deductive politics + philosophy, fed by AI + latest news.
3. Memory that remembers everything, infers what fits learning needs, links topics together.
4. Requirements doc (this file) + working pi setup with necessary skills/extensions created.

User decisions locked:
- Inspire = on-demand only (not proactive, not cron).
- Memory = Obsidian vault (md-log mirror + viz, LaTeX math renders).
- Teach = keep original `teach` philosophy verbatim.

## 2. How it should feel (UX)

- `cd learning && pi` → Pi loads teach skill automatically for any explanation.
- `Teach me X` → Pi probes with `quiz` (find floor + ceiling, binary-search edge), asks goal with `ask_user_question`, presents plan + mermaid DAG, waits for go-ahead, then teaches node-by-node: motivate → establish → connect → quiz-check.
- `/skill:inspire [optional theme]` or `Inspire me about <power, legitimacy, AI agency>` → one abstract deductive thought: 1 axiom → 2-3 derivations → 1 tension → 1 question. Uses `researcher` for 2-3 fresh sources (AI + world news, last ~30 days), then abstracts away from news particulars. Never punditry, never takes partisan side, never predicts.
- `/md-log vault/2026-10-16-<topic>.md` once per topic → readable Obsidian note with YOU/PI callouts, quizzes, `![[viz-*.png|500]]` embeds. Math as `$...$` / `$$...$$`.
- Memory is invisible but present: Pi reads `vault/MEMORY.md` + recent notes at session start, updates learner model + links after session, surfaces `This connects to <prior topic> because <shared mechanism>`.

## 3. Architecture (Approach A: full clone + 2 skills)

```
learning/
  .pi/                          # this repo IS pi config (like learn repo)
    skills/teach/SKILL.md       # copied verbatim from learn
    skills/visualize/SKILL.md   # copied verbatim
    skills/inspire/SKILL.md     # NEW (this project)
    skills/memory/SKILL.md      # NEW (this project)
    extensions/ask-user-question.ts  # copied (shared UI lock version)
    extensions/quiz.ts          # copied (graded, shuffle, dontKnow)
    extensions/md-log.ts        # copied (Obsidian mirror)
    extensions/visual-tools/    # copied (mermaid/svg render for makers)
    agents/researcher.md        # copied (web_search, web_fetch)
    agents/mermaid-maker.md     # copied
    agents/svg-maker.md         # copied
  vault/                        # Obsidian vault (memory store)
    MEMORY.md                   # learner model + topic graph index
    2026-10-16-<topic>.md       # per-session logs via /md-log
    viz/viz-*.png               # diagrams published by makers
  learn                         # tiny launcher: `cd here && pi`
  REQUIREMENTS.md               # this file
  SETUP.md                      # install + first-run (generated next)
```

Why A: keeps verified researcher (accuracy is non-negotiable in teach skill) + visuals. Trade-off: needs tmux + pi-interactive-subagents for subagents; without it, teaching still works, researcher/visuals degrade gracefully.

Pi discovery: project `.pi/skills/`, `.pi/extensions/`, `.pi/agents/` loaded on `pi` start in this dir. Skills lazy-load via name+description; force with `/skill:inspire`, `/skill:teach`, `/skill:memory`, `/skill:visualize`.

## 4. Requirements

### R1 — One-command start
- `learn` script + `pi` in `learning/` must load all skills/extensions with no extra flags.
- Pi requires Node >=22.19 (have 24.17.0). Install via `curl -fsSL https://pi.dev/install.sh | sh` (pinned) or `npm i -g @earendil-works/pi-coding-agent`. Then `/login` for provider.
- Subagents: `pi-interactive-subagents` (tmux only) for researcher/makers. Without it, main session teaches, skips verify/visual.

### R2 — Teach (reused, not reinvented)
- Keep `teach` SKILL.md verbatim. Probe (quiz for level edge floor+ceiling, ask_user_question for goal), Plan (researcher scope, unconditional truths, DAG mermaid, wait for go-ahead), Teach loop per node (motivate, establish, connect, quiz-check). Quiz option hygiene: bare claims, mutate-correct-into-distractors, no asymmetric bolding.
- Reuse `quiz` + `ask-user-question` copies from learn (shared `__piSharedUiLock` — do not mix with other implementations).

### R3 — Inspire (new skill, on-demand, abstract + deductive)
Trigger: explicit `/skill:inspire` or "inspire me about X". Never auto-fires.
Inputs: optional theme; else pick from MEMORY gaps + fresh news.
Process:
1. `researcher`: 2-4 facets (AI capability/news last 30d + politics/philosophy primary sources). 2-3 sources fetched full.
2. Distill to ONE abstract structure (e.g. legitimacy requires X, delegation creates Y). Drop proper nouns after grounding.
3. Deliver: Axiom (one universal "all/no X is Y") → Derivation 1-3 (each "if axiom, then...") → Tension (where derivation breaks) → Single `quiz` deductive check OR `ask_user_question` reflection (no right answer). Max ~250 words prose + optional visualize.
4. Append to same md-log + update MEMORY links (see R4). Cite sources inline.
Non-goals: no partisan stance, no news summary, no prediction, no more than one idea per invocation.

### R4 — Memory (new skill, Obsidian-backed)
Store: `vault/MEMORY.md` (learner model: interests, level edges per strand, misconceptions, open questions) + per-topic notes + `viz/`.
Load: at session start, read MEMORY.md + last 3 notes titles + link index. No vector DB — file grep is enough at this scale.
Write: after each teach/inspire session (or `/skill:memory sync`), update: (a) level edges, (b) topic graph (`[[note]] —shares mechanism M with→ [[other]]`), (c) open questions. Links must name shared mechanism, not just keyword overlap.
Privacy: vault is local; `/export`/`/share` may leak prompts — review before sharing.

### R5 — Research provenance (how others did it)
- learn repo pattern: philosophy in skill, UI in extensions, truth/visuals in subagents. Copied.
- Pi patterns surveyed: Agent Skills spec (`SKILL.md` frontmatter name+description), extension `registerTool/registerCommand`, `session_start` restore (md-log), `tool_execution_update` for shuffle-safe logging, subagent via extension (pi-interactive-subagents). No extra npm packages needed for v1.
- Alternatives considered: plain markdown folder (rejected — no LaTeX/viz render), Pi sessions only (rejected — compaction loses edges), cron inspire (rejected — user chose on-demand).

## 5. Verification checklist
- [ ] `ls .pi/skills` shows teach, visualize, inspire, memory.
- [ ] `ls .pi/extensions` shows ask-user-question, quiz, md-log, visual-tools.
- [ ] `ls .pi/agents` shows researcher, mermaid-maker, svg-maker.
- [ ] `vault/MEMORY.md` exists with learner model template.
- [ ] `./learn` launches pi in this dir (or prints pi install hint).
- [ ] `AGENTS.md` bootstrap loads memory at session start (context file, no trust needed).
- [ ] `./verify.sh` passes (static gate: skills, agents, refs, imports, vault, launcher).
- [ ] `/skill:inspire`, `/skill:memory`, `/skill:teach` discoverable via `/skill:<name>` force-load.
- [ ] `/md-log vault/<note>.md` backfills + live-mirrors.
