#Add symlinks for 'firefox'
function Install-Firefox{
    $FIREFOX_PROFILE_NAME = Read-Host "Firefox Profile Name"
    $FIREFOX_PROFILE_PATH = $env:APPDATA + "\Mozilla\Firefox\Profiles\" + $FIREFOX_PROFILE_NAME
    if (Test-Path $FIREFOX_PROFILE_PATH){
        $ARKENFOX_REPO = "https://github.com/arkenfox/user.js/"
        if (-Not (Test-Path $FIREFOX_PROFILE_PATH\.git)){
            git -C $FIREFOX_PROFILE_PATH init .
            git -C $FIREFOX_PROFILE_PATH remote add origin $ARKENFOX_REPO
            git -C $FIREFOX_PROFILE_PATH pull origin master
        }
        if (Test-Path $FIREFOX_PROFILE_PATH\user-overrides.js){Remove-Item $FIREFOX_PROFILE_PATH\user-overrides.js -Force}
        New-Item -ItemType SymbolicLink -Path $FIREFOX_PROFILE_PATH -name user-overrides.js -value $pwd/firefox/user-overrides.js
        & "$FIREFOX_PROFILE_PATH\updater.bat"
    }
    else{Write-Host "Error: Given Firefox profile does not exist."}
}

#Add symlinks for 'nvim'
function Install-Nvim{
    if (Test-Path $env:LOCALAPPDATA\nvim){Remove-Item $env:LOCALAPPDATA\nvim -Force}
    New-Item -ItemType Junction -Path $env:LOCALAPPDATA -name nvim -value $pwd/nvim
}

if ($args.count -ne 0){
    for ($a = 0; $a -lt $args.count; $a++){
        if ($args[$a] -eq "firefox"){Install-Firefox}
        elseif ($args[$a] -eq "nvim"){Install-Nvim}
    }
}
else{
    Install-Firefox
    Install-Nvim
}
