# ARCHITECTURE.md

## High-Level System Architecture
This utility runs as a single-module CLI script with zero external runtime dependencies. It interacts directly with the Windows Registry API and local process APIs.

```mermaid
graph TD
    A[SmartGPU.bat / CLI Launch] --> B(SmartGraphicsPreference.ps1)
    B --> C{Locale / Argument Detection}
    C -->|Language Set| D[Load Selected localized strings]
    B --> E[Fetch Running App Processes]
    B --> F[Fetch GPU Utilization Counters]
    B --> G[Read Registry: UserGpuPreferences]
    D & E & F & G --> H[Render Interactive Console Table]
    H --> I[User Input Interface]
    I -->|1. Toggle Preference| J[Write/Remove Registry Value]
    I -->|2. Search / Filter| K[Apply Filter & Re-render]
    I -->|3. Exit / Quit| L[Close Session]
    J --> H
    K --> H
```

---

## Component Details

### 1. Script Entry & Parameters
- **Script File:** [SmartGraphicsPreference.ps1](file:///c:/Users/User/Desktop/SmartGPU/claude_analisar/SmartGraphicsPreference.ps1)
- **Startup Parameters:**
  - `[string]$Language`: Optional. Force English (`en`), Portuguese (`pt`), Spanish (`es`), French (`fr`), German (`de`), Chinese (`zh`), Japanese (`ja`), or Italian (`it`).
- **Batch Wrapper:** [SmartGPU.bat](file:///c:/Users/User/Desktop/SmartGPU/claude_analisar/SmartGPU.bat) forwards all parameter arguments using `%*`.

### 2. Localization System
- Encapsulated inside a single `$translations` multi-dimensional hashtable.
- UI elements, column names, categories, command keywords, and status tags are fully mapped to keys.
- Input validation matches user-typed keywords against both English defaults and localized aliases.
- Handles console output translation by setting `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` to correctly render CJK and accented characters.

### 3. Registry Management
- **Target Hive:** `HKEY_CURRENT_USER` (allows modification without admin privileges).
- **Target Key Path:** `HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences`
- **Preference Values:**
  - `GpuPreference=2;` — Sets High Performance.
  - Value property removal — Reverts to Windows Default (application fallback).
  - *Note: Registry API commands used are `Get-ItemProperty`, `Set-ItemProperty`, and `Remove-ItemProperty`.*

### 4. Process Scan & GPU Utilization
- **Process Scan:** Retrieves running processes with `Get-Process`. Filters out items present in `$systemProcessNames` and processes without a valid executable path.
- **GPU Counter Query:** Queries `\GPU Engine(*engtype_3D*)\Utilization Percentage` using `Get-Counter`.
  - Extract PID via Regex match: `pid_(\d+)`
  - Calculates maximum 3D utilization percent per active process.

### 5. Packaging / Standalone Executable
- **Build Script:** [build/build.ps1](file:///c:/Users/User/Desktop/SmartGPU/claude_analisar/build/build.ps1)
- Packages the script into a console executable `SmartGraphicsPreference.exe` using `ps2exe`.
