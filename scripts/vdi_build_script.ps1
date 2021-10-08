$ErrorActionPreference = "Stop"

# This should be run on an Amazon Workspace using a fresh `Power with Windows 10 (Server 2019 based) (PCoIP)` image
# Ensure that there is no disk encryption so that we can make an image from it after
# Create a new file with the same name on the workspace, and copy in these contents. Then open a powershell window as administator and run the script.
# powershell -ExecutionPolicy Bypass -File D:\path\to\vdi_build_script.ps1
# After this script has run, ensure that all windows updates are installed and add WSL_Install.ps1 to C:\WSL
# TODO: Install all windows updates programmatically in this script

Write-Host "Uninstalling unneeded applications"

if (Test-Path -Path "$Env:ProgramFiles\Mozilla Firefox\") {
    & "$Env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe" /S
}

Write-Host "Disabling unneeded windows features"

Disable-WindowsOptionalFeature -FeatureName "WindowsMediaPlayer" -Online -NoRestart -Remove
Disable-WindowsOptionalFeature -FeatureName "Internet-Explorer-Optional-amd64" -Online -NoRestart -Remove

Write-Host "Installing chocolatey"

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "Installing chocolatey applications"

choco install -y googlechrome vscode pycharm git pycharm-community notepadplusplus awscli jq make
choco install -y python --version=3.7.9

Write-Host "Unpinning items from start menu"

function Unpin-App-From-Start-Menu {
    param (
        [string]$appname
    )
    
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}
}

Unpin-App-From-Start-Menu "Server Manager"
Unpin-App-From-Start-Menu "Task Manager"
Unpin-App-From-Start-Menu "Event Viewer"
Unpin-App-From-Start-Menu "Remote Desktop Connection"
Unpin-App-From-Start-Menu "This PC"
Unpin-App-From-Start-Menu "File Explorer"
Unpin-App-From-Start-Menu "Control Panel"
Unpin-App-From-Start-Menu "Command Prompt"
Unpin-App-From-Start-Menu "Task Manager"
Unpin-App-From-Start-Menu "Windows Administrative Tools"

Write-Host "Removing Extra Desktop shortcuts"

Remove-Item C:\Users\Public\Desktop\*lnk –Force

Write-Host "Removing start menu shortcuts"

Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Administrative Tools\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Amazon Web Services\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Accessories\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Accessibility\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\System Tools\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "$Env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" -recurse|ForEach-Object { Remove-Item $_ }

Get-ChildItem "D:\Users\$Env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessories\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "D:\Users\$Env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }
Get-ChildItem "D:\Users\$Env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\*.lnk" -recurse|ForEach-Object { Remove-Item $_ }

Write-Host "Enabling WSL and downloading the required files"

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

New-Item -Path "C:\" -Name "WSL" -ItemType "directory"

# TODO: Store these files in the repo, or get them from somewhere more trustworthy

# Download the Linux kernel update package for x64 machines
# https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package
curl.exe -L -o 'C:\WSL\wsl_update_x64.msi' https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

# Download Ubuntu 20.04 for WSL
# https://docs.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions
curl.exe -L -o 'C:\WSL\ubuntu-2004.zip' https://aka.ms/wslubuntu2004

# Download an icon for the Ubuntu shorcut that will be optionally created later
curl.exe -L -o 'C:\WSL\Ubuntu.ico' https://www.iconfinder.com/icons/98007/download/ico/512

Write-Host "Restarting to finish applying changes"

Restart-Computer
