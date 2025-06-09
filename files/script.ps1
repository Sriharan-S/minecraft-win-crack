# Minecraft Crack Tool by Sriharan
# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName System.Windows.Forms

# GUI Warning Prompt
$warningMessage = @"
Please SAVE ALL YOUR WORK and CLOSE related applications to Microsoft.
"@

$dialogResult = [System.Windows.Forms.MessageBox]::Show($warningMessage, "Minecraft Crack Tool by Sriharan", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Warning)

if ($dialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
    exit
}

Write-Host "`nStarting Minecraft Crack Tool processing (by Sriharan)..."

function Replace-LockedFile {
    param(
        [Parameter(Mandatory=$true)][string]$TargetFilePath,
        [Parameter(Mandatory=$true)][string]$SourceFileName
    )

    $TargetFileNameOnly = Split-Path -Path $TargetFilePath -Leaf
    Write-Host "`n--- Processing Target File: '$TargetFileNameOnly' --- (Minecraft Crack Tool by Sriharan)"

    # Validate source file existence
    $SourceFilePath = if ($PSScriptRoot) { Join-Path $PSScriptRoot $SourceFileName } else { Join-Path (Get-Location) $SourceFileName }
    if (-NOT (Test-Path -Path $SourceFilePath)) {
        Write-Host "Source file '$SourceFileName' not found."
        return $false
    }
    Write-Host " -> Using replacement file: '$SourceFileName'"

    # Initialize progress bar
    $progressActivity = "Processing $TargetFileNameOnly"
    $progressSteps = 4
    $currentStep = 0

    # Step 1: Update permissions
    $currentStep++
    Write-Progress -Activity $progressActivity -Status "Updating permissions..." -PercentComplete (($currentStep / $progressSteps) * 100)
    try {
        takeown.exe /f $TargetFilePath /a | Out-Null
        icacls.exe $TargetFilePath /grant Administrators:F | Out-Null
        Write-Host "   Permissions updated successfully."
    } catch {
        Write-Host "Failed to update permissions."
        return $false
    }

    # Step 2: Check if file is in use
    $currentStep++
    Write-Progress -Activity $progressActivity -Status "Checking if file is in use..." -PercentComplete (($currentStep / $progressSteps) * 100)
    $ProcessesToKill = @()
    try {
        Get-Process | ForEach-Object {
            try {
                $_.Modules | ForEach-Object {
                    if ($_.FileName -eq $TargetFilePath) {
                        $ProcessesToKill += $_.ModuleName
                    }
                }
            } catch {}
        }
    } catch {}

    $UniqueProcessesToKill = $ProcessesToKill | Sort-Object -Unique
    if ($UniqueProcessesToKill.Count -gt 0) {
        Write-Host " -> Processes using the file detected."
    } else {
        Write-Host "   File does not appear to be in use by any active processes."
    }

    # Step 3: Terminate processes using the file
    $currentStep++
    Write-Progress -Activity $progressActivity -Status "Terminating processes using the file..." -PercentComplete (($currentStep / $progressSteps) * 100)
    if ($UniqueProcessesToKill.Count -gt 0) {
        foreach ($proc in (Get-Process | Where-Object { $_.Modules.FileName -eq $TargetFilePath })) {
            try { Stop-Process -Id $proc.Id -Force } catch {}
        }
        Write-Host "   Processes terminated."
        Start-Sleep -Seconds 5
    }

    # Step 4: Replace the file
    $currentStep++
    Write-Progress -Activity $progressActivity -Status "Replacing the file..." -PercentComplete (($currentStep / $progressSteps) * 100)
    try {
        Copy-Item -Path $SourceFilePath -Destination $TargetFilePath -Force
        Write-Host "   File replaced successfully."
    } catch {
        Write-Host "Failed to replace the file."
        return $false
    }

    # Complete progress
    Write-Progress -Activity $progressActivity -Completed
    Write-Host "--- Finished processing: '$TargetFileNameOnly' --- (Minecraft Crack Tool by Sriharan)"
    return $true
}

Write-Host "Script confirmed running with Administrator privileges. (Minecraft Crack Tool by Sriharan)"

$TargetFile1 = "C:\Windows\System32\Windows.ApplicationModel.Store.dll"
$SourceFile1 = ".\System32\Windows.ApplicationModel.Store.dll"
Write-Host "`nStarting job for: '$(Split-Path $TargetFile1 -Leaf)'"
Replace-LockedFile -TargetFilePath $TargetFile1 -SourceFileName $SourceFile1

$TargetFile2 = "C:\Windows\SysWOW64\Windows.ApplicationModel.Store.dll"
$SourceFile2 = ".\SysWOW64\Windows.ApplicationModel.Store.dll"
Write-Host "`nStarting job for: '$(Split-Path $TargetFile2 -Leaf)'"
Replace-LockedFile -TargetFilePath $TargetFile2 -SourceFileName $SourceFile2

Write-Host ""
Write-Host "All processing jobs finished. (Minecraft Crack Tool by Sriharan)"
Read-Host "Press Enter to exit..."
