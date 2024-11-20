#!/bin/bash

SELECTION="$(printf "\
Minecraft Launcher\0icon\x1fminecraft-launcher\n\
Modrinth\0icon\x1f$HOME/Non_Repo_Apps/AppImage/Modrinth/ModrinthApp.png\n\
The Elder Scrolls V: Skyrim Special Edition\0icon\x1fsteam_icon_489830\n\
Warframe\0icon\x1fsteam_icon_230410\n\
" | fuzzel --dmenu -l 4 -p "Game App: \
")"

case $SELECTION in
	*"Minecraft Launcher")
        exec minecraft-launcher;;
    *"Modrinth")
        exec "~/Non_Repo_Apps/AppImage/Modrinth/Modrinth App_0.8.9_amd64.AppImage";;
    *"The Elder Scrolls V: Skyrim Special Edition")
        exec steam steam://rungameid/489830;;
    *"Warframe")
        exec steam steam://rungameid/230410;;
esac
