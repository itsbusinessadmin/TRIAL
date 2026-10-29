@echo off
REM POCO X3 Pro debloater for Windows (no root). Reversible with restore.bat.
REM Usage: debloat.bat            -> removes tier 1 (ads) + tier 2 (bloat)
REM        debloat.bat optional   -> also removes tier 3
setlocal EnableDelayedExpansion
cd /d "%~dp0"

where adb >nul 2>&1 || (echo adb not found. Put this folder inside platform-tools or add adb to PATH. & pause & exit /b 1)
adb get-state >nul 2>&1 || (echo No device. Enable USB debugging and accept the prompt on the phone. & pause & exit /b 1)

set LISTS=lists\1-ads-telemetry.txt lists\2-bloat-apps.txt
if /i "%~1"=="optional" set LISTS=%LISTS% lists\3-optional.txt

for %%L in (%LISTS%) do (
  for /f "usebackq eol=# tokens=1" %%P in ("%%L") do (
    findstr /r /x /c:"%%P *" /c:"%%P *#.*" lists\DO-NOT-REMOVE.txt >nul
    if !errorlevel!==0 (
      echo SKIP protected %%P
    ) else (
      adb shell pm uninstall -k --user 0 %%P 2>nul | findstr Success >nul
      if !errorlevel!==0 (echo removed  %%P & echo %%P>>removed.log) else (echo not installed / failed  %%P)
    )
  )
)
echo.
echo Done. Reboot the phone. Undo with restore.bat
pause
