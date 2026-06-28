# PROJECT.md

## Project Vision
**Windows GPU Preference Manager** (also known as `SmartGraphicsPreference`) is a lightweight, zero-dependency, open-source utility designed to give Windows 10 and 11 users quick, command-line control over per-application GPU preference routing. It replaces the slow, manual process of navigating system display settings to assign executables to the dedicated "High Performance" GPU or reset them to default settings.

---

## Core Goals
1. **Reduce Friction:** Eliminate multiple menu clicks to assign graphics preferences.
2. **Batch Capabilities:** Allow configuring all recommended apps or multiple selected processes in a single step.
3. **Transparency:** Provide real-time GPU engine utilization metrics for running applications.
4. **Localization:** Provide a native, automatic, or customizable localization experience for 8 major world languages.
5. **Portability:** Keep the tool lightweight enough to run directly as a script, a batch wrapper, or compile into a standalone `.exe`.

---

## Features
- **Auto-Discovery:** Automatically scans running processes with a valid path.
- **System Filtering:** Excludes system-level processes (like service hosts and explorer) to keep the list clean and actionable.
- **Recommended Database:** Detects and flags typical GPU-intensive programs (browsers, video editors, games, game engines, CAD/3D software).
- **Multilingual Support:** Auto-detects and formats UI outputs based on system locale or CLI argument flags.
- **Real-Time Monitoring:** Retrieves live 3D GPU engine performance counters per process.

---

## Constraints & Compatibility
- **Operating System:** Windows 10 / Windows 11 only.
- **Shell Engine:** PowerShell 5.1 or newer.
- **Encoding Requirements:** Unicode UTF-8 with BOM is mandatory to ensure CJK character sets (Chinese and Japanese) compile and render correctly in legacy Windows consoles.
- **Registry Permissions:** Modifies user-level registry entries under the current user hive (`HKCU`), avoiding the need for administrator elevation.
