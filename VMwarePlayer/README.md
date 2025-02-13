Open a PowerShell window in Administrator mode.
Execute this command to allow scripts to run:
Set-ExecutionPolicy Bypass -Scope Process -Force
Then run:
.\createVMwareAutostartShrotcut.ps1
This will create a shortcut in the Windows startup folder to launch a .vmx file on login.
