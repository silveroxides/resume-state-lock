# resume-state-lock

Codex plugin and skill for safe recovery after session compaction.

Repository: https://github.com/silveroxides/resume-state-lock

The SessionStart hook reloads applicable instructions, checks required skills,
and stops until the user confirms continuation.

## Install

Copy this query into Codex:

```text
Install the plugin from https://github.com/silveroxides/resume-state-lock
```

After installation, start a new Codex thread so the plugin and skill catalog
refresh.

## Use

Invoke the skill explicitly with:

```text
$resume-state-lock:resume-state-lock
```

## Hook runtime

The SessionStart hook uses POSIX-shell output on Unix-like systems and hidden
Windows PowerShell output. It has no Python dependency.
