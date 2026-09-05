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
Write-Output 'MANDATORY POST-COMPACTION LOCK: First load $resume-state-lock:resume-state-lock. For a filesystem-backed skill, loading means reading the exact SKILL.md locator supplied above or in the skill catalog; do not search for a callable tool, inspect or filter ALL_TOOLS, query MCP capabilities, or enumerate tool/skill catalogs. If no locator is supplied, make only an exact-name load attempt. Only if that fails, report the exact blocker and stop. Treat compacted summary only as a vague lead. Perform no resumed task execution or mutation. Read all applicable rule files in full, recursively. Load only skills named or required by those rules, using each exact supplied locator, and read their SKILL.md files in full. Report unavailable skills only when rules make them mandatory. Then end turn awaiting explicit user confirmation.'
