# ShowHelp.ps1

function Show-Help {
    Write-Host "Usage: .\duppyai.ps1 <model|command> [options]"
    Write-Host ""
    Write-Host "Commands and options:"
    Write-Host "  <model>                   Specify the model to use (e.g., gpt-3.5-turbo, gpt-4). Default is gpt-4."
    Write-Host "  -Prompt <prompt>          Provide a prompt directly."
    Write-Host "  -File <file>              Provide a file containing the prompt."
    Write-Host "  -Pipe                     Read the prompt from standard input."
    Write-Host "  -GetErrors <days> <app>   Get error events from the Event Viewer for the specified application in the last <days> days."
    Write-Host "  -CheckUpdates             Check for and install Windows updates, then provide an analysis using DuppyAI."
    Write-Host "  -Help                     Show this help message."
}
