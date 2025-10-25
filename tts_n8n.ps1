Set-Location "C:\Users\LaCh616\Documents\installdeapLite\deapLite\backend"
cmd /c .\venv\Scripts\activate.bat
Set-Location "C:\Users\LaCh616\n8n_tts"
# tts_n8n.ps1
# This script expects the text to speak as the first argument ($args[0])

# --- Dynamic Path Resolution ---
# The $PSScriptRoot variable reliably gets the directory where the script is saved.
$ScriptRoot = $PSScriptRoot
$TextToSpeak = $args[0]

# Define paths relative to the script's location
$ModelPath = "models\hal.onnx"
$OutputFile = "output.wav"

# Construct the absolute path to the Piper executable
$PiperExe = Join-Path $ScriptRoot "piper"

# --- Logic ---

# 1. Change to the script's directory (ensures all relative paths work)
Set-Location -Path $ScriptRoot

# 2. Convert text to speech
# Use the call operator (&) to ensure the executable runs correctly
& piper --model $ModelPath --output_file $OutputFile --text $TextToSpeak

# 3. Play the audio file
# Construct the absolute path to the WAV file for reliable playback
$FullPath = Join-Path $ScriptRoot $OutputFile

# Play the audio file
(New-Object Media.SoundPlayer $FullPath).PlaySync()