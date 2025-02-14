This script will create a shortcut in the Windows startup folder to launch a .vmx file on login.

How to use:
1. Open a **PowerShell** window in **Administrator** mode.

2. Execute this command to allow scripts to run:
    ```
    Set-ExecutionPolicy Bypass -Scope Process -Force
    ```

3. Then run:
    ```
    .\createVMwareAutostartShrotcut.ps1
    ```
