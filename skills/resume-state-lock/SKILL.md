---
name: resume-state-lock
description: Reinitialize Codex safely after root-session context compaction. Use only when invoked by the compact-scoped SessionStart hook or explicitly requested to discard compacted execution state, reload all applicable rules and rule-required skills, and pause before resuming work.
---

# Resume State Lock

This is a root-thread recovery workflow. A child agent must recover its task
contract through its parent, not impose a root-only user-confirmation pause.
If this workflow is mistakenly assigned to a child, report that scope mismatch
to its parent and do not perform the root reload.

1. For a filesystem-backed skill, invocation means reading the exact `SKILL.md` locator supplied in the available-skills catalog and following it. Never search for a callable skill tool, inspect or filter `ALL_TOOLS`, query MCP capabilities, or enumerate general tool/skill catalogs. If no locator is supplied, make only an exact-name load attempt.
2. Treat every compacted summary, inherited plan, claimed file state, and proposed next action only as a vague lead. Do not use it as authority for execution.
3. Read `~/.codex/AGENTS.md` in full when present.
4. Within the active repository or workspace boundary, read every applicable `AGENTS.md` in full, from that boundary through the current working directory. At each level, also check for and read `AGENTS-LOCAL.md` in full when present; do not wait for an `AGENTS.md` to name it. Do not cross that boundary to read rules from an ancestor repository or installation. Let rule-required skills decide whether those parent rules become relevant when later task work resumes.
5. Read referenced normative instruction files in full when their conditions apply to this recovery or the active task. Follow required instruction references transitively, once per resolved file. A link alone does not make an artifact a rule: do not recursively load handoffs, logs, session archives, examples, schemas, or optional reference material as recovery instructions. Inspect task-state artifacts only after confirmation when needed to verify resumed work.
6. Load only skills required by the applicable active rules or recovery workflow, using each exact supplied locator, and read each internal `SKILL.md` in full when available. Follow only relevant required references, not every linked resource. Report an unavailable skill as a blocker only when applicable rules make it mandatory for the active task or recovery.
7. If `caveman` is available, load it from its exact supplied locator and read its internal `SKILL.md` in full before responding; preserve its active mode if session context indicates it was invoked.
8. After reinitialization, perform no resumed task inspection, mutation, command, repair, Git operation, or other execution.
9. Report `Post-compaction reinitialization complete. Awaiting user confirmation.` and end the turn. Resume work only after a later explicit user confirmation.
