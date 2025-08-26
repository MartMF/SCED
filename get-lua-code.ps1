param(
    [string]$JsonFile
)

if (-Not (Test-Path $JsonFile)) {
    Write-Host "Error: File not found: $JsonFile"
    exit 1
}

# Get the folder where the script is being run
$scriptFolder = Get-Location

# Extract LuaScript string (keeps escaped sequences)
$rawContent = Get-Content $JsonFile | ForEach-Object {
    if ($_ -match '"LuaScript"\s*:\s*"((?:\\.|[^"])*)"' ) {
        $matches[1]
    }
}

# Decode escaped sequences into real characters
$decoded = $rawContent -replace '\\n', "`r`n"
$decoded = $decoded -replace '\\t', "`t"
$decoded = $decoded -replace '\\r', "`r"
$decoded = $decoded -replace '\\"', '"'
$decoded = $decoded -replace '\\\\', '\'

# Save to file.txt in script folder
$outFile = Join-Path $scriptFolder "file.txt"
$decoded | Set-Content $outFile -Encoding UTF8

Write-Host "Readable LuaScript saved to $outFile"
