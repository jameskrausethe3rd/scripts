# Ensure a folder path is provided (drag-and-drop support)
if ($args.Count -eq 0) {
    Write-Host "Error: No folder provided. Drag and drop the parent folder containing the files onto this script."
    exit
}

# Get the parent directory (dragged-and-dropped folder)
$sourceFolder = $args[0] -replace '"', ''  # Remove quotes if present
$folderName = Split-Path $sourceFolder -Leaf

# Get the full script file path and ignore it when processing
$scriptFile = Split-Path $MyInvocation.MyCommand.Definition -Leaf

Get-ChildItem -Path $sourceFolder -File | Where-Object { 
    $_.Extension -match '\.(jpg|JPG|jpeg|jpeg|png|PNG|gif|GIF|arw|ARW|dng|DNG)$' -and $_.Name -ne $scriptFile
} | ForEach-Object {
    $file = $_
    Write-Host "Processing: $($file.Name)"

    # Use ExifTool to get DateTimeOriginal
    $dateTaken = $null
    try {
        $dateOutput = & exiftool -DateTimeOriginal -s3 -d "%Y-%m-%d" $file.FullName
        if ($dateOutput -match '^\d{4}-\d{2}-\d{2}$') {
            $dateTaken = $dateOutput
            Write-Host "Date Taken (ExifTool): $dateTaken"
        } else {
            $dateTaken = $file.CreationTime.ToString("yyyy-MM-dd")
            Write-Host "Fallback to CreationTime: $dateTaken"
        }
    } catch {
        $dateTaken = $file.CreationTime.ToString("yyyy-MM-dd")
        Write-Host "Error reading metadata, using CreationTime: $dateTaken"
    }

    $targetFolder = Join-Path $sourceFolder "$dateTaken\$folderName"

    if (-not (Test-Path $targetFolder)) {
        Write-Host "Creating folder: $targetFolder"
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    }

    Move-Item -Path $file.FullName -Destination $targetFolder
    Write-Host "Moved: $($file.Name) → $targetFolder"
}
