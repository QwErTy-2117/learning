#!/usr/bin/env bash
# verify.sh — static gate for the learning system. No provider key needed.
# Checks: pi present, skills frontmatter, agents frontmatter, skill<->tool refs,
# stale imports, memory vault, launcher. Exit non-zero on first failure.
set -euo pipefail
cd "$(dirname "$0")"
fail() { echo "FAIL: $1"; exit 1; }
pass() { echo "ok: $1"; }

command -v pi >/dev/null || fail "pi not on PATH (see SETUP.md §1)"
pass "pi found: $(command -v pi)"

for s in teach visualize inspire memory; do
  [ -f ".pi/skills/$s/SKILL.md" ] || fail "missing skill $s"
done
pass "4 skills present"

for a in researcher mermaid-maker svg-maker; do
  [ -f ".pi/agents/$a.md" ] || fail "missing agent $a"
done
pass "3 agents present"

for e in ask-user-question.ts quiz.ts md-log.ts visual-tools; do
  [ -e ".pi/extensions/$e" ] || fail "missing extension $e"
done
pass "4 extensions present"

if grep -rn "mariozechner\|Users/amos" .pi/ 2>/dev/null | grep -q .; then
  grep -rn "mariozechner\|Users/amos" .pi/
  fail "stale imports"
fi
pass "no stale imports"

python3 - <<'EOF'
import re, pathlib, sys
base = pathlib.Path('.pi')
for f in list((base/'skills').rglob('SKILL.md')) + list((base/'agents').glob('*.md')):
    m = re.match(r'^---\n(.*?)\n---', f.read_text(), re.S)
    assert m and 'name:' in m.group(1) and 'description:' in m.group(1), f'BAD frontmatter: {f}'
print('ok: all SKILL.md + agent frontmatter valid')
have = {'quiz','ask_user_question','researcher','mermaid-maker','svg-maker','md-log','visualize','teach','inspire','memory'}
for f in sorted((base/'skills').rglob('SKILL.md')):
    refs = set(re.findall(r'`(quiz|ask_user_question|researcher|mermaid-maker|svg-maker|md-log|visualize|teach|inspire|memory)`', f.read_text()))
    assert refs <= have, f'unresolved refs in {f}: {refs - have}'
print('ok: all skill<->tool refs resolve')
EOF

[ -f vault/MEMORY.md ] || fail "vault/MEMORY.md missing"
[ -d vault/viz ] || fail "vault/viz missing"
[ -f AGENTS.md ] || fail "AGENTS.md bootstrap missing"
[ -x learn ] || fail "learn not executable"
pass "vault + AGENTS.md + learn launcher present"

echo "ALL STATIC CHECKS PASSED (for a live run: ./learn --model ollama/gemma4:cloud, or /login — see SETUP.md)"
