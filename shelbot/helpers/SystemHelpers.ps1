# SystemHelpers.ps1

function Test-RebootRequired {
    $rebootRequired = $false
    if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue) {
        $rebootRequired = $true
    }
    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) {
        $rebootRequired = $true
    }
    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) {
        $rebootRequired = $true
    }
    return $rebootRequired
}

function Check-And-Install-WindowsUpdates {
    param (
        [string]$model = $defaultModel
    )
    Write-Host "Checking for Windows updates..."
    try {
        Import-Module PSWindowsUpdate
    } catch {
        Write-Error "PSWindowsUpdate module is not available. Please install the module first."
        exit 1
    }
    $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose -ErrorAction SilentlyContinue
    if ($updates) {
        Write-Host "Updates available. Installing updates..."
        Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose -ErrorAction SilentlyContinue
        $installSummary = "Installed the following updates: " + ($updates | ForEach-Object { $_.Title } | Out-String)
        Write-Host $installSummary
        $rebootRequired = Test-RebootRequired
        if ($rebootRequired -eq $true) {
            Write-Host "A reboot is required to complete the installation of updates."
            $response = "Updates installed. A reboot is required."
        } else {
            Write-Host "No reboot is required."
            $response = "Updates installed. No reboot is required."
        }
    } else {
        Write-Host "No updates available."
        $response = "No updates available."
    }
    $chatResponse = ChatGPT -model $model -prompt "Please analyze the Windows updates and their impact: $installSummary"
    Write-Host "ChatGPT Analysis: $chatResponse"
    Log-Response -response $chatResponse
    Copy-ToClipboard -text $chatResponse
    Log-Event -message "ChatGPT analysis of updates has been logged and copied to clipboard."
    Write-Host "Update summary has been logged, copied to the clipboard, and recorded in the Event Viewer."
    return $chatResponse
}
