# Install Grok Loops kit into ~/.grok (global) or ./.grok (project)
param(
    [switch]$Project,
    [string]$KitRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

if ($Project) {
    $base = Join-Path (Get-Location) ".grok"
    Write-Host "Install mode: PROJECT -> $base"
} else {
    $base = Join-Path $env:USERPROFILE ".grok"
    Write-Host "Install mode: GLOBAL -> $base"
}

$commands = Join-Path $base "commands"
$skills = Join-Path $base "skills"
$loops = Join-Path $base "loops"
$kitStore = Join-Path $base "skills\grok-loops-kit"

New-Item -ItemType Directory -Force -Path $commands, $skills, $loops, $kitStore | Out-Null

# Slash commands
$cmdMap = @{
    "02-learning-loop\commands\skill-loop.md"           = "skill-loop.md"
    "03-multi-agent-review\commands\orchestrate.md"     = "orchestrate.md"
    "04-verification-loop\commands\review-loop.md"      = "review-loop.md"
    "05-workflow-improvement\commands\iterate.md"       = "iterate.md"
    "06-zero-errors-to-goals\loop-zero-errors.md"       = "loop-zero-errors.md"
}

foreach ($src in $cmdMap.Keys) {
    $from = Join-Path $KitRoot $src
    $to = Join-Path $commands $cmdMap[$src]
    if (Test-Path $from) {
        Copy-Item -Force $from $to
        Write-Host "  command: $($cmdMap[$src])"
    }
}

# loop-architect skill
$laSrc = Join-Path $KitRoot "loop-architect"
$laDst = Join-Path $skills "loop-architect"
if (Test-Path $laSrc) {
    New-Item -ItemType Directory -Force -Path $laDst | Out-Null
    Copy-Item -Recurse -Force (Join-Path $laSrc "*") $laDst
    Write-Host "  skill: loop-architect"
}

# ready loop spec
$loopSrc = Join-Path $KitRoot "06-zero-errors-to-goals\loops\zero-errors-to-goals-loop.md"
if (Test-Path $loopSrc) {
    Copy-Item -Force $loopSrc (Join-Path $loops "zero-errors-to-goals-loop.md")
    Write-Host "  loop: zero-errors-to-goals-loop.md"
}

# store personas + process templates for orchestrators to read
$copyDirs = @(
    "02-learning-loop\personas",
    "03-multi-agent-review\personas",
    "04-verification-loop\personas",
    "05-workflow-improvement\personas",
    "05-workflow-improvement\process",
    "01-stateless-goal",
    "runners"
)
foreach ($rel in $copyDirs) {
    $from = Join-Path $KitRoot $rel
    if (Test-Path $from) {
        $to = Join-Path $kitStore $rel
        New-Item -ItemType Directory -Force -Path (Split-Path $to) | Out-Null
        Copy-Item -Recurse -Force $from $to
        Write-Host "  kit: $rel"
    }
}

# README pointer
Copy-Item -Force (Join-Path $KitRoot "README.md") (Join-Path $kitStore "README.md")

Write-Host ""
Write-Host "Done. Restart Grok session or wait for skill reload."
Write-Host "Try: /loop-zero-errors  |  /orchestrate  |  /review-loop  |  /skill-loop  |  /iterate  |  /loop-architect"
Write-Host "Personas live at: $kitStore"
