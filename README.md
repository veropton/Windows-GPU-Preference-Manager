# 🚀 Windows GPU Preference Manager

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078d6.svg)](https://www.microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Languages](https://img.shields.io/badge/Languages-Multilingual%20(8%20langs)-orange.svg)](#-multilingual-support)

An interactive, lightweight PowerShell utility to manage per-application GPU preference settings on Windows 10 and Windows 11. It automates the tedious manual configuration found in *Settings > System > Display > Graphics* and runs instantly from the command line without any heavy installation.

---

## 🌎 Idiomas / Languages

* [Read in English](README.md)
* [Leia em Português](README.pt-BR.md)

---

## 💡 Why Use It?

On Windows, changing the GPU preference (Integrated vs. Dedicated High Performance GPU) for individual applications requires clicking through multiple layers of system settings, navigating folders, and selecting executables manually. If you are on a gaming laptop, dual-GPU desktop, or routinely switch preferences for web browsers, media players, streaming tools, game launchers, and 3D modeling packages, doing this one by one is slow and repetitive.

**Windows GPU Preference Manager** resolves this by letting you:
1. **Instantly view** active non-system applications and their current GPU configurations.
2. **Apply High Performance** settings to specific apps, multiple apps, or recommendations in batch with a single command.
3. **Monitor real-time GPU engine utilization** for each active process directly inside the console.

---

## ✨ Features

* ⚡ **Auto-Discovery:** Automatically lists currently running user applications with a valid executable path.
* 🛡️ **System Filter:** Excludes default Windows background system noise and processes automatically.
* 🌐 **Multilingual Support:** Supports **8 major languages** (English, Portuguese, Spanish, French, German, Chinese, Japanese, and Italian) with automatic OS display language detection and manual startup selection.
* 📊 **Live GPU Usage:** Shows live GPU 3D engine utilization percentage per running app when Windows performance counters are active.
* 🎯 **Smart Recommendations:** Automatically highlights applications that commonly benefit from a dedicated GPU (e.g., Chrome, OBS, Discord, VLC, Steam, Blender, Photoshop, games).
* 🔄 **Simple Toggle Flow:** Easily activate High Performance mode or restore Windows defaults.
* 🔍 **Terminal Filter/Search:** Instantly filter list items with the `search` command.
* 📦 **Compile-Ready:** Includes a build script to package the script into a standalone `.exe` using `ps2exe`.

---

## 🛠️ Repository Structure

```text
Windows-GPU-Preference-Manager/
├── SmartGraphicsPreference.ps1   # Core PowerShell script with multilingual support
├── SmartGPU.bat                  # Double-click batch launcher (forwards command args)
├── build/
│   └── build.ps1                 # Optional PS executable builder using ps2exe
├── README.md                     # Documentation (English)
├── README.pt-BR.md               # Documentação (Português)
├── LICENSE                       # MIT License
└── .gitignore                    # Git file exclusions
```

---

## 📋 Requirements

* **Operating System:** Windows 10 or Windows 11
* **Console:** Windows PowerShell 5.1 or newer
* **Hardware:** Systems with dual GPUs (integrated + dedicated graphics such as NVIDIA GeForce/RTX, AMD Radeon, Intel Arc) to leverage the *High Performance* registry preference.

---

## 🚀 How to Run

### Option 1: Double-Click (Recommended)
Double-click `SmartGPU.bat` in the root folder. It bypasses the execution policy automatically.

### Option 2: PowerShell Console
Launch your terminal and execute:
```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1"
```

To run and force a specific language directly, pass the `-Language` argument:
```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1" -Language pt
```
*(Supported language codes: `en`, `pt`, `es`, `fr`, `de`, `zh`, `ja`, `it`)*

---

## 🗺️ Multilingual Support

Upon starting, the tool automatically detects your Windows display culture and uses the corresponding language. It also shows a menu for manual override:

```text
  Select language / Selecione o idioma / Seleccione el idioma:
  ===========================================================
    [1] English       [2] Português      [3] Español
    [4] Français      [5] Deutsch        [6] 简体中文
    [7] 日本語        [8] Italiano

  Press Enter to auto-detect (Default: English)

  Language [1-8]: 
```

---

## 🖥️ Terminal Interface Example

```text
  =====================================================
    Windows GPU Preference Manager   [High Performance]
  =====================================================

  #    App                        Category       GPU%   Status
  ----------------------------------------------------------------
  1    chrome                     Browser        12%    [OK] High Performance
  2    discord                    Communication  2%     [RECOMMENDED]
  3    vlc                        Video          0%     
  4    obs64                      Streaming      8%     [RECOMMENDED]
  5    blender                    3D             0%     [OK] High Performance

  ----------------------------------------------------------------
  Commands:
    1 / 1,3,5       Toggle high-performance preference
    rec / apply     Apply all recommended apps (2 pending)
    search <text>   Filter list
    all             Clear filter
    quit            Close

  Summary: 2 configured, 2 recommended pending
  Filter: ''

  > 
```

---

## 🕹️ Command Reference

| Command | Action |
|---|---|
| `1` | Toggles (adds or removes) the High Performance preference for application number 1. |
| `1,3,5` | Toggles preferences for multiple listed applications simultaneously (separated by commas). |
| `rec` / `apply` | Automatically applies the High Performance preference to all pending recommended applications. |
| `search chrome` | Filters the table view to only show processes containing "chrome". |
| `tweaks` | Opens the Windows Gaming Tweaks optimization menu. |
| `all` | Resets the list and clears any active filters. |
| `quit` | Safely closes the utility. |

> [!NOTE]
> After modifying preferences, restart the target applications for Windows to apply the new GPU routing behavior.

---

## ⚙️ Windows Gaming Tweaks

The tweaks menu provides access to 5 system-level optimization categories:
1. **Services Tuning:** Disables non-essential background services (Print Spooler, Fax, SysMain/Superfetch, Windows Error Reporting).
2. **Network & Latency:** Disables Nagle's TCP algorithm (TCP No Delay & TCP Ack Frequency) on active adapters, sets priority system gaming responsiveness, and disables network throttling.
3. **Visuals & Power:** Optimizes visual effects for maximum performance and activates the "Ultimate Performance" system power scheme.
4. **Telemetry & Privacy:** Disables diagnostic telemetry policies and the Connected User Experiences service.
5. **Game Bar & Xbox:** Disables Game DVR capture overlays and Xbox Live backend startup services.

> [!IMPORTANT]
> - Applying these tweaks requires Administrator privileges. If the script is run in standard mode, it will prompt for confirmation and automatically relaunch itself elevated in a new console window.
> - Before modifying any system settings, a dynamic backup file `.sgp-backup.json` is created in the script folder. You can revert all tweaks to their exact original states at any time using the `restore` or `undo` command in the tweaks menu.

---

## ⚙️ Compilation (Optional .exe)

To generate a standalone `.exe` executable file so you can run the utility without opening PowerShell:
```powershell
PowerShell -ExecutionPolicy Bypass -File "build\build.ps1"
```
The script uses `ps2exe`. If the module is not found, it automatically installs it in your user profile scope and builds `SmartGraphicsPreference.exe`.

---

## 🔍 How it Works Internally

Under the hood, Windows stores graphics preferences per application in the current user's registry hive:
```text
HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences
```
The script writes the application's absolute path as the key name and assigns the value string:
* `GpuPreference=2;` — Configures the app to use **High Performance** (dedicated GPU).
* Deleting the registry key resets the application to the **Windows Default** fallback setting.

---

## 🏷️ GitHub Search Optimization (SEO)

To optimize this repository for discoverability on GitHub, apply the following **Topics** in your GitHub repository settings:

`powershell` · `windows-utility` · `gpu-preference` · `nvidia` · `amd-radeon` · `graphics-preference` · `high-performance` · `performance-tuning` · `gaming-optimization` · `windows11` · `windows10` · `windows-11` · `windows-10` · `gpu-monitor` · `low-overhead` · `multilingual`

### Keywords for Web Indexing:
Windows GPU Preference registry bypass, set GPU per app cmd, PowerShell GPU switcher, force dedicated GPU Windows 10, graphics settings command line, UserGpuPreferences modifier tool, lightweight GPU optimizer.

---

## 🤝 Contributing

Contributions are welcome! If you want to expand the smart recommendations database, add new apps to the `$appDatabase` hashtable in [SmartGraphicsPreference.ps1](file:///c:/Users/User/Desktop/SmartGPU/claude_analisar/SmartGraphicsPreference.ps1):

```powershell
"newapp" = @{ Category = "Games"; Recommended = $true }
```
- `Category`: Choose a category string (Browser, Video, 3D, Design, Video Edit, Streaming, Games, Communication, Developer, Other).
- `Recommended`: Set `$true` for apps that benefit from a dedicated GPU, or `$false` to categorize without auto-recommending.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
