# Ensure a folder path is provided (drag-and-drop support)
if ($args.Count -eq 0) {
    Write-Host "Error: No folder provided. Drag and drop the parent folder containing JPG and RAW folders onto this script."
    exit
}

# Get the parent directory (dragged-and-dropped folder)
$parentDir = $args[0] -replace '"', ''  # Remove quotes if present

# Ensure the parent directory exists
if (-Not (Test-Path $parentDir -PathType Container)) {
    Write-Host "Error: The specified directory does not exist."
    exit
}

# Define JPG and RAW folder paths
$jpgFolder = Join-Path -Path $parentDir -ChildPath "JPGs"
$rawFolder = Join-Path -Path $parentDir -ChildPath "RAW"

# Check if the JPG folder exists
if (-Not (Test-Path $jpgFolder -PathType Container)) {
    $jpgFolder = Read-Host "JPG folder not found. Enter the correct folder name"
    $jpgFolder = Join-Path -Path $parentDir -ChildPath $jpgFolder
    if (-Not (Test-Path $jpgFolder -PathType Container)) {
        Write-Host "Error: The specified JPG folder does not exist."
        exit
    }
}

# Check if the RAW folder exists
if (-Not (Test-Path $rawFolder -PathType Container)) {
    $rawFolder = Read-Host "RAW folder not found. Enter the correct folder name"
    $rawFolder = Join-Path -Path $parentDir -ChildPath $rawFolder
    if (-Not (Test-Path $rawFolder -PathType Container)) {
        Write-Host "Error: The specified RAW folder does not exist."
        exit
    }
}

# Get file lists
$a = Get-ChildItem -Path $jpgFolder -File -Filter *.JPG
$b = Get-ChildItem -Path $rawFolder -File -Filter *.ARW

# Compare and remove files not present in JPG folder
Compare-Object $a.BaseName $b.BaseName | Where-Object { $_.SideIndicator -eq "=>" } | ForEach-Object {
    $name = $_.InputObject
    $file = $b | Where-Object { $_.BaseName -eq $name }

    if ($file.Count -gt 1) {
        throw "Conflict: More than one RAW file has the name $name"
    } else {
        Remove-Item -Path $file.FullName -Force
        Write-Host "Deleted: $($file.FullName)"
    }
}

Write-Host "Sync complete."