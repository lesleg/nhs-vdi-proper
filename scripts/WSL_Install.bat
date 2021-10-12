REM After running vdi_build_script.ps1, this file should be added to C:\WSL
REM There is a shortcut called Install WSL that will be added to the desktop via GPO, that when launched, will trigger this script

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""c:\wsl\wsl_install.ps1""' -Verb RunAs}"
