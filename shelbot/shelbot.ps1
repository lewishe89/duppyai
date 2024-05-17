# Main script to orchestrate ShelBot functionalities

# Import helper functions
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$scriptDir\helpers\EventLogHelpers.ps1"
. "$scriptDir\helpers\ChatGPTHelpers.ps1"
. "$scriptDir\helpers\SystemHelpers.ps1"
. "$scriptDir\helpers\ShowHelp.ps1"

# Create event log source
Create-EventLogSource -source "ShelBot"

# Check if at least one argument was provided
if ($args.Count -lt 1 -or $args[0] -eq "-Help") {
    Show-Help
    exit 0
}

# Get the model or command
$modelOrCommand = $args[0]
$args = $args[1..$args.Length]

# Initialize the prompt variable
$prompt = ""

# Check if the command is to get error events
if ($modelOrCommand -eq "-GetErrors") {
    $days = 1
    $application = ""
    if ($args.Count -ge 1) {
        $days = [int]$args[0]
    }
    if ($args.Count -ge 2) {
        $application = $args[1]
    }
    $errorText = Get-ErrorEvents -days $days -application $application
    if (-not [string]::IsNullOrWhiteSpace($errorText)) {
        $response = ChatGPT -model $defaultModel -prompt "Please review the following Windows Event Viewer errors for '$application' and provide some insights: $errorText"
        Write-Host "ShelBot Analysis: $response"
        Log-Response -response $response
        Copy-ToClipboard -text $response
        Log-Event -message "ShelBot analysis of error events for '$application' has been logged and copied to clipboard."
        Write-Host "Analysis has been logged, copied to the clipboard, and recorded in the Event Viewer."
    }
    exit 0
}

# Check if the command is to check for and install updates
if ($modelOrCommand -eq "-CheckUpdates") {
    $updateSummary = Check-And-Install-WindowsUpdates -model $defaultModel
    Write-Host "ShelBot Analysis: $updateSummary"
    Log-Response -response $updateSummary
    Copy-ToClipboard -text $updateSummary
    Log-Event -message "ShelBot analysis of updates has been logged and copied to clipboard."
    Write-Host "Update summary has been logged, copied to the clipboard, and recorded in the Event Viewer."
    exit 0
}

# Otherwise, treat it as a model and process the prompt
$model = $modelOrCommand
if ($args[0] -eq "-File") {
    if ($args.Count -lt 2) {
        Write-Host "Error: No file specified"
        exit 1
    }
    $prompt = Get-Content $args[1] -Raw
} elseif ($args[0] -eq "-Pipe") {
    $prompt = [Console]::In.ReadToEnd()
} else {
    $prompt = $args -join " "
}

# Validate prompt
if ([string]::IsNullOrWhiteSpace($prompt)) {
    Write-Host "Error: Prompt cannot be empty"
    exit 1
}

# Call the ChatGPT function and display the response
$response = ChatGPT -model $model -prompt $prompt
Write-Host "ShelBot ($model): $response"
Log-Response -response $response
Copy-ToClipboard -text $response
Log-Event -message "ShelBot response logged and copied to clipboard."
Write-Host "Response has been logged, copied to the clipboard, and recorded in the Event Viewer."
