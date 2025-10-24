\## 1\\. Make the PowerShell Script Generic (`tts\_n8n.ps1`)



The key change is using the environment variable `$env:USERPROFILE` (or `(Get-Location)` if preferred) to construct the absolute paths dynamically, removing the hardcoded username.



\*\*Use this generic content for your `tts\_n8n.ps1` file:\*\*



```powershell

\# tts\_n8n.ps1

\# This script expects the text to speak as the first argument ($args\[0])



\# --- Dynamic Path Resolution ---

\# The $PSScriptRoot variable reliably gets the directory where the script is saved.

$ScriptRoot = $PSScriptRoot

$TextToSpeak = $args\[0]



\# Define paths relative to the script's location

$ModelPath = "models\\hal.onnx"

$OutputFile = "output.wav"



\# Construct the absolute path to the Piper executable

$PiperExe = Join-Path $ScriptRoot "piper.exe"



\# --- Logic ---



\# 1. Change to the script's directory (ensures all relative paths work)

Set-Location -Path $ScriptRoot



\# 2. Convert text to speech

\# Use the call operator (\&) to ensure the executable runs correctly

\& $PiperExe --model $ModelPath --output\_file $OutputFile --text $TextToSpeak



\# 3. Play the audio file

\# Construct the absolute path to the WAV file for reliable playback

$FullPath = Join-Path $ScriptRoot $OutputFile



\# Play the audio file

(New-Object Media.SoundPlayer $FullPath).PlaySync()

```



\### Why this is Generic:



&nbsp; \* \*\*`$PSScriptRoot`\*\*: When PowerShell executes a script, this variable is automatically set to the \*\*full path of the directory containing the script\*\*. This completely eliminates the need for any usernames or hardcoded root paths.

&nbsp; \* \*\*`Join-Path`\*\*: Safely combines paths (e.g., `$ScriptRoot` + `"piper.exe"`), regardless of whether the path components have trailing backslashes.



-----



\## 2\\. Generic n8n Integration (Execute Command Node)



Since the script itself now handles path resolution, the n8n \*\*Execute Command\*\* node only needs to know two things: which PowerShell interpreter to use and which script to run.



| Setting | Value | Notes |

| :--- | :--- | :--- |

| \*\*Command\*\* | `powershell.exe` | Standard Windows executable. |

| \*\*Arguments\*\* | \*\*`.\\tts\_n8n.ps1`\*\* | Run the script (relative to the Working Directory). |

| | \*\*`{{ $json.text\_to\_read }}`\*\* | Pass your dynamic text as the first argument. |

| \*\*Working Directory\*\* | `C:\\path\\to\\piper\_folder` | \*\*CRITICAL:\*\* This must be set to the \*\*ABSOLUTE PATH\*\* where the user installs the `piper.exe` and `tts\_n8n.ps1` files. This is the \*\*only part\*\* the new user must manually configure once in n8n. |



By using the Working Directory to establish the script's root and then relying on `$PSScriptRoot` within the script, you achieve maximum portability for the code itself. The new user just needs to update the single "Working Directory" field in n8n to match their PC's file structure.



