# Learning system

A folder where you run one command and start learning anything — built on [pi](https://pi.dev), inspired by [amosblomqvist/learn](https://github.com/amosblomqvist/learn).

## Start

```bash
./learn --model ollama/gemma4:cloud   # local, no login needed (see SETUP.md)
# or: ./learn                          # then /login for a hosted provider
```

Inside pi:

- `Teach me <anything>` — probes your level with quizzes, plans, then teaches node-by-node
- `/skill:inspire [theme]` — one abstract, deductive politics/philosophy thought grounded in AI + recent news
- `/md-log vault/2026-10-16-<topic>.md` — mirrors the session into an Obsidian note (`touch` the file first)
- `/skill:memory sync` — updates your learner model and topic links

## Layout

```
learn                 # launcher: ./learn [--model ...]
AGENTS.md             # session bootstrap pi loads automatically
.pi/skills/           # teach, visualize (from learn) + inspire, memory (new)
.pi/extensions/       # quiz, ask-user-question, md-log, visual-tools
.pi/agents/           # researcher, mermaid-maker, svg-maker
vault/                # Obsidian vault: MEMORY.md + per-topic notes + viz/
REQUIREMENTS.md       # full requirements + design
SETUP.md              # install, providers, verification notes
verify.sh             # static gate: ./verify.sh
```

## How it works

- **Teach:** unconditional truths first, motivated discovery path (3Blue1Brown style), probe → plan → teach loop with graded quiz-checks.
- **Inspire (on-demand only):** one axiom → derivations → tension → single check, grounded in fresh sources then abstracted away from the news.
- **Memory:** `vault/MEMORY.md` holds your level edges, misconceptions and open questions; topics link via shared mechanisms, not keywords. Open `vault/` in Obsidian for rendered math and diagrams.

See `REQUIREMENTS.md` for the full design and `SETUP.md` for install details.
