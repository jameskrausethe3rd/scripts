# PowerShell script to copy only new files from a local directory to a remote directory using SCP

# Load configuration from config.ps1
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptPath "config.ps1"

if (-Not (Test-Path $configPath)) {
    Write-Host "Error: Configuration file 'config.ps1' not found." -ForegroundColor Red
    exit
}

. $configPath  # Import configuration variables

# Check if local directory exists
if (-Not (Test-Path $localDir)) {
    Write-Host "Error: Local directory does not exist." -ForegroundColor Red
    exit
}

# Get the list of files in the local directory
$localFiles = Get-ChildItem -Path $localDir -File

# Check if there are files to copy
if ($localFiles.Count -eq 0) {
    Write-Host "No new files to copy." -ForegroundColor Yellow
    exit
}

# Get the list of files on the remote system
$remoteFilesCommand = "ssh -i `"$privateKey`" $remoteUser@$remoteHost `"powershell -Command `"Get-ChildItem -Name `"$remoteDir`"`"`""
$remoteFiles = Invoke-Expression $remoteFilesCommand 2>$null

# # Print files
# $transferredFiles = @()
# foreach ($file in $remoteFiles) {
#     Write-Host $file -ForegroundColor Yellow
# }

# Copy only new files
$transferredFiles = @()
foreach ($file in $localFiles) {
    if ($remoteFiles -notcontains $file.Name) {
        $scpCommand = "scp -i `"$privateKey`" `"$($file.FullName)`" $remoteUser@`"$remoteHost`":`"$remoteDir\`""
        # Write-Host $scpCommand -ForegroundColor Yellow
        Invoke-Expression $scpCommand
        $transferredFiles += $file.Name
    }
}

# Logging
if ($transferredFiles.Count -gt 0) {
    Write-Host "Transferred files:" -ForegroundColor Green
    $transferredFiles | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No new files were copied." -ForegroundColor Yellow
}
