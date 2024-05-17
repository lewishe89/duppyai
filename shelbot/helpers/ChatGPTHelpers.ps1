# ChatGPTHelpers.ps1

# Ensure the API key is set
$apiKey = $env:OPENAI_API_KEY
if (-not $apiKey) {
    Write-Error "OpenAI API key is not set. Please set the 'OPENAI_API_KEY' environment variable."
    exit 1
}

# Default model
$defaultModel = "gpt-4o"

function ChatGPT {
    param (
        [string]$prompt,
        [string]$model = $defaultModel
    )
    $body = @{
        model    = $model
        messages = @(
            @{
                role    = "system"
                content = "You are a helpful assistant."
            },
            @{
                role    = "user"
                content = $prompt
            }
        )
    } | ConvertTo-Json
    try {
        $response = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" `
            -Headers @{
                "Content-Type"  = "application/json"
                "Authorization" = "Bearer $apiKey"
            } `
            -Method Post `
            -Body $body
        $response.choices[0].message.content
    } catch {
        $errorMsg = "Failed to get a response from the ChatGPT API: $_"
        Write-Error $errorMsg
        Write-EventLog -LogName "Application" -Source "ChatGPTScript" -EventId 1001 -EntryType Error -Message $errorMsg
        exit 1
    }
}

function Log-Response {
    param (
        [string]$response
    )
    $logFile = "$env:USERPROFILE\Documents\chatgpt_responses.log"
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $response"
}

function Copy-ToClipboard {
    param (
        [string]$text
    )
    $text | Set-Clipboard
}
