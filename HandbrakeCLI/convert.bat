@echo off
setlocal enabledelayedexpansion

:: Get path of HandBrakeCLI from path file
set /p CLI_PATH=<"%~dp0path"

:: Define path to HandBrakeCLI
set "HANDBRAKE_PATH=%CLI_PATH%\HandBrakeCLI.exe"

:: Define path to the preset
set "PRESET_FILE=%CLI_PATH%\presets\Dashcam.json"

:: Check if a file or folder was dragged onto the script
if "%~1"=="" (
    echo Drag a video file or folder onto this script to convert.
    pause
    exit /b
)

:: Prompt user for start and end times
set /p start_time="Enter start time (in seconds) (Press Enter for 0): "
if "%start_time%"=="" set start_time=0

set /p end_time="Enter end time (in seconds from start time) (Press Enter to use full video length): "

:: Process all dragged files or folders
for %%F in (%*) do (
    call :process_item "%%~F"
)

pause
exit /b

:: Function to process individual files or directories
:process_item
set "input_path=%~1"

:: If it's a folder, process all files inside
if exist "%input_path%\*" (
    for %%V in ("%input_path%\*.*") do (
        call :convert "%%~V"
    )
) else (
    call :convert "%input_path%"
)
exit /b

:: Function to convert a single file
:convert
set "input_file=%~1"
set "output_dir=%~dp1Converted"
set "output_file=%output_dir%\%~n1.mp4"

:: Create output directory if it doesn't exist
if not exist "%output_dir%" mkdir "%output_dir%"

echo Processing: "%input_file%"

:: Delete existing file before encoding (ensures overwrite)
if exist "%output_file%" del "%output_file%"

:: Build HandBrake command dynamically
set "command=%HANDBRAKE_PATH% -i "%input_file%" -o "%output_file%" --preset-import-file "%PRESET_FILE%" --preset="Dashcam" --start-at seconds:%start_time%"
if not "%end_time%"=="" set "command=%command% --stop-at seconds:%end_time%"

:: Run the command
echo Running: %command%
%command%

echo Done: "%output_file%"
exit /b
