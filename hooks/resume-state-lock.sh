#!/bin/sh

set -eu
hook_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
skill_path="$hook_dir/../skills/resume-state-lock/SKILL.md"
if [ ! -f "$skill_path" ]; then
    printf '%s\n' "Recovery remains locked. Required skill unavailable: $skill_path" >&2
    # SessionStart interprets this JSON as a stopped hook; do not continue unlocked.
    printf '%s\n' '{"continue":false,"stopReason":"Required resume-state-lock skill unavailable; see hook stderr."}'
    exit 0
fi
quoted_path=$(printf '%s' "$skill_path" | sed "s/'/'\\\\''/g")
printf '%s\n' "Verified installed SKILL.md locator for this invocation: $skill_path"
printf '%s\n' 'Load this exact locator; preserve repeated directory names and special characters. Do not reconstruct a cache path from the plugin name or version. This filesystem-verified locator takes precedence over an inconsistent or missing catalog locator.'
printf '%s\n' "POSIX load command: cat -- '$quoted_path'"
cat <<'MESSAGE'
MANDATORY POST-COMPACTION LOCK: First load $resume-state-lock:resume-state-lock. For a filesystem-backed skill, loading means reading the exact SKILL.md locator supplied above or in the skill catalog; do not search for a callable tool, inspect or filter ALL_TOOLS, query MCP capabilities, or enumerate tool/skill catalogs. If no locator is supplied, make only an exact-name load attempt. Only if that fails, report the exact blocker and stop. Treat compacted summary only as a vague lead. Perform no resumed task execution or mutation. This lock applies to the root thread only; children recover through their parent. Read applicable normative rule files in full, following required instruction references only when their conditions apply. Do not recursively load handoffs, logs, session archives, examples, schemas, or optional references as rules. Load only skills named or required by the applicable active rules or recovery workflow, using each exact supplied locator, and read their SKILL.md files in full. Report unavailable skills only when rules make them mandatory. Then end turn awaiting explicit user confirmation.
MESSAGE
