$ErrorActionPreference = 'Stop'
$skillPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../skills/resume-state-lock/SKILL.md'))
if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
    @{
        continue = $false
        stopReason = "Required resume-state-lock skill unavailable: $skillPath"
        systemMessage = "Recovery remains locked. Required skill unavailable: $skillPath"
    } | ConvertTo-Json -Compress
    exit 0
}
$quotedPath = $skillPath.Replace("'", "''")
Write-Output "Verified installed SKILL.md locator for this invocation: $skillPath"
Write-Output "Load this exact locator; preserve repeated directory names and special characters. Do not reconstruct a cache path from the plugin name or version. This filesystem-verified locator takes precedence over an inconsistent or missing catalog locator."
Write-Output "PowerShell load command: rg -n -U --pcre2 '(?s)\A.*\z' -- '$quotedPath'"
Write-Output 'PowerShell quoting contract: copy the load command unchanged into the shell tool command field. If the tool uses JSON, JSON-encode that string once; JSON escapes are not PowerShell escapes. Do not add another powershell -Command wrapper, use backslash-escaped quotes in PowerShell, or convert the single-quoted path to a double-quoted expandable string.'
Write-Output 'The path is literal data: spaces, +, brackets, parentheses, $, backticks, &, and semicolons inside the quoted argument must not be interpreted or removed. Embedded apostrophes have already been doubled for PowerShell. Do not escape or normalize them again. A +timestamp suffix is part of the directory name.'
Write-Output 'For ripgrep in PowerShell, use single-quoted regex patterns by default so $, backticks, and double quotes are not expanded or reinterpreted by the shell. Regex escaping and shell quoting are separate layers. Use rg -F for literal text, and -- before positional patterns/paths. Do not use double-quoted regex patterns unless variable interpolation is explicitly required and validated.'
Write-Output 'When a ripgrep regex must match a literal double quote through legacy Windows PowerShell native argument passing, prefer the regex escape \x22 instead of nesting raw double quotes. This is a regex escape, not a PowerShell quote escape. Use \r?$ for exact-line matches against files that may contain CRLF.'
Write-Output "PowerShell path diagnostic command: Get-Item -LiteralPath '$quotedPath' -ErrorAction Stop | Select-Object FullName, PSIsContainer | ConvertTo-Json -Compress"
Write-Output 'If loading fails, first distinguish a PowerShell ParserError, native-command argument error, access error, and actual missing file. A malformed command is not evidence that the skill is absent. Run the supplied literal-path diagnostic once without rewriting its path; if it resolves, correct only the invocation/quoting. If it still fails, report the exact path and error category, keep recovery locked, and do not search for substitute paths or cycle through speculative commands.'
Write-Output 'MANDATORY POST-COMPACTION LOCK: First load $resume-state-lock:resume-state-lock. For a filesystem-backed skill, loading means reading the exact SKILL.md locator supplied above or in the skill catalog; do not search for a callable tool, inspect or filter ALL_TOOLS, query MCP capabilities, or enumerate tool/skill catalogs. If no locator is supplied, make only an exact-name load attempt. Only if that fails, report the exact blocker and stop. Treat compacted summary only as a vague lead. Perform no resumed task execution or mutation. Read all applicable rule files in full, recursively. Load only skills named or required by those rules, using each exact supplied locator, and read their SKILL.md files in full. Report unavailable skills only when rules make them mandatory. Then end turn awaiting explicit user confirmation.'
