@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\moveIntoDateFolder.ps1" "%~1"