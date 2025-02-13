# Define the Startup folder path
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Predefined .vmx file location
$defaultVmxPath = "C:\Users\James-Server\Documents\VMWare\ha\ha.vmx"

# Ask the user for the shortcut name
$shortcutName = Read-Host "Enter the shortcut name (without extension)"
$shortcutPath = "$startupPath\$shortcutName.lnk"

# Ask the user for the .vmx file path (with a default option)
$vmxPath = Read-Host "Enter the path to the .vmx file (Press Enter to use the default: $defaultVmxPath)"
if ([string]::IsNullOrWhiteSpace($vmxPath)) {
    $vmxPath = $defaultVmxPath
}

# Check if the shortcut already exists
if (Test-Path $shortcutPath) {
    $choice = Read-Host "Shortcut already exists. Overwrite? (Y/N)"
    if ($choice -ne "Y") {
        Write-Host "Operation canceled."
        exit
    }
}

# Create the WScript Shell object
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)

# Set the shortcut properties
$shortcut.TargetPath = "C:\Program Files (x86)\VMware\VMware Player\vmrun.exe"
$shortcut.Arguments = "start `"$vmxPath`""
$shortcut.WorkingDirectory = "C:\Program Files (x86)\VMware\VMware Player"  # Start In
$shortcut.IconLocation = "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
$shortcut.Save()

Write-Host "`nShortcut '$shortcutName' created successfully in Startup."
Start-Process explorer.exe -ArgumentList $startupPath