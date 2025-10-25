$UserProfile = [Environment]::GetFolderPath("UserProfile")
$InputFile = Join-Path $UserProfile "n8n_tts\input.txt"
$TextToSpeak = Get-Content $InputFile -Raw

# 1. Change to backend directory and activate virtual environment
$BackendPath = Join-Path $UserProfile "Documents\installdeapLite\deapLite\backend"
Set-Location $BackendPath
cmd /c "venv\Scripts\activate.bat"

# 2. Change to TTS script directory
$TTSPath = Join-Path $UserProfile "n8n_tts"
Set-Location $TTSPath

# 3. Define paths
$ModelPath = "models\hal.onnx"
$OutputFile = "output.wav"
$PiperExe = "piper"

# 4. Run Piper with the provided text
& $PiperExe --model $ModelPath --output_file $OutputFile $TextToSpeak

# 5. Play the audio
$FullPath = Join-Path $PSScriptRoot $OutputFile
(New-Object Media.SoundPlayer $FullPath).PlaySync()