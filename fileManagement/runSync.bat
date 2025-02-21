@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\syncLocalToRemote.ps1" "%~1"