$Error.Clear()


#Inspired from https://github.com/Azure/avdaccelerator
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Write-Output 'TASK COMPLETED: Chocolatey installed'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y dotnetfx --version 4.7.2 --force'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y vcredist140'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y vcredist2017'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y directx'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y python'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y aria2'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y nssm'
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y 7zip'


# https://missionimpossiblecode.io/winrm-for-provisioning-close-the-door-on-the-way-out-eh
powershell.exe -ExecutionPolicy Bypass -Command 'choco install -y undo-winrmconfig-during-shutdown'