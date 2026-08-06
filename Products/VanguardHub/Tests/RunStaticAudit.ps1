$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root 'Reports'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$jsonPath = Join-Path $reportRoot "StaticAudit-$timestamp.json"
$mdPath = Join-Path $reportRoot "StaticAudit-$timestamp.md"

if (-not (Test-Path -LiteralPath $reportRoot)) {
    New-Item -ItemType Directory -Path $reportRoot -Force | Out-Null
}

$luaFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.lua' | Where-Object {
    $_.FullName -notmatch '\\Reports\\'
})
$allFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File)

function Get-RelativePath([string]$path) {
    return $path.Substring($root.Length).TrimStart('\') -replace '\\','/'
}

function Test-ModulePath([string]$modulePath) {
    $candidate = Join-Path $root ($modulePath -replace '/', '\')
    return Test-Path -LiteralPath ($candidate + '.lua')
}

$moduleRefs = New-Object System.Collections.Generic.List[object]
$missingRefs = New-Object System.Collections.Generic.List[object]
$todos = New-Object System.Collections.Generic.List[object]
$placeholders = New-Object System.Collections.Generic.List[object]
$directEnvironmentCalls = New-Object System.Collections.Generic.List[object]
$functions = New-Object System.Collections.Generic.List[object]

foreach ($file in $luaFiles) {
    $relative = Get-RelativePath $file.FullName
    $content = Get-Content -LiteralPath $file.FullName -Raw

    foreach ($match in [regex]::Matches($content, '["'']((?:Core|Games|Loader|Plugins)/[^"'']+)["'']')) {
        $modulePath = $match.Groups[1].Value
        if ($modulePath -match '\.lua$') { continue }
        $exists = Test-ModulePath $modulePath
        $record = [PSCustomObject]@{ File = $relative; Module = $modulePath; Exists = $exists }
        $moduleRefs.Add($record) | Out-Null
        if (-not $exists) { $missingRefs.Add($record) | Out-Null }
    }

    foreach ($match in [regex]::Matches($content, '(TODO|FIXME|planned|Deprecated|return\s+\{\s*\})', 'IgnoreCase')) {
        $item = [PSCustomObject]@{ File = $relative; Match = $match.Value }
        if ($match.Value -match 'TODO|FIXME') { $todos.Add($item) | Out-Null }
        else { $placeholders.Add($item) | Out-Null }
    }

    foreach ($match in [regex]::Matches($content, '(setclipboard|getclipboard|gethui|protect_gui|syn\b|http_request|request\b|readfile|writefile|isfile|makefolder|isfolder|Drawing)')) {
        if ($relative -notmatch '^Core/Services/' -and $relative -notmatch '^Core/Environment/' -and $relative -notmatch '^Core/Executor/' -and $relative -notmatch '^Studio/Runtime/' -and $relative -notmatch '^Loader\.lua$') {
            $directEnvironmentCalls.Add([PSCustomObject]@{ File = $relative; Match = $match.Value }) | Out-Null
        }
    }

    foreach ($match in [regex]::Matches($content, 'function\s+([A-Za-z0-9_:\.]+)')) {
        $functions.Add([PSCustomObject]@{ File = $relative; Name = $match.Groups[1].Value }) | Out-Null
    }
}

$hashGroups = $allFiles | ForEach-Object {
    $hash = Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256
    [PSCustomObject]@{ Path = Get-RelativePath $_.FullName; Hash = $hash.Hash; Length = $_.Length }
} | Group-Object Hash | Where-Object { $_.Count -gt 1 }

$referencedModules = @{}
foreach ($ref in $moduleRefs) { $referencedModules[$ref.Module] = $true }
$unreferencedModules = foreach ($file in $luaFiles) {
    $relative = Get-RelativePath $file.FullName
    $modulePath = $relative -replace '\.lua$',''
    if (-not $referencedModules[$modulePath] -and $relative -notmatch '^(Loader\.lua|Studio/|Tests/|Manifests/)') {
        [PSCustomObject]@{ Module = $modulePath; File = $relative }
    }
}

$requiredGroups = [ordered]@{
    Library = @('Core/Library/Window.lua','Core/Library/Tabs.lua','Core/Library/Sections.lua','Core/Library/WindowManager.lua')
    Loader = @('Loader.lua','Loader/Bootstrap.lua','Loader/GameLoader.lua')
    Config = @('Core/Config/ConfigManager.lua','Core/Config/Schema.lua','Core/Config/Migration.lua','Core/Config/Save.lua','Core/Config/Load.lua')
    Services = @('Core/Services/Clipboard.lua','Core/Services/Http.lua','Core/Services/Filesystem.lua','Core/Services/Storage.lua','Core/Services/Update.lua')
    LT2 = @('Games/LumberTycoon2/Init.lua','Games/LumberTycoon2/Config/Schema.lua','Games/LumberTycoon2/Modules/Utils.lua')
    Themes = @('Core/Themes/Catalog.lua','Core/Themes/Dark.lua','Core/Themes/Purple.lua','Core/Themes/Blue.lua','Core/Themes/Green.lua','Core/Themes/Gold.lua','Core/Themes/Light.lua')
    Plugins = @('Plugins/Registry.lua','Plugins/Loader.lua','Plugins/Permissions.lua')
}

$testResults = foreach ($group in $requiredGroups.GetEnumerator()) {
    $missing = @($group.Value | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root ($_ -replace '/', '\'))) })
    [PSCustomObject]@{
        Name = $group.Key
        Passed = $missing.Count -eq 0
        Missing = $missing
    }
}

$lt2Functions = @($functions | Where-Object { $_.File -match '^Games/LumberTycoon2/' })
$realModules = @($luaFiles | Where-Object {
    $content = Get-Content -LiteralPath $_.FullName -Raw
    $content -notmatch 'return\s+\{\s*\}' -and $content -notmatch 'Status\s*=\s*["'']planned'
})

$summary = [ordered]@{
    Root = $root
    Timestamp = $timestamp
    LuaFiles = $luaFiles.Count
    RealModules = $realModules.Count
    ModuleReferences = $moduleRefs.Count
    MissingReferences = $missingRefs.Count
    Placeholders = $placeholders.Count
    Todos = $todos.Count
    DirectEnvironmentCallsOutsideServices = $directEnvironmentCalls.Count
    DuplicateGroups = @($hashGroups).Count
    UnreferencedModules = @($unreferencedModules).Count
    LT2Functions = $lt2Functions.Count
    TestsPassed = @($testResults | Where-Object { $_.Passed }).Count
    TestsTotal = @($testResults).Count
}

$report = [ordered]@{
    Summary = $summary
    Tests = $testResults
    MissingReferences = $missingRefs
    Placeholders = $placeholders
    Todos = $todos
    DirectEnvironmentCallsOutsideServices = $directEnvironmentCalls
    DuplicateGroups = $hashGroups
    UnreferencedModules = $unreferencedModules
    LT2Functions = $lt2Functions
}

$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding utf8

$md = @()
$md += "# VanguardHub Static Audit"
$md += ""
$md += "- Root: $root"
$md += "- Lua files: $($summary.LuaFiles)"
$md += "- Real modules: $($summary.RealModules)"
$md += "- Module references: $($summary.ModuleReferences)"
$md += "- Missing references: $($summary.MissingReferences)"
$md += "- Placeholders: $($summary.Placeholders)"
$md += "- TODOs: $($summary.Todos)"
$md += "- Direct environment calls outside Services/Environment/Loader: $($summary.DirectEnvironmentCallsOutsideServices)"
$md += "- Duplicate file groups: $($summary.DuplicateGroups)"
$md += "- Unreferenced modules: $($summary.UnreferencedModules)"
$md += "- LT2 functions found: $($summary.LT2Functions)"
$md += "- Test groups passed: $($summary.TestsPassed)/$($summary.TestsTotal)"
$md += ""
$md += "## Test Groups"
$md += ($testResults | ForEach-Object { "- $($_.Name): $($_.Passed)" })
$md += ""
$md += "## Missing References"
$md += ($(if ($missingRefs.Count) { $missingRefs | ForEach-Object { "- $($_.File) -> $($_.Module)" } } else { "- none" }))
$md += ""
$md += "## Direct Calls"
$md += ($(if ($directEnvironmentCalls.Count) { $directEnvironmentCalls | Select-Object -First 50 | ForEach-Object { "- $($_.File): $($_.Match)" } } else { "- none" }))
$md += ""
$md += "## Unreferenced Modules"
$md += ($(if (@($unreferencedModules).Count) { $unreferencedModules | Select-Object -First 80 | ForEach-Object { "- $($_.File)" } } else { "- none" }))

$md -join "`r`n" | Set-Content -LiteralPath $mdPath -Encoding utf8

[PSCustomObject]@{
    Json = $jsonPath
    Markdown = $mdPath
    Summary = $summary
}
