# build.ps1 — Compila SmartGraphicsPreference.ps1 para .exe

$input  = Join-Path $PSScriptRoot "..\SmartGraphicsPreference.ps1"
$output = Join-Path $PSScriptRoot "..\SmartGraphicsPreference.exe"

# Instala ps2exe se necessario
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Instalando ps2exe..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force
}

Write-Host "Compilando..." -ForegroundColor Cyan

Invoke-ps2exe `
    -inputFile  $input `
    -outputFile $output `
    -title      "Smart GPU Config" `
    -description "Gerenciador de Preferencia Grafica para Windows" `
    -version    "2.0.0.0" `
    -noConsole:$false

if (Test-Path $output) {
    Write-Host "Pronto! Arquivo gerado: $output" -ForegroundColor Green
} else {
    Write-Host "Falha na compilacao." -ForegroundColor Red
}
