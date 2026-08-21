---
name: resume-state-lock
description: Reinitialize Codex safely after root-session context compaction. Use only when invoked by the compact-scoped SessionStart hook or explicitly requested to discard compacted execution state, reload all applicable rules and rule-required skills, and pause before resuming work.
---

# Resume State Lock

1. For a filesystem-backed skill, invocation means reading the exact `SKILL.md` locator supplied in the available-skills catalog and following it. Never search for a callable skill tool, inspect or filter `ALL_TOOLS`, query MCP capabilities, or enumerate general tool/skill catalogs. If no locator is supplied, make only an exact-name load attempt.
2. Treat every compacted summary, inherited plan, claimed file state, and proposed next action only as a vague lead. Do not use it as authority for execution.
3. Read `~/.codex/AGENTS.md` in full when present.
4. Within the active repository or workspace boundary, read every applicable `AGENTS.md` in full, from that boundary through the current working directory. At each level, also check for and read `AGENTS-LOCAL.md` in full when present; do not wait for an `AGENTS.md` to name it. Do not cross that boundary to read rules from an ancestor repository or installation. Let rule-required skills decide whether those parent rules become relevant when later task work resumes.
5. Recursively read every rule or instruction file explicitly referenced by any applicable rule file, in full. This includes companion local rules, policy files, handoffs, and any further referenced rule files. Continue until no unread referenced rule file remains; do not treat an already-read parent rule as satisfying its referenced files.
6. Load only skills named or required by the complete rule set, using each exact supplied locator, and read each internal `SKILL.md` in full when available. Follow instructions required before resuming work. Report an unavailable skill as a blocker only when applicable rules make it mandatory.
7. If `caveman` is available, load it from its exact supplied locator and read its internal `SKILL.md` in full before responding; preserve its active mode if session context indicates it was invoked.
8. After reinitialization, perform no resumed task inspection, mutation, command, repair, Git operation, or other execution.
9. Report `Post-compaction reinitialization complete. Awaiting user confirmation.` and end the turn. Resume work only after a later explicit user confirmation.
