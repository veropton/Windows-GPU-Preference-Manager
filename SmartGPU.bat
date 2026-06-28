@echo off
title Windows GPU Preference Manager
powershell.exe -ExecutionPolicy Bypass -File "%~dp0SmartGraphicsPreference.ps1" %*
pause
