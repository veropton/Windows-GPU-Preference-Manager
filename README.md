# Windows GPU Preference Manager

> Interactive PowerShell script to set per-app GPU preference on Windows 10 and Windows 11.

Windows GPU Preference Manager, also distributed as `SmartGraphicsPreference`, helps you choose which Windows apps should use the high-performance GPU. It automates the manual Windows path in Settings > System > Display > Graphics settings and runs directly in the terminal with no required installer.

[Leia em Portugues](README.pt-BR.md)

GitHub description: `Interactive PowerShell script to set per-app GPU preference on Windows`

Recommended topics: `powershell`, `windows`, `gpu`, `windows10`, `windows11`

## Why

Windows lets you choose a GPU preference per app, but the option is buried in the system graphics settings. If you use a laptop with integrated and dedicated graphics, or switch between browsers, Discord, OBS, VLC, Blender, editors and games, configuring this manually is slow.

This project lists running apps, highlights apps that usually benefit from a dedicated GPU, and writes the high-performance preference for the current Windows user.

## Features

- Detects running apps with a valid executable path
- Filters common Windows system processes and terminal noise
- Recommends known GPU-accelerated apps automatically
- Shows live GPU usage when Windows GPU counters are available
- Sets high-performance GPU preference for one app, many apps, or all recommended apps
- Includes a terminal search/filter command
- Uses a toggle flow to remove a preference and return to the Windows default
- Runs on PowerShell 5.1+ in Windows 10 and Windows 11

## Use Cases

- Force a browser, video player, streaming app, game launcher, or creative tool to use the dedicated GPU
- Tune Discord, OBS, VLC, Blender, editing tools, and game launchers with fewer clicks
- Check which running apps are currently using GPU resources
- Share a lightweight Windows utility without shipping a heavy desktop app

## Repository Structure

```text
Windows-GPU-Preference-Manager/
|-- SmartGraphicsPreference.ps1   # Main PowerShell script
|-- SmartGPU.bat                  # Double-click launcher
|-- build/
|   `-- build.ps1                 # Builds an optional .exe with ps2exe
|-- README.md
|-- README.pt-BR.md
|-- LICENSE
`-- .gitignore
```

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or newer
- A dedicated GPU, such as NVIDIA, AMD Radeon, or Intel Arc, if you want to use high-performance mode

## Usage

Run from PowerShell:

```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1"
```

Or double-click `SmartGPU.bat` from the same folder as `SmartGraphicsPreference.ps1`.

## Interface

```text
  =====================================================
    Preferencia Grafica Inteligente   [Alto Desempenho]
  =====================================================

  #    App                        Categoria    GPU%   Status
  ----------------------------------------------------------------
  1    chrome                     Navegador    12%    [OK] Alto Desempenho
  2    discord                    Comunicacao   2%    [RECOMENDADO]
  3    vlc                        Video         0%
  4    obs64                      Streaming     8%    [RECOMENDADO]

  Comandos:
    1 / 1,3,5    Ativar ou remover (toggle)
    rec          Aplicar TODOS os recomendados (2 pendentes)
    busca <x>    Filtrar lista (ex: busca discord)
    todos        Limpar filtro
    sair         Fechar
```

## Commands

| Command | Action |
|---|---|
| `1` | Enables or removes the preference for app number 1 |
| `1,3,5` | Enables or removes several apps at once |
| `rec` | Applies high-performance preference to all pending recommended apps |
| `busca discord` | Filters the list by app name |
| `todos` | Clears the current filter |
| `sair` | Exits the script |

Restart affected apps after changing GPU preference so Windows can apply the new setting.

## Build Optional EXE

The `.exe` is optional. The PowerShell script works by itself.

```powershell
PowerShell -ExecutionPolicy Bypass -File "build\build.ps1"
```

The build script uses `ps2exe`. If the module is not installed, it tries to install it for the current user.

## How It Works

The script writes per-user GPU preferences to:

```text
HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences
```

It uses `GpuPreference=2` for high performance, matching the Windows Graphics settings behavior. The change applies to the current Windows user.

## Search Keywords

PowerShell, Windows, Windows 10, Windows 11, GPU, dedicated GPU, integrated GPU, NVIDIA, AMD Radeon, Intel Arc, graphics settings, GPU preference, per-app GPU preference, UserGpuPreferences, high performance GPU, Windows graphics settings.

## Contributing

The easiest contribution is adding known apps to the `$appsDB` dictionary in `SmartGraphicsPreference.ps1`.

```powershell
$appsDB = @{
    "myapp" = @{ Cat = "Video"; Rec = $true }
}
```

Use `Rec = $true` for apps that usually benefit from a dedicated GPU. Use `Rec = $false` for apps that should be categorized without an automatic recommendation.

## License

MIT. See `LICENSE`.
