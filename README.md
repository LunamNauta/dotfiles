# Install Instructions

## Windows (pwsh)
```

$FIREFOX_PROFILE_NAME = <profile-name>

git clone https://github.com/LunamNauta/dotfiles .

# Add symlinks for 'firefox'
$FIREFOX_PROFILE_PATH = $env:APPDATA + "\Mozilla\Firefox\Profiles\" + $FIREFOX_PROFILE_NAME
git clone https://github.com/arkenfox/user.js/ $FIREFOX_PROFILE_PATH
if(Test-Path $FIREFOX_PROFILE_PATH\user-overrides.js){Remove-Item $FIREFOX_PROFILE_PATH\user-overrides.js -Force}
New-Item -ItemType SymbolicLink -Path $FIREFOX_PROFILE_PATH -name user-overrides.js -value $pwd/firefox/user-overrides.js
cmd.exe /c $FIREFOX_PROFILE_PATH\updater.bat

# Add symlinks for 'nvim'
if(Test-Path $env:LOCALAPPDATA\nvim){Remove-Item $env:LOCALAPPDATA\nvim -Force}
New-Item -ItemType Junction -Path $env:LOCALAPPDATA -name nvim -value $pwd/nvim

```
