# SETUP — install + first run

## 1. Install pi — DONE (2026-10-16)

`@earendil-works/pi-coding-agent` installed via npm to `~/.npm-global/bin/pi`.
If you reinstall: `curl -fsSL https://pi.dev/install.sh | sh` (pinned) or the npm command above.

Requires Node >= 22.19 (you have 24.17.0 — ok).

```bash
curl -fsSL https://pi.dev/install.sh | sh   # pinned deps, updates via `pi update`
# or: npm install -g --ignore-scripts @earendil-works/pi-coding-agent
pi --help
```

Inside pi: `/login` to connect provider (subscription or API key). See https://pi.dev/docs/latest/models.

## 2. Subagents (for researcher + visuals)

Recommended (tmux only): https://github.com/amosblomqvist/pi-interactive-subagents

```bash
# follow that repo's install, then researcher + mermaid-maker + svg-maker work out of the box
```

Without it: teaching still works; pi will tell you `quiz`/`researcher` degrade (accuracy rule in teach skill says verify — do manual web_search/web_fetch instead, or install subagents).

Verified caveat (2026-10-16): current pi's dist contains no `web_fetch`/`safe_bash` tool (`web_search` hits are OpenAI API strings, not tools), so `agents/researcher.md` is fully functional only with the subagents extension (provides `safe_bash`) plus a web search/fetch source. Until then, treat researcher as degraded: verify facts manually via `bash` + `curl` instead of skipping verification.

Also needs for visuals: `visual-tools` extension renders via bundled mermaid-cli + Chrome, SVG via `rsvg-convert` (fallback ImageMagick).

## 3. First run in this folder

```bash
cd /home/luca/Projects/vari/learning
chmod +x learn
./learn
```

Try inside pi:

```
/skill:teach Teach me how the internet routes packets
/skill:inspire
/skill:memory sync
/md-log vault/2026-10-16-example.md
```

Notes:
- `.pi/` is project config (skills, extensions, agents) — loaded because you start pi here.
- `ask-user-question` copy here must win over any other copy (shared `__piSharedUiLock` only works with same implementation).
- `vault/` is your Obsidian vault: open it in Obsidian to get rendered math (`$...$`), callouts, `![[viz-*.png|500]]`.
- Never commit provider keys. Vault notes are local; review before `/export` or `/share`.

## 5. What was reused vs created (extensions/skills survey)

Reused verbatim from `amosblomqvist/learn`:

```bash
PI_OFFLINE=1 pi --verbose --no-session --model "openai/gpt-4o-mini" --api-key dummy -p "reply OK"
# Expected: only an OpenAI 401 error — i.e. pi got past extension/skill loading
# to the model call. Any extension syntax/import error would appear instead.
# Also verified: pi aliases @sinclair/typebox* and @earendil-works/pi-tui as
# virtual modules, so quiz.ts / ask-user-question.ts imports resolve at runtime.
```

Reused verbatim from `amosblomqvist/learn`: `skills/teach`, `skills/visualize`, `extensions/ask-user-question.ts`, `extensions/quiz.ts`, `extensions/md-log.ts`, `extensions/visual-tools/`, `agents/researcher.md`, `agents/mermaid-maker.md`, `agents/svg-maker.md`.

Created here: `skills/inspire/SKILL.md` (on-demand abstract deductive politics/philosophy from AI+news), `skills/memory/SKILL.md` (file-backed learner model + topic links), `vault/MEMORY.md`, `learn` launcher, `REQUIREMENTS.md`, this file.

Pi-native patterns followed: Agent Skills spec frontmatter (`name` + `description` routing), extension `registerTool/registerCommand`, `session_start` restore, `tool_execution_update` shuffle-safe logging, subagent delegation via extension.

## 6. No-provider option: local Ollama (verified 2026-10-16)

If you have Ollama with models (e.g. `gemma4:cloud`), no `/login` needed.
Put this in your agent-dir `models.json` (`~/.pi/agent/models.json`):

```json
{
  "providers": {
    "ollama": {
      "baseUrl": "http://localhost:11434/v1",
      "api": "openai-completions",
      "apiKey": "ollama",
      "models": [{ "id": "gemma4:cloud" }]
    }
  }
}
```

Then: `./learn --model "ollama/gemma4:cloud"`. Live-verified: MEMORY read,
AGENTS.md bootstrap recital, `/md-log` link+backfill with YOU/PI callouts,
quiz shuffle + graceful `unavailable` headless verdict, and a full
`/skill:inspire` run (axiom → derivations → tension → sources → reflection → memory link).

```bash
PI_OFFLINE=1 pi --verbose --no-session --model "openai/gpt-4o-mini" --api-key dummy -p "reply OK"
# Expected: only an OpenAI 401 error — i.e. pi got past extension/skill loading
# to the model call. Any extension syntax/import error would appear instead.
# Also verified: pi aliases @sinclair/typebox* and @earendil-works/pi-tui as
# virtual modules, so quiz.ts / ask-user-question.ts imports resolve at runtime.
```
