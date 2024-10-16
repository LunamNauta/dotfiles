$FIREFOX_PROFILE_NAME = Read-Host "Firefox Profile Name"

# Add symlinks for 'firefox'
$FIREFOX_PROFILE_PATH = $env:APPDATA + "\Mozilla\Firefox\Profiles\" + $FIREFOX_PROFILE_NAME
if (Test-Path $FIREFOX_PROFILE_PATH){
    git clone https://github.com/arkenfox/user.js/ $FIREFOX_PROFILE_PATH
    if(Test-Path $FIREFOX_PROFILE_PATH\user-overrides.js){Remove-Item $FIREFOX_PROFILE_PATH\user-overrides.js -Force}
    New-Item -ItemType SymbolicLink -Path $FIREFOX_PROFILE_PATH -name user-overrides.js -value $pwd/firefox/user-overrides.js
    & "$FIREFOX_PROFILE_PATH\updater.bat"
}
else{Write-Host "Error: Given Firefox profile does not exist."}

# Add symlinks for 'nvim'
if(Test-Path $env:LOCALAPPDATA\nvim){Remove-Item $env:LOCALAPPDATA\nvim -Force}
New-Item -ItemType Junction -Path $env:LOCALAPPDATA -name nvim -value $pwd/nvim
