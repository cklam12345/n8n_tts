# tts.ps1 (The Playback Fix)

# Define variables for clarity
$ModelPath = "models\hal.onnx"
$OutputFile = "output.wav"
$InputFile = "output.txt"

# 1. Write the text file
"Hello Chin Keong, My name is Hal # tts_n8n.ps1
# This script expects the text to speak as the first argument ($args[0])

# --- Configuration ---
$TextToSpeak = $args[0]
$ModelPath = "models\hal.onnx"
$OutputFile = "output.wav"
$PiperExe = "C:\Users\LaCh616\Documents\installdeapLite\deapLite\piper\piper.exe" # <-- Use ABSOLUTE path
$WorkingDirectory = "C:\Users\LaCh616\Documents\installdeapLite\deapLite\piper\" # <-- Use ABSOLUTE path

# --- Logic ---

# 1. Change to the Piper directory so relative model paths work
Set-Location -Path $WorkingDirectory

# 2. Convert text to speech
# We pass the text directly using the --text flag for simple execution
& $PiperExe --model $ModelPath --output_file $OutputFile --text $TextToSpeak

# 3. Get absolute path to the WAV file
$FullPath = Join-Path $WorkingDirectory $OutputFile

# 4. Play the audio file
(New-Object Media.SoundPlayer $FullPath).PlaySync(), How are you feeling today, I can open the pod bay door for you" | Out-File -FilePath $InputFile -Encoding utf8

# 2. Run Piper using the input file flag (This part is now confirmed to work!)
piper.exe --model $ModelPath --output_file $OutputFile --input_file $InputFile

# 3. Play the audio file using the ABSOLUTE path.
# This line gets the absolute path of the current location and joins it with the filename.
$FullPath = Join-Path (Get-Location) $OutputFile

# Now use the absolute path for playback:
(New-Object Media.SoundPlayer $FullPath).PlaySync()