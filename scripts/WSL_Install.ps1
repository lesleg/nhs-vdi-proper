$ErrorActionPreference = "Stop"
# After running vdi_build_script.ps1, this file should be added to C:\WSL
# There is a shortcut called Install WSL that will be added to the desktop via GPO than when launched, will trigger this script

######## Create WSL Desktop Shortcut ##########################
$ubuntu_shortcut_path = "$env:Public\Desktop\Ubuntu.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($ubuntu_shortcut_path)
$shortcut.TargetPath = "$env:SystemRoot\System32\wsl.exe"
$shortcut.IconLocation = "C:\WSL\ubuntu.ico"
$shortcut.Save()

####### Set Elevated Rights to the Shortcut ##################
if(Test-Path $ubuntu_shortcut_path)
{
  $bytes = [System.IO.File]::ReadAllBytes($ubuntu_shortcut_path)
  $bytes[0x15] = $bytes[0x15] -bor 0x20
  [System.IO.File]::WriteAllBytes($ubuntu_shortcut_path,$bytes)
}

####### Install Linux Kernel Update ##########################
C:\WSL\.\wsl_update_x64.msi /qr

####### Unzip and Install Ubuntu #############################
Expand-Archive "C:\WSL\ubuntu-2004.zip" ubuntu
$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("PATH", $userenv + (get-location) + "\ubuntu", "User")
.\ubuntu\ubuntu2004.exe
