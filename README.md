# ShelBot

ShelBot is a PowerShell script designed to interact with the OpenAI API, allowing users to perform various tasks such as analyzing Windows Event Viewer logs, checking for and installing Windows updates, and more. The script leverages multiple helper functions to ensure modularity and maintainability.

## Features

- **ChatGPT Integration**: Send prompts to OpenAI's ChatGPT API and receive responses.
- **Event Log Analysis**: Retrieve and analyze error events from the Windows Event Viewer.
- **System Updates**: Check for and install Windows updates, and analyze their impact.
- **Logging and Clipboard**: Log responses and copy them to the clipboard for easy access.

## Requirements

- PowerShell 5.1 or later
- An OpenAI API key (set as an environment variable `OPENAI_API_KEY`)
- The `PSWindowsUpdate` module for Windows updates functionality

## Setup

1. **Set up the OpenAI API key**:
    ```powershell
    setx OPENAI_API_KEY "your_openai_api_key"
    ```

2. **Install the `PSWindowsUpdate` module**:
    ```powershell
    Install-Module -Name PSWindowsUpdate -Force
    ```

3. **Clone the repository and navigate to the script directory**:
    ```bash
    git clone https://github.com/yourusername/shelbot.git
    cd shelbot
    ```

## Usage

The main script file is `shelbot.ps1`. You can run it with different commands and options to perform various tasks.

### Commands and Options

- `<model>`: Specify the model to use (e.g., `gpt-3.5-turbo`, `gpt-4`). Default is `gpt-4`.
- `-Prompt <prompt>`: Provide a prompt directly.
- `-File <file>`: Provide a file containing the prompt.
- `-Pipe`: Read the prompt from standard input.
- `-GetErrors <days> <app>`: Get error events from the Event Viewer for the specified application in the last `<days>` days.
- `-CheckUpdates`: Check for and install Windows updates, then provide an analysis using ShelBot.
- `-Help`: Show the help message.

### Examples

1. **Send a direct prompt to ChatGPT**:
    ```powershell
    .\shelbot.ps1 "gpt-4" -Prompt "Explain the theory of relativity"
    ```

2. **Send a prompt from a file**:
    ```powershell
    .\shelbot.ps1 "gpt-4" -File "prompt.txt"
    ```

3. **Get error events from the Event Viewer for the last 3 days for the application 'MyApp'**:
    ```powershell
    .\shelbot.ps1 -GetErrors 3 "MyApp"
    ```

4. **Check for and install Windows updates, then analyze the updates**:
    ```powershell
    .\shelbot.ps1 -CheckUpdates
    ```

5. **Show help message**:
    ```powershell
    .\shelbot.ps1 -Help
    ```

## Helper Scripts

The script uses several helper scripts located in the `helpers` directory:

- `EventLogHelpers.ps1`: Functions for handling event logs.
- `ChatGPTHelpers.ps1`: Functions for interacting with the ChatGPT API.
- `SystemHelpers.ps1`: Functions for system-related tasks like checking for updates.
- `ShowHelp.ps1`: Function to display help information.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
