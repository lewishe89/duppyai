# EventLogHelpers.ps1

function Create-EventLogSource {
    param (
        [string]$source,
        [string]$logName = "Application"
    )
    try {
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            New-EventLog -LogName $logName -Source $source
        }
    } catch {
        Write-Warning "Could not create event log source. You might need to run this script as an administrator."
    }
}

function Log-Event {
    param (
        [string]$message,
        [string]$entryType = "Information"
    )
    try {
        Write-EventLog -LogName "Application" -Source "ChatGPTScript" -EventId 1000 -EntryType $entryType -Message $message
    } catch {
        Write-Warning "Could not write to the Event Log. You might need to run this script as an administrator."
    }
}

function Get-ErrorEvents {
    param (
        [string]$application,
        [int]$days = 1,
        [string]$model = $defaultModel
    )
    try {
        $filter = @{
            LogName = 'Application'
            Level = 2
            StartTime = (Get-Date).AddDays(-$days)
        }
        if ($application) {
            $filter.ProviderName = $application
        }
        $events = Get-WinEvent -FilterHashtable $filter -MaxEvents 50
    } catch {
        Write-Warning "Could not read from the Event Log. You might need to run this script as an administrator."
        return ""
    }
    if ($events.Count -eq 0) {
        Write-Host "No error events found for '$application' in the last $days day(s)."
        return ""
    }
    $errorLogFile = "$env:USERPROFILE\Documents\event_viewer_errors.log"
    $errorText = ""
    $events | ForEach-Object {
        $entry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ID: $($_.Id) - Source: $($_.ProviderName) - Message: $($_.Message)"
        Add-Content -Path $errorLogFile -Value $entry
        $errorText += $entry + "`n"
    }
    Write-Host "Error events have been logged to $errorLogFile"
    return $errorText
}
