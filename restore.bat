@echo off
REM Restores apps removed by debloat.bat.
REM Usage: restore.bat                -> restores everything in removed.log
REM        restore.bat com.miui.notes -> restores one package
cd /d "%~dp0"
if not "%~1"=="" (adb shell cmd package install-existing %~1 & pause & exit /b)
if not exist removed.log (echo Nothing to restore. & pause & exit /b)
for /f "usebackq" %%P in ("removed.log") do (
  adb shell cmd package install-existing %%P
)
pause
