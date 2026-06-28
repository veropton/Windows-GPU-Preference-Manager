# build.ps1 - Builds SmartGraphicsPreference.ps1 into an optional .exe

$input  = Join-Path $PSScriptRoot "..\SmartGraphicsPreference.ps1"
$output = Join-Path $PSScriptRoot "..\SmartGraphicsPreference.exe"

# Install ps2exe for the current user if it is not already available.
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing ps2exe..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force
}

Write-Host "Building executable..." -ForegroundColor Cyan

Invoke-ps2exe `
    -inputFile  $input `
    -outputFile $output `
    -title      "Windows GPU Preference Manager" `
    -description "Interactive per-app GPU preference manager for Windows" `
    -version    "2.0.0.0" `
    -noConsole:$false

if (Test-Path $output) {
    Write-Host "Done. Generated file: $output" -ForegroundColor Green
} else {
    Write-Host "Build failed." -ForegroundColor Red
}