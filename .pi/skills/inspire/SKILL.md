---
name: inspire
description: Deliver one abstract deductive political-philosophical thought grounded in AI and latest news. Use when user asks to be inspired, think about the world, or explore politics/philosophy. On-demand only, never proactive.
---

# Inspire

One idea per invocation. Abstract, deductive, non-partisan. Grounded in fresh reality, then lifted away from particulars.

## Trigger

Only on explicit request: `/skill:inspire`, "inspire me", "give me something to think about", "politics/philosophy thought". Never auto-fire at session start. If theme given ("about legitimacy"), use it; else pick from MEMORY.md gaps + fresh news.

## Process

1. **Ground (researcher).** Dispatch `researcher` subagent (or web_search/web_fetch if no subagents): 2-4 facets — (a) AI capability/news last ~30 days, (b) world politics event last ~30 days, (c) one primary philosophy source (classic text / SEP entry). Fetch 2-3 full pages. If researcher unavailable, do 2 searches yourself and say so.
2. **Distill.** Reduce to ONE abstract structure. Drop proper nouns after grounding. Form: universal statement ("all delegation creates...") or tension between two unconditional claims.
3. **Deliver (~250 words max prose).** Shape:
   - **Axiom:** one "all/no X is Y" claim, caveat-free.
   - **Derivations:** 2-3 steps, each "if axiom, then..." — motivated, no leaps.
   - **Tension:** where derivation breaks or two truths collide.
   - **Sources:** 2-3 inline links (kept vs dropped like researcher).
   - **Check:** one `quiz` deductive application (gradable) OR one `ask_user_question` reflection (no right answer). Not both. Quiz options follow teach hygiene: bare claims, mutate-correct-into-distractors, no asymmetric bolding.
4. **Link.** After delivering, update `vault/MEMORY.md` open-questions + topic links: `[[this-thought]] —shares mechanism M with→ [[prior-note]]`. Append to active md-log if linked. Never invent a link — name the shared mechanism or skip.

## Guardrails

- Non-partisan: analyze structures (legitimacy, coordination, agency, exit/voice), never endorse party, candidate, or regime.
- No predictions, no punditry, no news summary. News is grounding, not the point.
- One idea. If brief wants two, pick the stronger and note the other as open question.
- If unsure of any fact, verify before asserting (same accuracy rule as teach).
- Optional `visualize`: only if dependency/structure is genuinely clearer as picture; brief maker minimally.
