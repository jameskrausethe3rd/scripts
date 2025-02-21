This script will copy files from the configured source folder that don't exist in the configured destination folder using SCP and a SSH key.

Pre-requisites:

- Edit `config.ps1.DEFAULT` and remove the `.DEFAULT` extension.

How to use:

- Run `syncLocalToRemote.ps1` from a PowerShell window.\
  \
   If scripting isn't allowed:

  - Run `runSync.bat` from your PowerShell window.

    OR

  - Run this in your PowerShell window to allow scripting for just this session:
  - `Set-ExecutionPolicy Bypass -Scope Process -Force`

    OR

  - Run this in your PowerShell window to allow scripting for all sessions (Not recommended):
  - `Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force`

  Now run `syncLocalToRemote.ps1`.
