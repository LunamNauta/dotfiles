# Installation
# Install Instructions

## Windows (pwsh)
```
git clone https://github.com/LunamNauta/dotfiles .
if(Test-Path $env:LOCALAPPDATA\nvim){Remove-Item $env:LOCALAPPDATA\nvim -Force}
New-Item -ItemType Junction -Path $env:LOCALAPPDATA -name nvim -value $pwd/nvim
```
