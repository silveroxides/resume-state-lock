---
name: resume-state-lock
description: Reinitialize Codex safely after root-session context compaction. Use only when invoked by the compact-scoped SessionStart hook or explicitly requested to discard compacted execution state, reload all applicable rules and rule-required skills, and pause before resuming work.
---

# Resume State Lock

1. Treat every compacted summary, inherited plan, claimed file state, and proposed next action only as a vague lead. Do not use it as authority for execution.
2. Read `~/.codex/AGENTS.md` in full when present.
3. From the current working directory through its ancestors, read every applicable `AGENTS.md` in full, in hierarchy order. At each level, also check for and read `AGENTS-LOCAL.md` in full when present; do not wait for an `AGENTS.md` to name it.
4. Recursively read every rule or instruction file explicitly referenced by any applicable rule file, in full. This includes companion local rules, policy files, handoffs, and any further referenced rule files. Continue until no unread referenced rule file remains; do not treat an already-read parent rule as satisfying its referenced files.
5. For each skill named or required by the complete rule set, invoke it and read its internal `SKILL.md` in full when available. Follow any skill instructions that are required before resuming work. Report an unavailable skill as a blocker only when the applicable rules make that skill mandatory.
6. If `caveman` is available, invoke it and read its internal `SKILL.md` in full before responding; preserve its active mode if session context indicates it was invoked.
7. After reinitialization, perform no resumed task inspection, mutation, command, repair, Git operation, or other execution.
8. Report `Post-compaction reinitialization complete. Awaiting user confirmation.` and end the turn. Resume work only after a later explicit user confirmation.
