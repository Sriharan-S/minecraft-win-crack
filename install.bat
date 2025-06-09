@echo off
set "script=%~dp0\files\script.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%script%\"' -Verb RunAs"
